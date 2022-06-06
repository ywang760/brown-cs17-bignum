#lang racket/base
(provide digit-add
         digit-sub
         digit-mult
         digit-quo
         digit-rem)

;; This file provides the built-in arithmetic procedures required
;; to implement limited precision arithmetic with bignums.

;; digit-add : num * num -> num

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the sum of the a and b, or an error if
;;         a, b or their sum is outside the range [0,99]

(define (digit-add a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99)
           (<= (+ a b) 99))
      (+ a b)
      (error 'digit-add "inputs or output out of range. tried (+ ~a ~a) " a b)))


;; digit-sub : num * num -> num

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the result of subtracting b from a, or an error if
;;         a or b or their difference is outside the range [0,99]

(define (digit-sub a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99)
           (<= 0 (- a b)))
      (- a b)
      (error 'digit-sub "inputs or output out of range. tried (- ~a ~a) " a b)))

;; digit-mult : num * num -> num

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the product of the inputs, or an error if
;;         a or b or their product is outside the range [0,99]

(define (digit-mult a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99)
           (<= (* a b) 99))
      (* a b)
      (error 'digit-mult "inputs or output out of range. tried (* ~a ~a) " a b)))

;; digit-quo : num * num -> num

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the quotient of dividend a and divisor b, or an error if
;;         a or b or their quotient is outside the range [0,99]

(define (digit-quo a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99))
      (quotient a b)
      (error 'digit-quo "inputs or output out of range. tried (quotient ~a ~a) " a b)))

;; digit-rem : num * num -> num

;; Input: two natural numbers between 0 and 99, a and b
;; Output: the remainder of dividend a and divisor b, or an error if
;;         a or b or the remainder is outside the range [0,99]

(define (digit-rem a b)
  (if (and (integer? a)
           (integer? b)
           (<= 0 a)
           (<= a 99)
           (<= 0 b)
           (<= b 99))
      (remainder a b)
      (error 'digit-rem "inputs or output out of range. tried (remainder ~a ~a) " a b)))
