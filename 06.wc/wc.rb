# frozen_string_literal: true

require 'optparse'

def print_count
  options = parse_options
  file_paths = ARGV
  file_data = file_paths.empty? ? [process_input] : file_paths.map { |fp| process_input(fp) }
  file_paths = [''] if file_paths.empty?
  print_results(options, file_data, file_paths)
end

def print_results(options, file_data, file_paths)
  total = file_data.transpose.map(&:sum)
  file_paths.zip(file_data).each do |file_path, counts|
    print_file_data(options, *counts, file_path)
  end
  return unless file_paths.size >= 2

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

def process_input(file_path = nil)
  contents = file_path ? File.read(file_path) : $stdin.read
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
  if options.any?
    print line_count.to_s.rjust(5) if options[:lines]
    print word_count.to_s.rjust(5) if options[:words]
    print byte_count.to_s.rjust(5) if options[:bytes]
    puts ' total'
  else
    puts "  #{line_count}  #{word_count}  #{byte_count}  total"
  end
end

print_count
