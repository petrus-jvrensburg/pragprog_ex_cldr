# pragprog_ex_cldr

This project has three moving parts:

1. [External livebooks (to serve as a companion to the book)](livebooks_external/)
2. [Internal livebooks (used for generating tables & charts that are used in the book)](livebooks_internal/)
3. [A bunch of XML a la PragProg (managed via SVN)](vrcelixirbb)

The book is built with PragProg's CI/CD pipeline. To trigger a new build:

```
cd vrcelixirbb
svn update  # to pull the latest changes from pragprog's central repo
svn status  # to have a look at local changes
svn commit -m "trigger fresh build"  # to push local changes to pragprog's central repo
```

Then download the latest pdf from https://portal.pragprog.com/build_statuses.
