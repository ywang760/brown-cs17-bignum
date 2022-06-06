;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname bignum) (read-case-sensitive #t) (teachpacks ((lib "cs17.ss" "installed-teachpacks"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "cs17.ss" "installed-teachpacks")) #f)))
(require "bignum-operators.rkt")

;; Data Definition:
;; a digit is a natural num that is either 0, 1, 2, 3, 4, 5, 6, 7, 8, or 9
;; a bignum is either
;;   empty, which represents the number 0, or
;;   (cons item b) where item is a digit,
;;   and b is a bignum.
;; The first element of bignum represents the ones digit
;; of the number, while the second element of bignum represents the tens digit,
;; and so on (looks like reverse order).
;; A list of only 0's and no other digit is not a bignum.
;; As a consequence of this, no bignum can contain leading 0's

;; Example data of bignums:
;; 0: empty
;; 8: (cons 8 empty) or (list 8)
;; 82: (cons 2 (cons 8 empty)) or (list 2 8)
;; 594: (cons 4 (cons 9 (cons 5 empty))) or (list 4 9 5)

;; NONexample data of bignums:
;; (cons 0 empty) or (list 0)
;; (cons 8 (cons 0 empty)) or (list 8 0)
;; (cons 2 (cons 8 (cons 0 (cons 0 (cons 0 empty))))) or (list 2 8 0 0 0)
;; (cons 5 (cons 9 (cons 4 (cons 0 empty)))) or (list 4 9 5 0)


;; -----------------------------------------------------------------------------
;; addition:

;; Type Signature:
;;  bignum+: (bignum) * (bignum) -> (bignum)

;; I/O Specification:
;;  Input: bignum1 and bignum2, two bignums that we want to add together
;;  Output: a bignum that is the sum of bignum1 and bignum2

;; Recursion Diagrams (Test Cases):
;;  (AR stands for arithmetic representation)

;; For simplification,
;;    (digit-rem-10 n) means the remainder of n over 10;
;;    (digit-quo-10 n) means the quotient of n over 10;
;;    these will be numeric results under regular number representation, not
;;    bignum representation.

;;  AR: 0+0=0
;;  OI: empty * empty 
;;  RI: n/a
;;  RO: n/a
;;    if both bignums are empty produce empty
;;  OO: empty

;;  AR: 9+0=9
;;  OI: (cons 9 empty) * empty
;;  RI: n/a
;;  RO: n/a
;;    if one of the bignums is empty then return the nonempty bignum
;;  OO: (cons 9 empty)

;;  AR: 4+3=7
;;  OI: (cons 4 empty) * (cons 3 empty)
;;  RI: empty * empty
;;  RO: empty
;;    digit-add of the first elements of each list and cons that onto RO
;;  OO: (cons 7 empty)

;;  AR: 31+37=68
;;  OI: (cons 1 (cons 3 empty)) * (cons 7 (cons 3 empty))
;;  RI: (cons 3 empty) * (cons 3 empty)
;;  RO: (cons 6 empty)
;;    digit-add of the first elements of each list and cons that onto RO
;;  OO: (cons 8 (cons 6 empty))

;;  AR: 3+28=31
;;  OI: (cons 3 empty) * (cons 8 (cons 2 empty))
;;  RI: empty * (cons 2 empty)
;;  RO: (cons 2 empty)
;;    digit-add the first elements of each list, call that first-sum ---> 11
;;    take the digit-quo-10 of first-sum and convert that to bignum
;;    representation ---> (cons 1 empty)
;;    (bignum+ (digit-quo-10 first-sum)  (RO) ---> (cons 3 empty)
;;    (cons (digit-rem-10 first-sum) (that result)) ---> (cons 1 (cons 3 empty))
;;  OO: (cons 1 (cons 3 empty))

;;  AR: 99+1=100
;;  OI: (cons 9 (cons 9 empty)) * (cons 1 empty)
;;  RI: (cons 9 empty) * empty
;;  RO: (cons 9 empty)
;;    digit-add the first elements of each list, call that first-sum ---> 10
;;    take the digit-quo-10 of first-sum and convert that to bignum
;;    representation ---> (cons 1 empty)
;;    (bignum+ (digit-quo-10 first-sum) (RO) ---> (cons 0 (cons 1 empty))
;;    (cons (digit-rem-10 first-sum) (that result))
;;    ---> (cons 0 (cons 0 (cons 1 empty)))
;;  OO: (cons 0 (cons 0 (cons 1 empty)))

;;  AR: 183+ 984=1167
;;  OI: (cons 3 (cons 8 (cons 1 empty))) * (cons 4 (cons 8 (cons 9 empty)))
;;  RI: (cons 8 (cons 1 empty)) * (cons 8 (cons 9 empty))
;;  RO: (cons 6 (cons 1 (cons 1 empty)))
;;    digit-add the first elements of each list, call that first-sum ---> 7
;;    take the digit-quo-10 of first-sum and convert that to bignum
;;    representation ---> (cons 0 empty)
;;    (bignum+ (digit-quo-10 first-sum) (RO)
;;    ---> (cons 6 (cons 1 (cons 1 empty)))
;;    (cons (digit-rem-10 first-sum) (that result)) --->
;;    (cons 7 (cons 6 (cons 1 (cons 1 empty))))
;;  OO: (cons 7 (cons 6 (cons 1 (cons 1 empty))))

(define (bignum+ bignum1 bignum2)
  (cond
    ;; There is a bit of redundancy in the below conditions, as we could simply
    ;; check if the first bignum is empty and return bignum2 regardless of
    ;; whether it is empty or not, but we keep all these conditions for the sake
    ;; of clarity
    [(and (empty? bignum1) (empty? bignum2)) empty]
    [(and (cons? bignum1) (empty? bignum2)) bignum1]
    [(and (empty? bignum1) (cons? bignum2)) bignum2]
    [(and (cons? bignum1) (cons? bignum2))
     (cons
      ;; The line below is the first element in the sum (i.e. the one's digit)
      (digit-rem (digit-add (first bignum1) (first bignum2)) 10)
      ;; The if-statement addresses whether or not there is a carry, which is
      ;; used to remove leading zeros.
      (bignum+ (if (zero? (digit-quo
                           (digit-add (first bignum1) (first bignum2))
                           10))
                   ;; The true situation is when there's no carry, so we bignum+
                   ;; the empty list onto the recursive output
                   empty
                   ;; The false situation is when there is a carry, which will
                   ;; become a list of length 1 that we bignum+ to the recursive
                   ;; output
                   (list (digit-quo
                          (digit-add (first bignum1) (first bignum2))
                          10)))
               (bignum+ (rest bignum1) (rest bignum2))))]))

;; AR: 0+0=0
(check-expect (bignum+ empty empty) empty)
;; AR: 9+0=0
(check-expect (bignum+ (list 9) empty) (list 9))
;; AR: 24+15=39
(check-expect (bignum+ (list 4 2) (list 5 1)) (list 9 3))
;; AR: 158+96=254
(check-expect (bignum+ (list 8 5 1) (list 6 9)) (list 4 5 2))
;; AR: 99+1=100
(check-expect (bignum+ (list 9 9) (list 1)) (list 0 0 1))
;; AR: 5020+1935=6955
(check-expect (bignum+ (list 0 2 0 5) (list 5 3 9 1)) (list 5 5 9 6))
;; AR: 5429+6=5435
(check-expect (bignum+ (list 9 2 4 5) (list 6)) (list 5 3 4 5))
;; AR: 8025+9299=17324
(check-expect (bignum+ (list 5 2 0 8) (list 9 9 2 9)) (list 4 2 3 7 1))
;; AR: 999+1=1000
(check-expect (bignum+ (list 9 9 9) (list 1)) (list 0 0 0 1))
;; AR: 1+999=1000
(check-expect (bignum+ (list 1) (list 9 9 9)) (list 0 0 0 1))
;; AR: 910+200100=201010
(check-expect (bignum+ (list 0 1 9) (list 0 0 1 0 0 2))(list 0 1 0 1 0 2))
;; AR: 1+3=4
(check-expect (bignum+ (list 1) (list 3)) (list 4))
;; AR: 5+7=12
(check-expect (bignum+ (list 5) (list 7)) (list 2 1))
;; AR: 7+5=12
(check-expect (bignum+ (list 7) (list 5)) (list 2 1))

;; -----------------------------------------------------------------------------
;; helper function:

;; Type Signature:
;; digit*bignum: (num) * (bignum) -> (bignum)
;;
;; I/O Specification:
;; Input: a digit called num
;;        and a bignum of arbitrary size (called bignum)
;;        that we wish to multiply together
;; Output: a bignum that is the product of num and bignum
;;
;;
;; Recursion Diagrams (Test Cases):
;; AR: 4*593=2372
;; OI: 4 * (cons 3 (cons 9 (cons 5 empty)))
;; RI: 4 * (cons 9 (cons 5 empty))
;; RO: (cons 6 (cons 3 (cons 2 empty)))
;;   digit-prod 3 4 = 12, converted to bignum (with digit-quo and digit-rem 10)
;;   gets (cons 2 (cons 1 empty))
;;   bignum+ (cons 2 (cons 1 empty)) (cons 0 RO) =
;;   (cons 2 (cons 7 (cons 3 (cons 2 empty))))
;; OO: (cons 2 (cons 7 (cons 3 (cons 2 empty))))
;;
;; AR: 0*2850=0
;; OI: 0 * (cons 0 (cons 5 (cons 8 (cons 2 empty))))
;; RI: n/a
;; RO: n/a
;;   if num is 0, return empty
;; OO: empty
;;
;; AR: 8*0=0
;; OI: 8 * empty
;; RI: n/a
;; RO: n/a
;;   if bignum is empty, return empty
;; OO: empty

(define (digit*bignum num bignum)
  (cond
    [(zero? num) empty]
    [(succ? num)
     (cond
       [(empty? bignum) empty]
       [(cons? bignum)
        ;; We want to bignum+ (the product of the num and the first digit of the
        ;; bignum) and 10 times the recursive output
        (bignum+
         ;; To represent (the product of the num and the first digit of the
         ;; bignum) as a bignum itself, we must account for the product being
         ;; two digits (greater than 9)
         (cons (digit-rem (digit-mult (first bignum) num) 10)
               (if (zero? (digit-quo (digit-mult (first bignum) num) 10))
                   empty
                   (list (digit-quo (digit-mult (first bignum) num) 10))))
         ;; By cons-ing 0 onto a bignum, we are in effect multiplying the bignum
         ;; by 10
         (cons 0 (digit*bignum num (rest bignum))))])]))

;; AR: 0*0=0
(check-expect (digit*bignum 0 empty) empty)
;; AR: 0*21=0
(check-expect (digit*bignum 0 (list 1 2)) empty)
;; AR: 5*0=0
(check-expect (digit*bignum 5 empty) empty)
;; AR: 5*25=125
(check-expect (digit*bignum 5 (list 5 2)) (list 5 2 1))
;; AR: 9*9999=89991
(check-expect (digit*bignum 9 (list 9 9 9 9)) (list 1 9 9 9 8))
;; AR: 1*100=100
(check-expect (digit*bignum 1 (list 0 0 1)) (list 0 0 1))
;; AR: 2*50=100
(check-expect (digit*bignum 2 (list 0 5)) (list 0 0 1))
;; AR: 3*38521=115563
(check-expect (digit*bignum 3 (list 1 2 5 8 3)) (list 3 6 5 5 1 1))
;; AR: 8*452=3616
(check-expect (digit*bignum 8 (list 2 5 4)) (list 6 1 6 3))

;; -----------------------------------------------------------------------------
;; multiplication:

;; Type Signature:
;; bignum*: (bignum) * (bignum) -> (bignum)

;; I/O Specification:
;; Input: two bignums, bignum1 and bignum2, both of arbitrary size, that we wish
;;        to multiply together
;; Output: a bignum representing the product of bignum1 and bignum2

;; Recursion Diagrams (Test Cases):
;; AR: 392*849=332808
;; OI: (cons 2 (cons 9 (cons 3 empty))) * (cons 9 (cons 4 (cons 8 empty)))
;; RI: (cons 9 (cons 3 empty)) * (cons 9 (cons 4 (cons 8 empty)))
;; RO: (cons 1 (cons 1 (cons 1 (cons 3 (cons 3 empty)))))
;;   digit*bignum 2 (cons 9 (cons 4 (cons 8 empty))) =
;;   (cons 8 (cons 9 (cons 6 (cons 1 empty))))
;;   bignum+ (cons 8 (cons 9 (cons 6 (cons 1 empty)))) (cons 0 RO) =
;;   (cons 8 (cons 0 (cons 8 (cons 2 (cons 3 (cons 3 empty))))))
;; OO: (cons 8 (cons 0 (cons 8 (cons 2 (cons 3 (cons 3 empty))))))

;; AR: 12*99=1188
;; OI: (cons 2 (cons 1 empty)) * (cons 9 (cons 9 empty))
;; RI: (cons 1 empty) * (cons 9 (cons 9 empty))
;; RO: (cons 9 (cons 9 empty))
;;   digit*bignum 2 (cons 9 (cons 9 empty)) = (cons 8 (cons 9 (cons 1 empty)))
;;   bignum+ (cons 8 (cons 9 (cons 1 empty))) (cons 0 (cons 9 (cons 9 empty))) =
;;   (cons 8 (cons 8 (cons 1 (cons 1 empty))))
;; OO: (cons 8 (cons 8 (cons 1 (cons 1 empty))))

;; AR: 0*284=0
;; OI: empty * (cons 4 (cons 8 (cons 2 empty)))
;; RI: n/a
;; RO: n/a
;;   if either bignum is empty return empty
;; OO: empty

;; AR: 1*2=2
;; OI: (cons 1 empty) * (cons 2 empty)
;; RI: empty * (cons 2 empty)
;; RO: empty
;;   digit*bignum 1 (cons 2 empty) = (cons 2 empty)
;;   bignum+ (cons 2 empty) (cons 0 RO) = (cons 2 empty)
;; OO: (cons 2 empty)

;; AR: 10*2=20
;; OI: (cons 0 (cons 1 empty)) * (cons 2 empty)
;; RI: (cons 1 empty) * (cons 2 empty)
;; RO: (cons 2 empty)
;;   digit*bignum 0 (cons 2 empty) = empty
;;   bignum+ empty (cons 0 RO) = (cons 0 (cons 2 empty))
;; OO: (cons 0 (cons 2 empty))

;; AR: 85*203=17255
;; OI: (cons 5 (cons 8 empty)) * (cons 3 (cons 0 (cons 2 empty)))
;; RI: (cons 8 empty) * (cons 3 (cons 0 (cons 2 empty)))
;; RO: (cons 4 (cons 2 (cons 6 (cons 1 empty))))
;;   digit*bignum 5 (cons 3 (cons 0 (cons 2 empty))) =
;;   (cons 5 (cons 1 (cons 0 (cons 1 empty))))
;;   bignum+ (cons 5 (cons 1 (cons 0 (cons 1 empty)))) (cons 0 RO) =
;;   (cons 5 (cons 5 (cons 2 (cons 7 (cons 1 empty)))))
;; OO: (cons 5 (cons 5 (cons 2 (cons 7 (cons 1 empty)))))

(define (bignum* bignum1 bignum2)
  (cond
    [(empty? bignum1) empty]
    [(empty? bignum2) empty]
    [(and (cons? bignum1) (cons? bignum2))
     ;; We want to bignum+ (the product of the first digit of bignum1 and all of
     ;; bignum2) to 10 times the recursive output
     (bignum+ (digit*bignum (first bignum1) bignum2)
              ;; By cons-ing 0 onto a bignum, we are in effect multiplying the
              ;; bignum by 10
              (cons 0 (bignum* (rest bignum1) bignum2)))]))

;; AR: 32*25=800
(check-expect (bignum* (list 2 3) (list 5 2)) (list 0 0 8))
;; AR: 0*24=0
(check-expect (bignum* empty (list 4 2)) empty)
;; AR: 0*0=0
(check-expect (bignum* empty empty) empty)
;; AR: 24*0=0
(check-expect (bignum* (list 4 2) empty) empty)
;; AR: 8*9=72
(check-expect (bignum* (list 8) (list 9)) (list 2 7))
;; AR: 2*1088=2176
(check-expect (bignum* (list 2) (list 8 8 0 1)) (list 6 7 1 2))
;; AR: 1088*2=2176
(check-expect (bignum* (list 8 8 0 1) (list 2)) (list 6 7 1 2))
;; AR: 100*56=5600
(check-expect (bignum* (list 0 0 1) (list 6 5)) (list 0 0 6 5))
;; AR: 72*3018=217296
(check-expect (bignum* (list 2 7) (list 8 1 0 3)) (list 6 9 2 7 1 2))
;; AR: 91268*99=9035532
(check-expect (bignum* (list 8 6 2 1 9) (list 9 9)) (list 2 3 5 5 3 0 9))
;; AR: 10000*1000=10000000
(check-expect (bignum* (list 0 0 0 0 1) (list 0 0 0 1)) (list 0 0 0 0 0 0 0 1))