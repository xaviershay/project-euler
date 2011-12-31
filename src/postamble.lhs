Postamble
---------

There are over three hundred and fifty problems current on Project Euler, and I
have as yet tackled but a small sample of them here. In time, I hope to extend
this document further with more solutions. There is still plenty more Haskell
for me to learn. I haven't even started on monads!

As a final and closing convenience, a main function is provided to run all the
given test cases.

> main = do
>   input22 <- readFile "data/names.txt"
>   runTestTT $ TestList ( tests1
>                       ++ tests2
>                       ++ tests3
>                       ++ tests4
>                       ++ tests5
>                       ++ tests6
>                       ++ tests7
>                       ++ tests8
>                       ++ tests9
>                       ++ tests10
>                       ++ tests11
>                       ++ tests12
>                       ++ tests13
>                       ++ tests14
>                       ++ tests15
>                       ++ tests16
>                       ++ tests17
>                       ++ tests18
>                       ++ tests19
>                       ++ tests20
>                       ++ tests21
>                       ++ (tests22 input22)
>                       ++ tests23
>                       ++ tests24
>                       ++ tests25
>                       )

Acknowledgements
----------------

The styling for this document is from Kevin Burke's excellent [Markdown
CSS][markdown-css].  I am grateful to Thomas Sutton for his [formatting
Literate Haskell blog post][thomas-sutton], that inspired the build scripts I
made for this project.  Many solutions were refined after-the-fact by
suggestions gleaned from other solutions in the Project Euler forums.

[markdown-css]: http://kevinburke.bitbucket.org/markdowncss/
[thomas-sutton]: http://passingcuriosity.com/2008/literate-haskell-with-markdown-syntax-hightlighting/
