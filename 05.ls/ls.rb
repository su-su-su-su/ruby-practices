#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def options
  ARGV.getopts('l')
end

def directory
  Dir.glob('*')
end

def print_ls
  options['l'] ? print_file_details : print_files_in_columns
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

def print_files_in_columns
  name = insert_blank.each_slice(row_legth).to_a
  name[0].zip(*(name[1..nil])) do |i|
    print i.join
    puts
  end
end

def file_details
  directory.map do |d|
    File::Stat.new(d)
  end
end

def files_blocks
  file_details.map(&:blocks)
end

def file_types(file_type)
  {
    file: '-',
    directory: 'd',
    characterSpecial: 'c',
    blockSpecial: 'b',
    fifo: 'p',
    link: 'l',
    socket: 's'
  }[file_type]
end

def permissions(permission)
  {
    '0': '---',
    '1': '--x',
    '2': '-w-',
    '3': '-wx',
    '4': 'r--',
    '5': 'r-x',
    '6': 'rw-',
    '7': 'rwx'
  }[permission]
end

def print_file_details
  puts "total #{files_blocks.sum}"
  directory.each do |x|
    fs = File::Stat.new(x)
    fill = fs.mode.to_s(8)
    print file_types(fs.ftype.to_sym)
    print permissions(fill[-3].to_sym) + permissions(fill[-2].to_sym) + permissions(fill[-1].to_sym)
    print fs.nlink.to_s.rjust(2)
    print Etc.getpwuid(File.stat(x).uid).name.rjust(7)
    print Etc.getpwuid(File.stat(x).gid).name.rjust(7)
    print fs.size.to_s.rjust(5)
    print fs.mtime.strftime('%b %e %H:%M').to_s.rjust(13)
    puts " #{x}"
  end
end

print_ls
