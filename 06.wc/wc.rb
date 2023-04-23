# frozen_string_literal: true

require 'optparse'

def print_count
  options = parse_options
  file_paths = ARGV
  file_info = file_paths.empty? ? { '' => process_input($stdin) } : file_paths.map { |fp| [fp, process_input(File.open(fp))] }.to_h
  print_results(options, file_info)
end

def print_results(options, file_info)
  total = file_info.values.transpose.map(&:sum)
  file_info.each do |file_path, counts|
    print_file_data(options, *counts, file_path)
  end
  return unless file_info.size >= 2

  print_totals(options, total)
end

def parse_options
  options = {}
  OptionParser.new do |opts|
    opts.on('-w') { options[:words] = true }
    opts.on('-l') { options[:lines] = true }
    opts.on('-c') { options[:bytes] = true }
  end.parse!
  options
end

def process_input(input)
  contents = input.read
  [contents.count("\n"), contents.split.size, contents.bytesize]
end

def print_file_data(options, line_count, word_count, byte_count, file_path)
  options = { lines: true, words: true, bytes: true } if options.empty?
  print line_count.to_s.rjust(4) if options[:lines]
  print word_count.to_s.rjust(5) if options[:words]
  print byte_count.to_s.rjust(5) if options[:bytes]
  puts " #{file_path}"
end

def print_totals(options, total)
  line_count, word_count, byte_count = total
  options = { lines: true, words: true, bytes: true } if options.empty?
  print line_count.to_s.rjust(5) if options[:lines]
  print word_count.to_s.rjust(5) if options[:words]
  print byte_count.to_s.rjust(5) if options[:bytes]
  puts ' total'
end

print_count
