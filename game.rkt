#lang racket

(provide run-game)

(define (run-game dialogue-tree)
  (define root-node (hash-ref dialogue-tree 'root))
  (let loop ([node root-node])
    (define choices (hash-ref node 'choices '()))
      (display (hash-ref node 'text))
      (when (empty? choices)
        (exit 0))

      (for ([choice choices]
            [i (in-naturals 1)])
        (printf "\n~a. ~a" i (hash-ref choice 'text)))

      (define index (await-choice choices))
      (when (= index -1)
        (printf "Invalid choice, input a number between 1 and ~a" (length choices))
        (loop node))

      (define choice (list-ref choices index))
      (define key (hash-ref choice 'next))
      (define next-node (hash-ref dialogue-tree (string->symbol key)))
      (loop next-node)))

(define (await-choice choices)
  (display "\n>>> ")
  (define input (read-line))
  (define number (string->number (string-trim input)))
  (define is-valid-index?
    (and number
      (integer? number)
      (>= number 1)
      (<= number (length choices))))

  (if is-valid-index?
    (- number 1)
    -1))