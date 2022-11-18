#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def options
  ARGV.getopts('a')
end

def directory
  case options['a']
  when true
    Dir.glob('*', File::FNM_DOTMATCH)
  when false
    Dir.glob('*')
  end
end

def row_legth
  (directory.size / 3.to_f).ceil # 出力の行数を指定
end

def directory_max_legth
  directory.map(&:length).max # ファイルの最大の文字数を出すend
end

def insert_blank
  directory.map do |file|
    file.ljust(directory_max_legth + 10)
  end
end

def sort_by
  name = insert_blank.each_slice(row_legth).to_a
  name[0].zip(*(name[1..nil])) do |i|
    print i.join
    puts
  end
end

sort_by
