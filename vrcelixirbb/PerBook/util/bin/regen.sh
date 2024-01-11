#!/bin/sh

# Called periodically to rebuild the book PDFs and store the results
# on the web server
cd /tc/work/Bookshelf

cvs -q up -d  >/dev/null

cd titles

( for DIR in SVN PRJ PAD
do
    ( cd $DIR
      echo `date` >/tmp/$DIR.log
      echo `which ftp` >/tmp/$DIR.log
      make author_book >>/tmp/$DIR.log 2>&1
      ftp -A -u ftp://dave@fast/%2Fvar/www/pragprog/html/titles/$DIR/log.txt /tmp/$DIR.log >/dev/null
	ftp -A -u ftp://dave@fast/%2Fvar/www/pragprog/html/titles/${DIR}/${DIR}_book.pdf ${DIR}_book.pdf || rm ${DIR}_book.pdf
    )
done
) | grep -v EPRT
