# Corpus Design


Since this testing environment is all about the a syntax (for highlighting).

It would kinda make the most sense to structure this `corpus` directory to around
the orderly progression of encountered keywords (without regard to EBNF/Bison symbol,
terminal or non-terminal).

So, let's try it this way.... a directory name represents the characters of a keyword

Its directory content contains `nft` script files that exercises that pathyway 
(as denoted by its directory/subdirectory/...).

Let's try it and see how well that works for unit testing.

Perhaps, we can use the symbol/group name as a non-directory file name containing actual `nft` scripts.


Ummmm, just because EBNF says it is doable, doesn't mean that `nft` scanner.c will say it's ok.

So, we need notations in the unit test file to reflect this:

    parser:  allowed
    scanner: NOT ALLOWED

# Interim Prototype of Unit Test Corpus

So far, this is looking the most intuitive form of unit test organization for syntax checking: by "token" as a directory name.



# Conclusion

This unit test corpus design would avoid the need to split-out a script file into true-positive, true-negative, false-negative, and false-positive.  Not sure how to do 'false-negative' with this 3-way setup of EBNF, nft-syntax-checker, and LL(1).

# TODO
* Now to see if this parser/scanner flag should be incorporated into the filename of nft script???

* Would symlink directories (symbol/group) to others be a viable support mechanism for unit testing?


# Side-benefit

Doing a full path of a directory listing will produce the workable keywords to type in.

