#lang racket

(provide run-game)

(define (run-game dialogue-tree)
  (define root-node (hash-ref dialogue-tree 'root))
  (let loop ([node root-node])
    (define choices (hash-ref node 'choices))
      (display (hash-ref node 'text))
      (when (eq? #t (hash-ref node 'leaf #f)) ; stop at leaf nodes
        (exit 0))
      (for ([choice choices]
            [i (in-naturals 1)])
        (printf "\n~a. ~a" i (hash-ref choice 'text)))
      (define index (await-valid-response choices))
      (define choice (list-ref choices index))
      (define key (hash-ref choice 'next))
      (define next-node (hash-ref dialogue-tree (string->symbol key)))
      (loop next-node)))

(define (await-valid-response choices)
  (define num-choices (length choices))
  (let loop ()
    (display "\n>>> ")
    (define input (read-line))
    (define number (string->number (string-trim input)))
    (define is-valid-index?
      (and number
        (integer? number)
        (>= number 1)
        (<= number num-choices)))
    (cond
      [is-valid-index?
        (define index (- number 1))
        index]
      [else
        (printf "Invalid choice, input a number between 1 and ~a" num-choices)
        (loop)])))