#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require_relative 'file_info'

class Directory
  def initialize(options)
    @options = options
  end

  def print_ls
    lists = Dir.glob('*',  @options['a'] ? File::FNM_DOTMATCH : 0)
    lists = lists.reverse if  @options['r']
    return print_file_details(lists) if  @options['l']

    print_files_in_columns(lists)
  end

  def print_file_details(lists)
    file_details = lists.map do |list|
      File::Stat.new(list)
    end
    files_blocks = file_details.map(&:blocks)
    puts "total #{files_blocks.sum}"
    lists.each do |list|
      file_info = FileInfo.new(list)
      print file_info.file_types
      print file_info.permissions
      print file_info.nlink.to_s.rjust(2)
      print Etc.getpwuid(file_info.uid).name.rjust(7)
      print Etc.getpwuid(file_info.gid).name.rjust(7)
      print file_info.size.to_s.rjust(5)
      print file_info.mtime.strftime('%b %e %H:%M').to_s.rjust(13)
      puts " #{list}"
    end
  end

  private

  def row_legth(lists)
    (lists.size / 3.to_f).ceil # 出力の行数を指定
  end

  def insert_blank(lists)
    directory_max_length = lists.map(&:length).max # ファイルの最大の文字数を出す
    lists.map do |list|
      list.ljust(directory_max_length + 10)
    end
  end

  def print_files_in_columns(lists)
    name = insert_blank(lists).each_slice(row_legth(lists)).to_a
    name[0].zip(*(name[1..nil])) do |i|
      print i.join
      puts
    end
  end
end
