---
layout: post
title: Cube Roots by Newton's Method in Lisp
date: 2020-10-05 05:39:00 -0700
excerpt: Using basic elements of programming to compute cube roots.
tags: sicp lisp
---

<span class='tagline'>{{ page.excerpt }}</span>

Chapter §1.1 of SICP covers some basic elements of programming. In this selected exercise 1.8, we use Newton's Method and some of those elements to calculate cube roots.

In this solution, I demonstrate concepts such as:
- Lexical Scoping
- Compound Procedures
- Black Box Abstractions
- Conditional Expressions and Predicates
- First-Class Functions

# Problem
> Newton's method for cube roots is based on the fact that if y is an approximation to the cube root of x, then a better approximation is given by the value
>
> (x/y^2 + 2y)/3
>
> Use this formula to implement a cube-root procedure analagous to the square root procedure.

# Solution

{% highlight scheme %}
(define (cube-root x)
  (define (cube-root-iter guess)
    (if (good-enough? guess)
        guess
        (cube-root-iter (improve guess))))

  (define (good-enough? guess)
    (< (abs (- (expt guess 3) 
               x)) 
       0.001))

  (define (improve guess)
    (/ (+ (/ x
             (expt guess 2))
          (* 2 guess))
       3))

  (cube-root-iter 1.0))
{% endhighlight %}

In this solution I use the block structure (i.e. nested procedure definitions) to internalize sub-procedure implementations like `good-enough?` and `improve` without cluttering the global environment.

I can also reference the parent procedure's formal argument `x` from within these sub-procedures thanks to lexical scoping, keeping the function signature tighter. 

With a few trial runs, we see that our implementation is both simple and sane.

{% highlight scheme %}
(cube-root 1.0)
(cube-root -8.0)
(cube-root 64.0)
(cube-root -512.0)
(cube-root 1024.0)
; 1
; -2
; 4.000017449510739
; -8.000000025890593
; 10.07936863575223
{% endhighlight %}

You can give it a try yourself with this web-based <a href="https://inst.eecs.berkeley.edu/~cs61a/fa14/assets/interpreter/scheme.html">scheme interpreter</a>.

# Reference
The following link is a paid advertisement.

<iframe style="width:120px;height:240px;" marginwidth="0" marginheight="0" scrolling="no" frameborder="0" src="//ws-na.amazon-adsystem.com/widgets/q?ServiceVersion=20070822&OneJS=1&Operation=GetAdHtml&MarketPlace=US&source=ss&ref=as_ss_li_til&ad_type=product_link&tracking_id=acham1-20&language=en_US&marketplace=amazon&region=US&placement=0262510871&asins=0262510871&linkId=a6ace59defa13d2687dc99294fc2ba8b&show_border=true&link_opens_in_new_window=true"></iframe>
