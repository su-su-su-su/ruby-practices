# frozen_string_literal: true

def directory
  Dir.glob('*')
end

def row_legth
  (directory.size / 3.to_f).ceil # 出力の行数を指定
end

def insert_blank
  directory_max_legth = directory.map(&:length).max # ファイルの最大の文字数を出す
  directory.each do |name|
    if name.length < directory_max_legth
      difference = directory_max_legth - name.length
      name << (' ' * difference)
    end
  end
end

def sort_by
  name = insert_blank.each_slice(row_legth).to_a
  name[0].zip(*(name[1..nil])) do |i|
    print i.join(''.ljust(10))
    puts
  end
end

sort_by
