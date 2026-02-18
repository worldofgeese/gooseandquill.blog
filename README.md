# Goose and Quill 🪿

A blog built with [Pollen](https://docs.racket-lang.org/pollen/index.html), a programmable publishing system for Racket.

**Live at [gooseandquill.blog](https://gooseandquill.blog)**

## How it works

Pollen generates static HTML and PDF from `.poly.pm` source files. A multi-stage [Containerfile](Containerfile) handles the full build pipeline: Racket + Pollen + XeLaTeX on UBI9 minimal, served by nginx in production.

The site is hosted on GitLab Pages, mirrored from this GitHub repo.

## Building

```bash
podman build -t quay.io/lavishleopard/gooseandquill.blog:builder --target builder .
podman push quay.io/lavishleopard/gooseandquill.blog:builder
```

## Local development

```bash
raco pollen start
```

Then browse to `http://localhost:8080`.

## Writing posts

Create a file in `posts/` named `your-post.poly.pm`:

```
#lang pollen

◊define-meta[title]{Your Post Title}
◊define-meta[published]{2026-01-15}

Your content here.
```

Then `make all` to build HTML, `make pdfs` for PDF versions.

## Features

- RSS feed (`feed.xml`)
- PDF generation via XeLaTeX
- Incremental builds via GNU Make
- Pollen source viewable as `.pollen.html` files
- [Semantic line wrapping](https://github.com/worldofgeese/gooseandquill.blog/commit/d35f0d40d2d1ce9e1f41086c69fe9fa6183af803)

## Dependencies

Racket, [Pollen](https://docs.racket-lang.org/pollen/Installation.html), XeLaTeX (via [TinyTeX](https://yihui.org/tinytex/)), Python 3, GNU Make, [HTML5 Tidy](http://www.html-tidy.org). All handled automatically by the Containerfile.

## License

See [LICENSE.md](LICENSE.md).

## Contributing

See [CONTRIBUTIONS.md](CONTRIBUTIONS.md).
