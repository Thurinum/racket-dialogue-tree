#lang racket

(require json)
(require "game.rkt")

(define (main)
  (define args (current-command-line-arguments))
  (when (not (= 1 (vector-length args)))
    (displayln "Need one argument, path to JSON story file.")
    (exit 1))

  (define path (vector-ref args 0))
  (define dialogue-tree (call-with-input-file path read-json))
  (run-game dialogue-tree))

(main)