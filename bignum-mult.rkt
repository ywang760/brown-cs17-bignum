;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname bignum-mult) (read-case-sensitive #t) (teachpacks ((lib "cs17.ss" "installed-teachpacks"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "cs17.ss" "installed-teachpacks")) #f)))
(require "bignum-operators.rkt")
(require "bignum-add.rkt")

;; Data Definition:
;; bignum: a natural number of arbitrary size represented as a list of digits
;; (0 - 9) with the "ones" digit being the first element, the "tens" digit being
;; the second, and so on. An empty list is a bignum and is treated as zero.
;; Example Data:
;; the number 5823 is represented as:
(define bn0 (cons 3 (cons 2 (cons 8 (cons 5 empty)))))
;; the number 0 is represented as:
(define bn1 empty)
;; the number 10 is represented as:
(define bn2 (cons 0 (cons 1 empty)))


;; bignum*: (bignum) * (bignum) -> (bignum)
;; input: two bignums, bignum1 and bignum2, that we want to multiply together
;; output: a bignum representing the product of bignum1 and bignum2

