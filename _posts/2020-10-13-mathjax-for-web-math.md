---
layout: post
title: "Cool Find: MathJax for Web Math"
date: 2020-10-13 04:14:00 -0700
excerpt: "Adding LaTeX style math input for your web page is a two-line change."
tags: mathjax code
---

<span class='tagline'>{{ page.excerpt }}</span>

For a [recent post](/2020/10/10/risk-and-financial-crises.html) on Financial Markets, I needed a tool to format math equations. There's a cool library called [MathJax](https://www.mathjax.org/) that makes it a breeze. Just add these two lines in your `<head>` element:

```
<script src="https://polyfill.io/v3/polyfill.min.js?features=es6"></script>
<script id="MathJax-script" async src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-mml-chtml.js"></script>
```

The first is an optional polyfill to mimic modern features on old browsers. The second plucks the MathJax library off a CDN.

# Example
You can start writing LaTeX between the `$$` delimiters.
```
$$ \theta _{t}=\sin^{-1}(\frac{n_{i}\sin\theta _{i}}{n_{t}}) $$
```

The MathJax display engine handles the rest for you: 

$$ \theta _{t}=\sin^{-1}(\frac{n_{i}\sin\theta _{i}}{n_{t}}) $$

# Final Thoughts

For my post, I didn't need anything fancy, but I'm still very impressed from a glance at its feature list, including:
- alternative input notations by MathML and AsciiMath
- interactive expression explorer for accessibility
- **I mean, just right-click on the equation above and see what I'm talking about! 😮**

There is, however, a noticeable amount of latency as the math inputs render.
