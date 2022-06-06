1.Data Definition:
a bignum is either
  empty, which represents the number 0, or
  (cons item b) where item is a digit (see bignum.rkt for the definition of 
  digit)
  and b is a bignum.
The first element of bignum represents the ones digit
of the number, while the second element of bignum represents the tens digit,
and so on (looks like reverse order).
A list of only 0's and no other digit is not a bignum.
As a consequence of this, no bignum can contain leading 0's

This is our definition of bignums. We decided to use this definition because it
is intuitive as it is still in base 10. Additionally, the maximum value of any 
digit operation applied to single digit natural numbers is 81, the result from 
(digit-prod 9 9), which keeps us within the limit of the digit operations as no 
input or output to the operation is greater than 99 or less than 0. Finally, an
advantage to representing the bignum digits in reverse order (12 is represented
as (list 2 1)) is that when applying procedures to the bignums, digits in the
one's place line up and are both the first element of their respective bignums,
the digits in the ten's place line up and are both the second element of their
respective bignums, and so on.

2. Based on our data definition, the bignum representation has the reverse order 
of regular arithmetic representation. A user should type in empty to represent 
the number 0. Otherwise, a user should type each digit, starting from the 
ones-digit of a number under regular arithmetic representation and (if 
applicable) followed by the tens-digit and so on, into a list. The list should 
not end with a zero. For example, a user intending to represent the number 2 
should type in (list 2), a user intending to represent the number 2461 should 
type in (list 1 6 4 2), and a user intending to represent the number 10000 
should type in (list 0 0 0 0 1). Then, type the two bignums into the call 
structure (bignum+ bignum1 bignum2) or (bignum* bignum1 bignum2) to obtain the 
sum or product of bignum1 and bignum2.

3. For bignum+, the first digits of the two bignums are added together with 
digit-add, and the carry they produce is handled by a combination of digit-rem 
and digit-quo. Finally, bignum+ itself is used in the procedure in order to add 
the remaining digits of the bignums, as well as the carry resulting from the sum
of the first digits.

For digit*bignum, digit-mult is used to multiply the given single digit number 
and the first digit of the given bignum. Like in bignum+, a combination of
digit-rem and digit-quo are used to handle the product of the two single digit
numbers when the product itself has two digits (for example 3*7=21 has two
digits). Finally, bignum+ is used to add the product of the single digit number
and the first digit of the bignum to 10 times the product of the single digit 
number and the rest of the digits for the bignum (cons 0 is used to multiply the
product by 10), which itself is determined with digit*bignum.

For bignum*, digit*bignum is used to find the product of the first digit of the
first bignum and the entirety of the second bignum. Then, bignum+ is used to add
this product to 10 times the bignum* of the rest of the digits of the first 
bignum and the entirety of the second bignum (cons 0 is used to multiply the 
product by 10).

4. We have not discovered any bugs or problems with our program at this point.

5. This project was completed by Yutong Wang and Tarek Razzaz. Also, special 
thanks to Minh Quan and Ian who helped us regarding implementation and analysis 
during TA hours, and special thanks to Stephen, Alex, Isabel, Alyssa who helped 
us via edstem.

6. If a user intends to calculate the product of a single-digit number and a 
bignum, an alternative way is to use the call structure (digit*bignum num 
bignum), where num represents the single-digit number. The bignum should still 
be typed in the form described in answer 2. For example, a user intending to 
calculate the product of 8 and 2938 can type in (digit*bignum 8 (list 8 3 9 2)).
It is also valid to type in (bignum* (list 8) (list 8 3 9 2)), and the 
expressions will yield the same output.