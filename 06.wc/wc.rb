# frozen_string_literal: true

require 'optparse'

def print_count
  options = parse_options
  file_paths = ARGV
  file_data = $stdin.tty? ? file_paths.map { |fp| process_file(fp) } : [process_piped_input]
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

def process_file(file_path)
  contents = File.read(file_path)
  [contents.count("\n"), contents.split.size, contents.bytesize]
end

def process_piped_input
  contents = $stdin.read
  [contents.count("\n"), contents.split.size, contents.bytesize]
end

def print_file_data(options, line_count, word_count, byte_count, file_path)
  print line_count.to_s.rjust(4) if options[:lines] || options.empty?
  print word_count.to_s.rjust(5) if options[:words] || options.empty?
  print byte_count.to_s.rjust(5) if options[:bytes] || options.empty?
  puts " #{file_path}"
end

def print_totals(options, total)
  if options.any?
    print total[0].to_s.rjust(5) if options[:lines]
    print total[1].to_s.rjust(5) if options[:words]
    print total[2].to_s.rjust(5) if options[:bytes]
    puts ' total'
  else
    puts "  #{total[0]}  #{total[1]}  #{total[2]}  total"
  end
end

print_count
