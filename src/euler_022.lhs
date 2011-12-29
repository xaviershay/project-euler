Problem 22
----------

 > Using `names.txt`, a 46K text file containing over five-thousand first
 > names, begin by sorting it into alphabetical order. Then working out the
 > alphabetical value for each name, multiply this value by its alphabetical
 > position in the list to obtain a name score.
 >
 > For example, when the list is sorted into alphabetical order, COLIN, which
 > is worth 3 + 15 + 12 + 9 + 14 = 53, is the 938<sup>th</sup> name in the
 > list. So, COLIN would obtain a score of |938 * 53 = 49714|.
 >
 > What is the total of all the name scores in the file?

The word scoring function takes advantage of all the names being uppercase A-Z,
though any different alphabet could be substituted easily. This is not the most
efficient algorithm. Scoring a character is O(|n|), but is sufficient for this
problem. It could easily be improved by using a lookup table, or O(1) if the
ordinal values of the letters were used.

> scoreWord index word = index * sum (map scoreChar word)
>   where
>     alphabet    = ['A'..'Z']
>     scoreChar x = fromJust (elemIndex x alphabet) + 1

> scoreArray = sum . zipWith scoreWord  [1..] . sort

> euler22 = scoreArray . parse
>   where
>     parse = map (tail . init) . (splitOn ",")

This is the first problem to require input from an external file. Due to
Haskell's functional nature, this needs to be passed in from the external main
function.

> tests22 input =
>   [ "#22 problem" ~: 871198282 ~=? euler22 input
>   ]
