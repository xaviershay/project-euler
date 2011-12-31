Problem 19
----------

 > How many Sundays fell on the first of the month during the twentieth century
 > (1 Jan 1901 to 31 Dec 2000)?

Define a data type `Month` that allows interation over all months in a range.
This is overkill for this problem, but allows a chance to investigate Haskell's
type system.

A `Month` is composed of a year and a month. 

> data Month = Month Integer Int

Provide a conversion to the built-in type `Day` that returns the first day of
the month.

> toDay (Month y m) = fromGregorian y m 1

For display, match the format of `Day` but with days truncated.

> instance Show Month where
>   show (Month y m) = show y ++ "-" ++ show m

Map months to a contiguous range of integers. This is the minimal required
definition of `Enum` that will allow the use of `Month` in ranges.

> instance Enum Month where
>   fromEnum (Month y m) = (fromInteger y) * 12 + m - 1
>   toEnum x             = Month (toInteger y) (m + 1)
>     where
>       (y, m) = quotRem x 12

`sundayStartWeek` returns the day of the week as the second element of a tuple,
which is used to answer the problem.

> euler19 = length . filter ((== 0) . snd . sundayStartWeek . toDay)

> tests19 =
>   [ "#19 problem" ~: 171 ~=? euler19 [Month 1901 1..Month 2000 12]
>   ]
