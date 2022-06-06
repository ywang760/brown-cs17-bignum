;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname bignum-add) (read-case-sensitive #t) (teachpacks ((lib "cs17.ss" "installed-teachpacks"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "cs17.ss" "installed-teachpacks")) #f)))
(require "bignum-operators.rkt")

#lang racket/base
(provide bignum+)

;; QUESTIONS TO ASK DURING DESIGN CHECK:
;; Do you care about what the inputs/outputs look like (reverse order)?
;; Allowed to use > or < signs?
;; 

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


;; bignum+: (bignum) * (bignum) -> (bignum)
;; input: two bignums, bignum1 and bignum2, that we want to add together
;; output: a bignum representing the sum of bignum1 and bignum2
;;
;; Algorithm: add the first elements in the two bignum lists together
;; the first element in the output will be replaced by
;; the digit-rem of their sum and 10, and the digit-quo of their sum and 10
;; will be added to the next element (carry),
;; this process will be repeated to each element.
;; If one of the list element is empty (i.e. one bignum has more digits than the
;; other), we 

;; RD1: 2-digit number w/0 carry
;; OI: (cons 3 (cons 2 empty)) * (cons 5 (cons 4 empty))
;; RI: (cons 2 empty) * (cons 4 empty)
;; RO: (cons 6 empty)
;; cons digit-add of the first elements of OI onto RO?
;; OO: (cons 8 (cons 6 empty))

;; RD2: 1-digit number w/ carry
;; OI: (cons 9 empty) * (cons 7 empty)
;; RI: empty * empty
;; RO: empty
;; (cons (digit-rem (digit-add 9 7) 10)
;;    (cons (digit-quo (digit-add 9 7) 10) RO))
;; OO: (cons 6 (cons 1 empty))

;; RD3: 2-digit number w/ carry on first element
;; OI: (cons 8 (cons 2 empty)) * (cons 6 (cons 3 empty)
;; RI: (cons 2 empty) * (cons 3 empty)
;; RO: (cons 5 empty)
;; (cons (digit-rem (digit-add 8 6) 10)
;;       (cons (digit-add (digit-quo (digit-add 8 6) 10) RO))
;; OO: (cons 4 (cons 6 empty))

;; RD4: 2-digit number w/ carry on both elements
;; OI: (cons 8 (cons 7 empty)) * (cons 9 (cons 6 empty))
;; RI: (cons 7 empty) * (cons 6 empty)
;; RO: (cons 3 (cons 1 empty))
;; (cons (digit-rem (digit add 8 9) 10)
;;    (cons (digit-add (digit-quo (digit-add 8 9) 10)  (first RO))
;;        (rest of RO)))
;; OO: (cons 7 (cons 4 (cons 1 empty)))

;; RD5: 3-digit number w/ carry on all elements
;; OI: (cons 7 (cons 6 (cons 5 empty))) * (cons 9 (cons 8 (cons 7 empty)))
;; RI: (cons 6 (cons 5 empty)) * (cons 8 (cons 7 empty))
;; RO: (cons 4 (cons 3 (cons 1 empty)))
;; (cons (digit-rem (digit add 7 9) 10)
;;    (cons (digit-add (digit-quo (digit-add 7 9) 10)  (first RO))
;;        (rest of RO)))
;; OO: (cons 6 (cons 5 (cons 3 (cons 1 emtpy))))

;; RD6: 1-digit number plus a 3-digit number w/o carry
;; OI: (cons 4 empty) * (cons 3 (cons 9 (cons 5 empty)))
;; RI: empty * (cons 9 (cons 5 empty))
;; RO: (cons 9 (cons 5 empty))
;; (cons (digit-rem (digit add 4 3) 10)
;;    (cons (digit-add (digit-quo (digit-add 4 3) 10)  (first RO))
;;        (rest of RO)))
;; OO: (cons 7 (cons 9 (cons 5 empty)))

;; RD7: empty plus 2-digit number w/o carry
;; OI: empty * (cons 2 (cons 5 empty))
;; RI: n/a
;; RO: n/a
;; if either of the OI's are empty, return the other
;; OO: (cons 2 (cons 5 empty))

;; RD8: empty plus empty
;; OI: empty * empty
;; RI: n/a
;; RO: n/a
;; if both of the OI's are empty, return empty (fits with RD7)
;; OO: empty

;; RD9: 1-digit number plus a 3-digit number w/ carry
;; OI: (cons 5 empty) * (cons 7 (cons 9 (cons 9 empty)))
;; RI: empty * (cons 9 (cons 9 empty))
;; RO: (cons 9 (cons 9 empty))
;; (cons (digit-rem (digit add 5 7) 10)
;;    (cons (digit-add (digit-quo (digit-add 5 7) 10)  (first RO))
;;        (rest of RO)))
;; DOESN'T WORK
;; OO: (cons 2 (cons 0 (cons 0 (cons 1 empty))))

;; RD10: 3-digit w/ all carry again
;; OI: (cons 9 (cons 9 (cons 9 empty))) * (cons 9 (cons 0 (cons 9 empty)))
;; RI: (cons 9 (cons 9 empty)) + (cons 0 (cons 9 empty))
;; RO: (cons 9 (cons 8 (cons 1 empty)))
;;
;; OO: (cons 8 (cons 9 (cons 9 (cons 1 empty))))

;; RD11: 1 + 99
;; OI: (cons 1 empty) * (cons 9 (cons 9 empty))
;; RI: empty * (cons 9 empty)
;; RO: (cons 9 empty)
;; (cons (digit-rem (digit add 1 9) 10)
;;    (cons (digit-add (digit-quo (digit-add 1 9) 10)  (first RO))
;;        (rest of RO)))
;; OO:(cons 0 (cons 0 (cons 1 empty)))

(define (digit-rem-over-10 bignum1 bignum2 carry)
         (digit-rem
          (digit-add
           (digit-add (first bignum1) (first bignum2)) carry) 10))

(define (digit-quo-over-10 bignum1 bignum2 carry)
         (digit-quo
          (digit-add
           (digit-add (first bignum1) (first bignum2)) carry) 10))

(define (bignum+carry bignum1 bignum2 carry)
  (cond
    [(and (empty? bignum1) (empty? bignum2)) (cons carry empty)]
    [(and (empty? bignum1) (cons? bignum2))
     (cons (bignum+carry bignum2 (cons carry empty) 0))]
    [(and (empty? bignum2) (cons? bignum1))
     (cons (digit-add (first bignum1) carry) (rest bignum1))]
    [(and (cons? bignum1) (cons? bignum2))
        (cons (digit-rem-over-10 bignum1 bignum2 carry)
           (bignum+carry (rest bignum1) (rest bignum2)
                         (digit-quo-over-10 bignum1 bignum2 carry)))]))

;; (cons (digit-add (digit-quo-over-10 bignum1 bignum2)
   ;;           (first (bignum+ (rest bignum1) (rest bignum2))))
     ;;            (rest (bignum+ (rest bignum1) (rest bignum2)))))]))

(define (bignum+ bignum1 bignum2)
  (bignum+carry bignum1 bignum2 0))

(define bn3 (cons 9 (cons 9 empty)))
(define bn4 (cons 1 empty))

;; Test cases
(check-expect (bignum+ bn3 bn4) (cons 0 (cons 1 empty)))
