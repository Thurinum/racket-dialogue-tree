#lang racket

(require json)
(require "game.rkt")

(define (main)
  (define dialogue-tree (call-with-input-file "test.json" read-json))
  (run-game dialogue-tree))

(main)