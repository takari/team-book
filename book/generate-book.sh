#!/bin/bash

# fail if anything errors
set -e
# fail if a function call is missing an argument
set -u

rm -rf team/book
echo "build - Removed previous build output ---------------------------------------------"

./generate-chapters.rb
echo "build - Generated chapters----- ---------------------------------------------------"

echo "build - Starting PDF Generation ---------------------------------------------------"
./makepdfs.sh en
echo "build - Finished PDF Generation - see team/book/team.pdf --------------------------"

echo "build - Starting mobi Generation --------------------------------------------------"
export FORMAT=mobi
./makeebooks.rb en
echo "build - Finished mobi Generation - see team/book/team.mobi ------------------------"

echo "build - Starting epub Generation --------------------------------------------------"
export FORMAT=epub
./makeebooks.rb en
echo "build - Finished epub Generation - see team/book/team.epub ------------------------"

# We dont' want to keep this around
rm team-book.en.html

mv team-book.en.epub team/book/team.epub
mv team-book.en.mobi team/book/team.mobi
mv team-book.en.pdf team/book/team.pdf
echo "build - Completed - see content of team/book: --------------------------------------"
ls -1 team/book
