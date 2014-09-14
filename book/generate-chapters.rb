#!/usr/bin/env ruby

require 'fileutils'
require 'pathname'

chapters = []
Dir.glob("../[0-9][0-9]-*.md") { |file|
  chapters << file
}

#
# For each chapter file that looks like:
#
# 01-preface.md
#
# We want to write out the file to
#
# en/01-preface/01-chapter1.markdown
#
# We also want to emit a version of the chapter with Jekyll front-matter that can
# be integrated into a normal Jekyll site
#
bookDirectory = "team/book"
FileUtils.mkdir_p(bookDirectory)
chapters.each { |chapter|
  basename = File.basename(chapter, ".md")
  parts = basename.match(/([0-9][0-9])-(.*)/)
  chapterNumber = parts[1]
  title = parts[2].capitalize
  chapterDirectory = "en/#{basename}"
  #
  # PDF/ebook content   # 
  FileUtils.mkdir_p chapterDirectory
  transformedChapterFile = "#{chapterDirectory}/#{chapterNumber}-chapter1.markdown"
  FileUtils.cp(chapter, transformedChapterFile)
  #
  # Jekyll content
  #
  jekyllPath = "#{bookDirectory}/#{basename}.md"
  content = File.open(chapter).read
  File.open(jekyllPath, 'w') { |f| 
    f.write("---\n")
    f.write("layout: chapter\n")
    f.write("title: #{title}\n")
    f.write("---\n")
    f.write(content) 
  }
}


