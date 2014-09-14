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
chapters.each { |chapter|
  basename = File.basename(chapter, ".md")
  chapterNumber = basename.match(/([0-9][0-9])-*/)[1]
  chapterDirectory = "en/#{basename}"
  FileUtils.mkdir_p chapterDirectory
  transformedChapterFile = "#{chapterDirectory}/#{chapterNumber}-chapter1.markdown"
  FileUtils.cp(chapter, transformedChapterFile)
  puts chapter
}

