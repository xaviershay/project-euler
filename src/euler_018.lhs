Problem 18
----------

 > By starting at the top of the triangle below and moving to adjacent numbers
 > on the row below, the maximum total from top to bottom is 23.

> smallInput18 =
>   "3 " ++
>   "7 4 " ++
>   "2 4 6 " ++
>   "8 5 9 3 "

 > That is, 3 + 7 + 4 + 9 = 23.
 >
 > Find the maximum total from top to bottom of the larger triangle below.

> largeInput18 =
>   "75 " ++
>   "95 64 " ++
>   "17 47 82 " ++
>   "18 35 87 10 " ++
>   "20 04 82 47 65 " ++
>   "19 01 23 75 03 34 " ++
>   "88 02 77 73 07 63 67 " ++
>   "99 65 04 28 06 16 70 92 " ++
>   "41 41 26 56 83 40 80 70 33 " ++
>   "41 48 72 33 47 32 37 16 94 29 " ++
>   "53 71 44 65 25 43 91 52 97 51 14 " ++
>   "70 11 33 28 77 73 17 78 39 68 17 57 " ++
>   "91 71 52 38 17 14 91 43 58 50 27 29 48 " ++
>   "63 66 04 68 89 53 67 30 73 16 69 87 40 31 " ++
>   "04 62 98 27 23 09 70 98 73 93 38 53 60 04 23 "

Starting at the bottom of the triangle, match the largest of each pair of
numbers to its parent. For the test input, this will be:

    [(9, 6), (9, 4), (8, 2)]

Summing the two gives the maximum total of this path, so it can be used to
replace the second bottom row. Continue folding the bottom row in until only
one row of one number remains.  This will be the maximum total.

> euler18 h w = head . foldl1' maxPath . parse h w
>  where
>    maxPath bs ts  = zipWith3 addMax ts bs (tail bs)
>    addMax t b1 b2 = t + (max b1 b2)

To parse the input, read in as sequence integers then chunk it with a
descending width. To enable a nice functional style the input is reversed
before being chunked. This has the effect of mirroring the triangle, but this
has no bearing on the solution.

>    parse h w = triangleChunk h . reverse . map stringToInt . (chunk w)

>    triangleChunk 0 _ = []
>    triangleChunk n x = take n x:triangleChunk (n-1) (drop n x)

> tests18 =
>   [ "#18 given"   ~: 23   ~=? euler18 4 2 smallInput18
>   , "#18 problem" ~: 1074 ~=? euler18 15 3 largeInput18
>   ]
