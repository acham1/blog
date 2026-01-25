# Blog

My personal blog and sandbox. Built with Jekyll and hosted with GitHub Pages. 

Come visit any time at https://blog.alanch.am :)

## Setup

Requires Ruby 3.3+. Using [mise](https://mise.jdx.dev/) is recommended:

```sh
mise install
bundle install
```

## Development

Serve locally with live reload:
```sh
make serve
```

Build static site to `docs/`:
```sh
make build
```

## Deploy
Any changes to the `docs` directory are deployed when merged to master.
