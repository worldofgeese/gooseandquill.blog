◊(init-db)
◊(define-values (doc-body comments) (split-body-comments doc))
◊(define doc-body-html (->html (cdr doc-body)))
◊(define doc-header (->html (post-header here metas)))
◊(cond [(select-from-metas 'published metas) (save-post here metas doc-header doc-body-html)])
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <meta name="generator" content="Racket ◊(version) + Pollen ◊|pollen:version|">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>◊(select-from-metas 'title here)</title>
        <link rel="stylesheet" href="/styles.css" media="screen">
        ◊|meta-favicons|
    </head>
    <body>
        <header class="main">
            <p><a href="/index.html" class="home">Goose and Quill</a></p>
            <nav>
                <ul>
                    <li><a href="/about.html">About</a></li>
                    <li><a href="/feed.xml" class="rss">Use&nbsp;RSS?</a></li>
                </ul>
            </nav>
        </header>

        <article>
            ◊doc-header
            ◊doc-body-html
            ◊(->html comments)
        </article>
        <footer class="main">
            <ul>
                <li><a class="rss" href="/feed.xml">RSS</a></li>
                <li><a href="mailto:comments@gooseandquill.blog">comments@gooseandquill.blog</a></li>
                <li>Source code <a href="https://github.com/worldofgeese/gooseandquill.blog">on GitHub</a></li>
                <li>Valid <a href="https://validator.w3.org/nu/?doc=https%3A%2F%2Fgooseandquill.blog%2F">HTML5</a> + CSS</li>
            </ul>
        </footer>
    </body>
</html>
