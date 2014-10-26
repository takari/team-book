# Book Generation

To generate the book simply run:

```
./book.rb
```

If you want to change what is produced edit the `book.yml` file.

# Requirements

To generate the PDF, epub, and mobi book requires pandoc, XeTeX and Calibre.

# Configuration

`book.tex` is the main LaTeX file which determines the style of the PDF version of the book. Its contents is run through the ERB templating language to include language-specific customizations from config.yml.
