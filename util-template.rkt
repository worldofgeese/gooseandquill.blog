#lang racket/base

(require racket/string
         racket/path
         pollen/core
         net/uri-codec
         "util-date.rkt"
         txexpr)

(provide (all-defined-out))

(define (pdfable? file-path)
  (string-contains? file-path ".poly"))

(define (pdfname page) (string-replace (path->string (file-name-from-path page))
                                       "poly.pm" "pdf"))
                                       
(define (source-listing p)
  (regexp-replace #px"(\\.html$)" (symbol->string p) ".pollen.html"))

(define (post-header post metas)
  (define updated (select-from-metas 'updated metas))
  (define updated-xexpr
    (cond [updated `((em "Updated " (time [[datetime ,updated]] ,(pubdate->english updated))) nbsp middot nbsp)]
          [else '("")]))

  (define timestamp-raw (select-from-metas 'published metas))
  (define timestamp
    (cond [timestamp-raw
           `("Scribbled " 
             (time [[datetime ,timestamp-raw]]
                   ,(pubdate->english timestamp-raw))
             nbsp middot nbsp)]
          [else '("")]))
  (define pdflink
    (cond [(string-prefix? (symbol->string post) "posts")
           `((a [[class "pdf"]
                 [href ,(string-append "/posts/" (pdfname (select-from-metas 'here-path metas)))]]
                "PDF") nbsp middot nbsp)]
          [else '("")]))
  `(header
    (h1 (a [[href ,(string-append "/" (symbol->string post))]] ,(select-from-metas 'title metas)))
    (p ,@timestamp
       ,@updated-xexpr
       ,@pdflink
       (a [[class "source-link"] [href ,(string-append "/" (source-listing post))]]
          loz "Pollen" nbsp "source"))))

(define (split-body-comments post-doc)
  (define (is-comment? tx)
    (and (txexpr? tx)
         (eq? (get-tag tx) 'section)
         (attrs-have-key? tx 'class)
         (string=? (attr-ref tx 'class) "comments")))

  (splitf-txexpr post-doc is-comment?))

(define meta-favicons
  "<link rel=\"apple-touch-icon-precomposed\" href=\"/css/favicon/goose.svg\" />
    <link rel=\"icon\" href=\"/css/favicon/goose.svg\" />
    <meta name=\"application-name\" content=\"&nbsp;\"/>
    <meta name=\"msapplication-TileColor\" content=\"#FFFFFF\" /> ")
