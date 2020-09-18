---
layout: post
title: "Spot the Bug: Golang Hashes"
date: 2020-09-18 02:41:14 -0700
excerpt: Suppose we want to compute the md5, sha1, and sha256 sums for some string "Foo Bar". What's wrong with this routine?
tags: golang other md5 sha1 sha256 hash
---

<span class='tagline'>{{ page.excerpt }}</span>

# Problem

Golang gives us an interface type <a href="https://golang.org/pkg/hash/"> `hash.Hash` </a> to be: 

> the common interface implemented by all hash functions. 

For example, the packages 
<a href="https://golang.org/pkg/crypto/md5/">`crypto/md5`</a>, 
<a href="https://golang.org/pkg/crypto/sha256/">`crypto/sha1` </a>, and 
<a href="https://golang.org/pkg/crypto/sha256/">`crypto/sha256` </a> each define an implementation of that interface.

In the following example, we invoke the `Sum` method on that interface to hash a string, "Foo Bar", three ways. But something is wrong.

{% highlight golang %}
package main

import (
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"fmt"
)

func main() {
	// convert the demo input to a byte slice
	input := []byte("Foo Bar")

	// calculate the hashes
	a := md5.New().Sum(input)
	b := sha1.New().Sum(input)
	c := sha256.New().Sum(input)

	// print the hex-encoded hashes
	fmt.Printf("%x\n", a)
	fmt.Printf("%x\n", b)
	fmt.Printf("%x\n", c)
}
{% endhighlight golang %}

Here is the output:
```
↳ go run main.go
466f6f20426172d41d8cd98f00b204e9800998ecf8427e
466f6f20426172da39a3ee5e6b4b0d3255bfef95601890afd80709
466f6f20426172e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855
```

# Hint

Notice the prefix `466f6f20426172` in each of the hash outputs. You might be surprised to find that the three hashes all coincidentally prepend the same byte sequence. That's because this is no coincidence at all!

If we decode the hex, we see that it actually holds the hash input "Foo Bar"! That can't be right.

```sh
↳ echo 466f6f20426172 | xxd -r -p | xxd
00000000: 466f 6f20 4261 72                        Foo Bar
```

# Answer

Let's consult the docs for the `hash.Hash` interface:

{% highlight golang %}
type Hash interface {
    // Write (via the embedded io.Writer interface) adds more data to the running hash.
    // It never returns an error.
    io.Writer

    // Sum appends the current hash to b and returns the resulting slice.
    // It does not change the underlying hash state.
    Sum(b []byte) []byte

    // Reset resets the Hash to its initial state.
    Reset()

    // Size returns the number of bytes Sum will return.
    Size() int

    // BlockSize returns the hash's underlying block size.
    // The Write method must be able to accept any amount
    // of data, but it may operate more efficiently if all writes
    // are a multiple of the block size.
    BlockSize() int
}
{% endhighlight golang %}

We learn that the receiver method `Sum` does not do what one might intuit (or, at least _I_ was surprised). The `Sum` method just concatenates its argument with a running hash of its internal buffer contents. 

So, the prefix is the hex-encoded "Foo Bar" input. The tail comes from the initial state of the running hash, i.e. the hash of an empty byte sequence.

|           | Prefix            | Blank Hash                                                        |
|-----------|-------------------|-------------------------------------------------------------------|
| md5       | 466f6f20426172    | d41d8cd98f00b204e9800998ecf8427e                                  |
| sha1      | 466f6f20426172    | da39a3ee5e6b4b0d3255bfef95601890afd80709                          |
| sha256    | 466f6f20426172    | e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855  |

How do we fix the example?

# Correct Usage

We can use the embedded `io.Writer` methods to push the input string onto the hash's internal buffer, and set the prefix to `nil`. Alternatively, just use one of the various convenience methods provided in the packages.

{% highlight golang %}
package main

import (
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"fmt"
)

func main() {
	// convert the demo input to a byte slice
	input := []byte("Foo Bar")

	// calculate the hashes
	ha := md5.New()
	ha.Write(input)
	a := ha.Sum(nil)

	hb := sha1.New()
	hb.Write(input)
	b := hb.Sum(nil)

	hc := sha256.New()
	hc.Write(input)
	c := hc.Sum(nil)

	// alternate: calculate the hashes
	alta := md5.Sum(input)
	altb := sha1.Sum(input)
	altc := sha256.Sum256(input)

	// print the hex-encoded hashes
	fmt.Printf("%x\n%x\n", a, alta)
	fmt.Printf("%x\n%x\n", b, altb)
	fmt.Printf("%x\n%x\n", c, altc)
}
{% endhighlight golang %}

# Conclusion

If you're a meticulous, hawk-eyed reader of the docs, then you'll likely have found this exercise pretty silly. But I sometimes tend to skim the details, especially when the function names look _so_ very self-explanatory and simple. For example, `Sum([]byte) []byte` on a hash interface.

In dev work as in life, humbling mistakes like these can be a helpful reminder for me to be careful and check my assumptions more thoroughly, especially when working with something new.
