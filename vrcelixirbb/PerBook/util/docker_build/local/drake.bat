@ECHO OFF
@copy ..\bookinfo.pml bookinfo.pml
@docker run --rm -it -v %cd%:/home/runner/Book ppbookshelf/bookbuilder ./build %1 %2 %3 %4 %5 %6 %7 %8 %9
@delete ..\bookinfo.pml

