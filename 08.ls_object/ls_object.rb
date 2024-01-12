#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'
require_relative 'file_info'

class Directory
  def initialize(options)
    @options = options
  end

  def print_ls
    opt = @options
    dir = Dir.glob('*', opt['a'] ? File::FNM_DOTMATCH : 0)
    dir = dir.reverse if opt['r']
    return print_file_details(dir) if opt['l']

    print_files_in_columns(dir)
  end

  def print_file_details(directory)
    file_details = directory.map do |d|
      File::Stat.new(d)
    end
    files_blocks = file_details.map(&:blocks)
    puts "total #{files_blocks.sum}"
    directory.each do |file_path|
      file_info = FileInfo.new(file_path)
      print file_info.file_types
      print file_info.permissions
      print file_info.nlink.to_s.rjust(2)
      print Etc.getpwuid(file_info.uid).name.rjust(7)
      print Etc.getpwuid(file_info.gid).name.rjust(7)
      print file_info.size.to_s.rjust(5)
      print file_info.mtime.strftime('%b %e %H:%M').to_s.rjust(13)
      puts " #{file_path}"
    end
  end

  private

  def row_legth(directory)
    (directory.size / 3.to_f).ceil # 出力の行数を指定
  end

  def insert_blank(directory)
    directory_max_length = directory.map(&:length).max # ファイルの最大の文字数を出す
    directory.map do |file|
      file.ljust(directory_max_length + 10)
    end
  end

  def print_files_in_columns(directory)
    name = insert_blank(directory).each_slice(row_legth(directory)).to_a
    name[0].zip(*(name[1..nil])) do |i|
      print i.join
      puts
    end
  end
end

options = ARGV.getopts('alr')
directory = Directory.new(options)
directory.print_ls
