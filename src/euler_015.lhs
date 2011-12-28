Problem 15
----------

 > Starting in the top left corner of a |2 * 2| grid, there are 6 routes
 > (without backtracking) to the bottom right corner.
 >
 > How many routes are there through a |20 * 20| grid?

Let the number of paths through a grid of |x * y| be a function |p(x, y)|. For any
grid, there are only two immediate paths leading into the final corner.
Therefore, |p(x, y)| will be equal to |p(x-1, y) + p(x, y-1)|, terminating at 1
whenever |x| or |y| is 0. In the case of a |2 * 2| grid:

) = p(2, 2)
) = p(2, 1) + p(1, 2)
) = 2p(1, 1) + p(2, 0) + p(0, 2)
) = 2(p(0, 1) + p(1, 0)) + p(2, 0) + p(0, 2)
) = 2 * 2 + 1 + 1
) = 6

As with the last problem, memoization is essential to allow this algorithm a
reasonable running time.

> gridPaths = Memo.memo2 Memo.integral Memo.integral f
>   where
>     f x 0 = 1
>     f 0 x = 1
>     f w h = (gridPaths (w-1) h) + (gridPaths w (h-1))

> euler15 n = gridPaths n n

> tests15 =
>   [ "#15 given"   ~: 6            ~=? euler15 2
>   , "#15 problem" ~: 137846528820 ~=? euler15 20
>   ]
