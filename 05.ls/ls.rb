# frozen_string_literal: true

def directory
  Dir.glob('*')
end

def row_legth
  (directory.size / 3.to_f).ceil # 出力の行数を指定
end

def insert_blank
  directory_max_legth = directory.map(&:length).max # ファイルの最大の文字数を出す
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
