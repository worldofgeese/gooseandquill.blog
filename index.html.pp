#lang pollen
◊(require racket/list pollen/pagetree pollen/template pollen/private/version)
<!DOCTYPE html>
<html lang="en" class="gridded">
    <head>
        <meta charset="utf-8">
        <meta name="generator" content="Racket ◊(version) + Pollen ◊|pollen:version|">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Goose and Quill</title>
        <link rel="stylesheet" href="/styles.css" media="screen">
        ◊|meta-favicons|
    </head>
    <body>
        <header class="main">
            <p><a href="/" class="home">Goose and Quill</a> </p>
            <nav>
                <ul>
                    <li><a href="/about.html">About</a></li>
                    <li><a href="/feed.xml" class="rss" title="Subscribe to feed">Use RSS?</a></li>
                </ul>
            </nav>
        </header>
        
        ◊for/s[post (latest-posts 10)]{
           <article>
           ◊(hash-ref post 'header_html)
           ◊(hash-ref post 'html)
           </article>
           <hr>
        }

        <footer class="main">
            <ul>
                <li><a href="/feed.xml" class="rss" title="Subscribe to feed">RSS</a></li>
                <li><a href="mailto:comments@gooseandquill.blog">comments@gooseandquill.blog</a></li>
                <li>Source code <a href="https://github.com/worldofgeese/gooseandquill.blog">on GitHub</a></li>
                <li>Valid <a href="https://validator.w3.org/nu/?doc=https%3A%2F%2Fgooseandquill.blog%2F">HTML5</a> + CSS</li>
            </ul>
        </footer>
    </body>
</html>
