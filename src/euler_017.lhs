Problem 17
----------

 > If the numbers 1 to 5 are written out in words: one, two, three, four, five,
 > then there are 3 + 3 + 5 + 4 + 4 = 19 letters used in total.
 >
 > If all the numbers from 1 to 1000 (one thousand) inclusive were written out
 > in words, how many letters would be used?
 >
 > Do not count spaces or hyphens. For example, 342 (three hundred and
 > forty-two) contains 23 letters and 115 (one hundred and fifteen) contains 20
 > letters. The use of "and" when writing out numbers is in compliance with
 > British usage.

Some basic translations of numbers are required to bootstrap the algorithm.

> singles x = words !! (x - 1)
>   where
>     words =
>       [ "one" , "two" , "three" , "four" , "five" , "six" , "seven" , "eight"
>       , "nine" , "ten" , "eleven" , "twelve" , "thirteen" , "fourteen"
>       , "fifteen" , "sixteen" , "seventeen" , "eighteen" , "nineteen" ]
>
> tens x = words !! (x - 2)
>   where
>     words = [ "twenty" , "thirty" , "forty" , "fifty" , "sixty" , "seventy"
>             , "eighty" , "ninety" , "hundred" ]


For numbers below 100, translating numbers to words is somewhat arbitary, but
the logic is not too cumbersome.

> formatBelow100 x
>   | x < 20        = singles x
>   | rem x 10 == 0 = formatTens x
>   | otherwise     = formatTens x ++ " " ++ (singles $ rem x 10)
>   where
>     formatTens x = tens $ div x 10

For numbers greater than 100 the translation logic is much simpler and can be
coded inline. This data structure is the core of the algorithm, and it is
obvious how it could be extended to support millions, billions, and beyond.

> ranges = let b label x = (numberToWords x) ++ " " ++ label in
>   [ (1, formatBelow100)
>   , (10^2, b "hundred")
>   , (10^3, b "thousand")
>   , (10^6, (\x -> error "Number too large"))
>   ]

Beautifying the output is not strictly necessary for the given problem, but
makes for a more useful general function.

> formatSentence [x]    = x
> formatSentence [x, y] = x ++ " and " ++ y
> formatSentence (x:xs) = x ++ ", " ++ formatSentence xs

The algorithm works backwards through the known ranges accumulating fragments
for each, before joining them together to make a sentence.

> numberToWords x = makeSentence $ foldr formatRange ([], x) ranges
>   where
>     makeSentence = formatSentence . reverse . fst
>     formatRange (min, f) (a, remainder)
>       | remainder >= min = (f major:a, minor)
>       | otherwise        = (a, remainder)
>       where
>         (major, minor)
>           | min == 0  = (remainder, 0)
>           | otherwise = quotRem remainder min

For the solution to the problem, it is necessary to strip out spaces and
punctuation from the general algorithm.

> euler17 = sum . map (length . onlyAlpha . numberToWords) . enumFromTo 1
>  where
>    onlyAlpha = filter (flip elem ['a'..'z'])

> tests17 =
>   [ "#17 given"   ~: 19    ~=? euler17 5
>   , "#17 problem" ~: 21124 ~=? euler17 1000
>   ]
