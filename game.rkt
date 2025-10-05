#lang racket

(provide run-game)

(define (run-game dialogue-tree)
  (define root-node (hash-ref dialogue-tree 'root))
  (process-node dialogue-tree root-node))

(define (process-node tree node)
  (define choices (hash-ref node 'choices))
  (display (hash-ref node 'text))
  (for ([choice choices]
        [i (in-naturals 1)])
    (printf "\n~a. ~a" i (hash-ref choice 'text)))
  (process-user-response tree choices))

(define (process-user-response tree choices)
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
        (define choice (list-ref choices index))
        (define key (hash-ref choice 'next))
        (define next-node (hash-ref tree (string->symbol key)))
        (process-node tree next-node)]
      [else
        (printf "Invalid choice, input a number between 1 and ~a" num-choices)
        (loop)])))