#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

def options
  ARGV.getopts('alr')
end

def print_ls
  opt = options
  dir = Dir.glob('*', opt['a'] ? File::FNM_DOTMATCH : 0)
  dir = dir.reverse if opt['r']
  return print_file_details(dir) if opt['l']

  directory_max_length(dir)
end

def directory_max_length(dir)
  max = dir.map(&:length).max # ファイルの最大の文字数を出す
  insert_blank(dir, max)
end

def insert_blank(dir, max)
  blank = dir.map do |file|
    file.ljust(max + 10)
  end
  print_value_obtained(dir, blank)
end

def print_value_obtained(dir, blank)
  row = (dir.size / 3.to_f).ceil # 出力の行数を指定
  print_files_in_columns(blank, row)
end

def print_files_in_columns(blank, row)
  name = blank.each_slice(row).to_a
  name[0].zip(*(name[1..nil])) do |i|
    print i.join
    puts
  end
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

def print_file_details(dir)
  file_details = dir.map do |d|
    File::Stat.new(d)
  end
  files_blocks = file_details.map(&:blocks)
  puts "total #{files_blocks.sum}"
  dir.each do |x|
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
