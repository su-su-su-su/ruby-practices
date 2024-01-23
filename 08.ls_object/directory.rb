#!/usr/bin/env ruby
# frozen_string_literal: true

require 'etc'
require_relative 'file_info'

class Directory
  def initialize(options)
    @options = options
  end

  def print_ls
    files = Dir.glob('*', @options['a'] ? File::FNM_DOTMATCH : 0)
    files = files.reverse if @options['r']
    if @options['l']
      print_file_details(files)
      return nil
    end
    print_files_in_columns(files)
  end

  private

  def print_file_details(files)
    file_infos = files.map { |files| FileInfo.new(files) }
    files_blocks = file_infos.map(&:blocks)
    puts "total #{files_blocks.sum}"
    file_infos.each do |file_info|
      print file_info.file_types
      print file_info.permissions
      print file_info.nlink.to_s.rjust(2)
      print file_info.uid.rjust(7)
      print file_info.gid.rjust(7)
      print file_info.size.to_s.rjust(5)
      print file_info.mtime.strftime('%b %e %H:%M').rjust(13)
      puts " #{file_info.name}"
    end
  end

  def row_length(files)
    (files.size / 3.to_f).ceil # 出力の行数を指定
  end

  def insert_blank(files)
    rows = files.each_slice(row_length(files)).to_a
    max_length = rows.map { |row| row.map(&:length).max }
    rows.map.with_index do |row, index|
      row_max_length = max_length[index]
      row.map { |file| file.ljust(row_max_length + 2) }
    end.flatten
  end

  def print_files_in_columns(files)
    name = insert_blank(files).each_slice(row_length(files)).to_a
    name[0].zip(*(name[1..nil])) do |column|
      print column.join
      puts
    end
  end
end
