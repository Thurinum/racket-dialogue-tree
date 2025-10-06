#lang racket

(provide run-game)

(define (run-game root-node)
  (define dialogue-tree (hash-ref root-node 'dialogue))
  (define speakers (hash-ref root-node 'speakers))

  (let loop ([node (hash-ref dialogue-tree 'root)])
    (define choices (hash-ref node 'choices '()))
      (define speaker (find-speaker-name speakers node))
      (when (not (string=? "" speaker))
        (printf "[\033[1m~a\033[0m] " speaker))

      (display (hash-ref node 'text))

      (when (empty? choices)
        (exit 0))

      (for ([choice choices]
            [i (in-naturals 1)])
        (printf "\n~a. ~a" i (hash-ref choice 'text)))

      (define index (get-user-response choices))
      (when (= index -1)
        (printf "Invalid choice, input a number between 1 and ~a" (length choices))
        (loop node))

      (define choice (list-ref choices index))
      (define key (hash-ref choice 'next))
      (define next-node (hash-ref dialogue-tree (string->symbol key)))
      (loop next-node)))

(define (find-speaker-name speakers node)
  (define speaker-key (hash-ref node 'speaker "default"))
  (define speaker-node (hash-ref speakers (string->symbol speaker-key) #f))
  (when (not speaker-node)
    "")
  (define speaker-name (hash-ref speaker-node 'name))
  speaker-name)

(define (get-user-response choices)
  (display "\n\033[1m[User] \033[0m")
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