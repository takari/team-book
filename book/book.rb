#!/usr/bin/env ruby

require 'erb'
require 'fileutils'
require 'yaml'
require 'rubygems'
require 'rdiscount'
include FileUtils

$root = File.expand_path(File.dirname(__FILE__))
$outputDirectory = "#{$root}/target"
$en = "#{$root}/en"
$config = YAML.load_file("#$root/book.yml")['default']
FileUtils.rm_rf($outputDirectory)
$bookFileName = $config['bookFileName']

#
# This generates anchors that work with redcarpets toc data option in Jekyll
#
def tocify(markdownFile, htmlFile)
  bookSiteUrl = $config['bookSiteUrl']
  tocCount = 0
  tocLines = ""
  File.open(markdownFile, 'r') do |f|
    f.each_line do |line|
      forbidden_words = ['Table of contents', 'define', 'pragma']
      next if !line.start_with?("#") || forbidden_words.any? { |w| line =~ /#{w}/ }
      title = line.gsub("#", "").strip
      href = title.gsub(" ", "-").downcase
      href = "#{bookSiteUrl}#{htmlFile}#toc_#{tocCount}"
      tocLine = "    " * (line.count("#")-1) + "* [#{title}](#{href})\n"
      tocLines << tocLine
      tocCount = tocCount + 1
    end
  end
  return tocLines
end

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
toc = ""
bookDirectory = $outputDirectory
FileUtils.mkdir_p(bookDirectory)
chapters.each { |chapter|
  basename = File.basename(chapter, ".md")
  htmlFile = "#{basename}.html"
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
  toc << tocify(chapter, htmlFile)
}

tocFile = "#{bookDirectory}/index.md"
File.open(tocFile, 'w') { |f| 
  f.write("---\n")
  f.write("layout: bookTOC\n")
  f.write("title: Index\n")
  f.write("---\n")
  f.write(toc) 
}

#
# PDF
#

def figures(lang,&block)
  begin
    Dir["#$root/figures/18333*.png"].each do |file|
      cp(file, file.sub(/18333fig0(\d)0?(\d+)\-tn/, '\1.\2'))
    end
    Dir["#$root/#{lang}/figures-dia/*.dia"].each do |file|
      eps_dest= file.sub(/.*fig0(\d)0?(\d+).dia/, '\1.\2.eps')
      system("dia -t eps-pango -e #$root/figures/#{eps_dest} #{file}")
      system("epstopdf #$root/figures/#{eps_dest}")
    end
    cp(Dir["#$root/#{lang}/figures/*.png"],"#$root/figures")
    cp(Dir["#$root/#{lang}/figures/*.pdf"],"#$root/figures")
    block.call
  ensure
    Dir["#$root/figures/18333*.png"].each do |file|
      rm(file.gsub(/18333fig0(\d)0?(\d+)\-tn/, '\1.\2'))
    end
    rm(Dir["#$root/figures/*.pdf"])
    rm(Dir["#$root/figures/*.eps"])
  end
end

def usage
  puts <<USAGE
Usage:
  makepdf [OPTION...] LANGUAGE [LANGUAGE 2...]

Options:
  -d, --debug      prints TeX and other output
USAGE
  exit
end

def command_exists?(command)
  if File.executable?(command) then
    return command
  end
  ENV['PATH'].split(File::PATH_SEPARATOR).map do |path|
    cmd = "#{path}/#{command}"
    File.executable?(cmd) || File.executable?("#{cmd}.exe") || File.executable?("#{cmd}.cmd")
  end.inject{|a, b| a || b}
end

def replace(string, &block)
  string.instance_eval do
    alias :s :gsub!
    instance_eval(&block)
  end
  string
end

def verbatim_sanitize(string)
  string.gsub('\\', '{\textbackslash}').
    gsub('~', '{\textasciitilde}').
    gsub(/([\$\#\_\^\%])/, '\\\\' + '\1{}')
end

def pre_pandoc(string, config)
  replace(string) do
    # Pandoc discards #### subsubsections #### - this hack recovers them
    # be careful to try to match the longest sharp string first
    s /\#\#\#\#\# (.*?) \#\#\#\#\#/, 'PARAGRAPH: \1'
    s /\#\#\#\# (.*?) \#\#\#\#/, 'SUBSUBSECTION: \1'

    # Turns URLs into clickable links
    s /\`(http:\/\/[A-Za-z0-9\/\%\&\=\-\_\\\.\(\)\#]+)\`/, '<\1>'
    s /(\n\n)\t(http:\/\/[A-Za-z0-9\/\%\&\=\-\_\\\.\(\)\#]+)\n([^\t]|\t\n)/, '\1<\2>\1'

    # Match table in markdown and change them to pandoc's markdown tables
    s /(\n(\n\t([^\t\n]+)\t([^\t\n]+))+\n\n)/ do
      first_col=20
      t = $1.gsub /(\n?)\n\t([^\t\n]+)\t([^\t\n]+)/ do
        if $1=="\n"
          # This is the header, need to add the dash line
          $1 << "\n " << $2 << " "*(first_col-$2.length) << $3 <<
          "\n " << "-"*18 << "  " << "-"*$3.length
        else
          # Table row : format the first column as typewriter and align
          $1 << "\n `" << $2 << "`" + " "*(first_col-$2.length-2) << $3
        end
      end
      t << "\n"
    end

    # Process figures
    s /Insert\s18333fig\d+\.png\s*\n.*?\d{1,2}-\d{1,2}\. (.*)/, 'FIG: \1'
  end
end

def post_pandoc(string, config)
  replace(string) do
    space = /\s/

    # Reformat for the book documentclass as opposed to article
    s '\section', '\chap'
    s '\sub', '\\'
    s /SUBSUBSECTION: (.*)/, '\subsubsection{\1}'
    s /PARAGRAPH: (.*)/, '\paragraph{\1}'

    # Enable proper cross-reference
    s /#{config['fig'].gsub(space, '\s')}\s*(\d+)\-\-(\d+)/, '\imgref{\1.\2}'
    s /#{config['tab'].gsub(space, '\s')}\s*(\d+)\-\-(\d+)/, '\tabref{\1.\2}'
    s /#{config['prechap'].gsub(space, '\s')}\s*(\d+)(\s*)#{config['postchap'].gsub(space, '\s')}/, '\chapref{\1}\2'

    # Miscellaneous fixes
    s /FIG: (.*)/, '\img{\1}'
    s '\begin{enumerate}[1.]', '\begin{enumerate}'
    s /(\w)--(\w)/, '\1-\2'
    s /``(.*?)''/, "#{config['dql']}\\1#{config['dqr']}"

    # Typeset the maths in the book with TeX
    s '\verb!p = (n(n-1)/2) * (1/2^160))!', '$p = \frac{n(n-1)}{2} \times \frac{1}{2^{160}}$)'
    s '2\^{}80', '$2^{80}$'
    s /\sx\s10\\\^\{\}(\d+)/, '\e{\1}'

    # Convert inline-verbatims into \texttt (which is able to wrap)
    s /\\verb(\W)(.*?)\1/ ,'\\texttt{\2}'

    # Style ctables
    s /ctable\[pos = H, center, botcap\]\{..\}/ , 'ctable[pos = ht!, caption = ~ ,width = 130mm, center, botcap]{lX}'
    s /longtable\}\[c\]\{\@\{\}ll\@\{\}\}/ , 'longtable}[c]{@{}lp{10cm}@{}}
\caption{~}\\\\\\\\'

    # Shaded verbatim block
    s /(\\begin\{verbatim\}.*?\\end\{verbatim\})/m, '\begin{shaded}\1\end{shaded}'
  end
end

ARGV.delete_if{|arg| $DEBUG = true if arg == '-d' or arg == '--debug'}
languages = $config['bookLanguages']

#languages = ARGV.select{|arg| File.directory?("#$root/#{arg}")}
#usage if languages.empty?

template = ERB.new(File.read("#$root/book.tex"))

missing = ['pandoc', 'xelatex'].reject{|command| command_exists?(command)}
unless missing.empty?
  puts "Missing dependencies: #{missing.join(', ')}."
  puts "Install these and try again."
  exit
end

languages.each do |lang|
  figures(lang) do
    config = $config
    puts "#{lang}:"
    markdown = Dir["#$root/#{lang}/*/*.markdown"].sort.map do |file|
      File.read(file)
    end.join("\n\n")

    print "\tParsing markdown... "
    latex = IO.popen('pandoc -p --no-wrap -f markdown -t latex', 'w+') do |pipe|
      pipe.write(pre_pandoc(markdown, config))
      pipe.close_write
      post_pandoc(pipe.read, config)
    end
    puts "done"

    print "\tCreating main.tex for #{lang}... "
    dir = "#$root/#{lang}"
    mkdir_p(dir)
    File.open("#{dir}/main.tex", 'w') do |file|
      file.write(template.result(binding))
    end
    puts "done"

    abort = false

    puts "\tRunning XeTeX:"
    cd($root)
    3.times do |i|
      print "\t\tPass #{i + 1}... "
      IO.popen("xelatex -output-directory=\"#{dir}\" \"#{dir}/main.tex\" 2>&1") do |pipe|
        unless $DEBUG
          if $_[0..1]=='! '
            puts "failed with:\n\t\t\t#{$_.strip}"
            puts "\tConsider running this again with --debug."
            abort = true
          end while pipe.gets and not abort
        else
          STDERR.print while pipe.gets rescue abort = true
        end
      end
      break if abort
      puts "done"
    end

    unless abort
      print "\tMoving output to #{$bookFileName}.#{lang}.pdf... "
                        mv("#{dir}/main.pdf", "#$root/#{$bookFileName}.#{lang}.pdf")
      puts "done"
    end
  end
end

#
# Ebooks
# 

def figures(lang,&block)
  begin
    Dir["figures/18333*.png"].each do |file|
      cp(file, file.sub(/18333fig0(\d)0?(\d+)\-tn/, '\1.\2'))
    end
    Dir["#{lang}/figures/*.png"].each do |file|
      cp(file,"figures")
    end
    Dir["#{lang}/figures-dia/*.dia"].each do |file|
      png_dest= file.sub(/.*fig0(\d)0?(\d+).dia/, 'figures/\1.\2.png')
      system("dia -e #{png_dest} #{file}")
    end
    block.call
  ensure
    Dir["figures/18333*.png"].each do |file|
      rm(file.gsub(/18333fig0(\d)0?(\d+)\-tn/, '\1.\2'))
    end
  end
end

$config['bookFormats'].each do |format|
$config['bookLanguages'].each do |lang|
  figures (lang) do
    puts "convert content for '#{lang}' language"

    figure_title = 'Figure'
    book_title = 'Takari Extensions for Apache Maven TEAM - Documentation'
    authors = 'Jason van Zyl, Manfred Moser'
    comments = 'licensed under the Creative Commons Attribution-Non Commercial-Share Alike 3.0 license'

    book_content = %(<html xmlns="http://www.w3.org/1999/xhtml"><head><title>#{book_title}</title></head><body>)
    dir = File.expand_path(File.join(File.dirname(__FILE__), lang))
    Dir[File.join(dir, '**', '*.markdown')].sort.each do |input|
      puts "processing #{input}"
      content = File.read(input)
      content.gsub!(/Insert\s18333fig\d+\.png\s*\n.*?(\d{1,2})-(\d{1,2})\. (.*)/, '![\1.\2 \3](figures/\1.\2.png "\1.\2 \3")')
      book_content << RDiscount.new(content).to_html
    end
    book_content << "</body></html>"

    File.open("#{$bookFileName}.#{lang}.html", 'w') do |output|
      output.write(book_content)
    end

    $ebook_convert_cmd = ENV['ebook_convert_path'].to_s
    if $ebook_convert_cmd.empty?
      $ebook_convert_cmd = `which ebook-convert`.chomp
    end
    if $ebook_convert_cmd.empty?
      mac_osx_path = '/Applications/calibre.app/Contents/MacOS/ebook-convert'
      $ebook_convert_cmd = mac_osx_path
    end

    system($ebook_convert_cmd, "#{$bookFileName}.#{lang}.html", "#{$bookFileName}.#{lang}.#{format}",
           '--cover', 'book-cover.png',
           '--authors', authors,
           '--comments', comments,
           '--level1-toc', '//h:h1',
           '--level2-toc', '//h:h2',
           '--level3-toc', '//h:h3',
           '--language', lang)
  end
end
end

# 
# Cleanup
#

mv("#{$bookFileName}.en.epub", "#{$outputDirectory}/#{$bookFileName}.epub")
mv("#{$bookFileName}.en.mobi", "#{$outputDirectory}/#{$bookFileName}.mobi")
mv("#{$bookFileName}.en.pdf", "#{$outputDirectory}/#{$bookFileName}.pdf")
rm("#{$bookFileName}.en.html")
FileUtils.rm_rf($en)
