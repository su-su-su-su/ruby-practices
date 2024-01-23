# frozen_string_literal: true

class FileInfo
  def initialize(list)
    @file_stat = File::Stat.new(list)
    @list = list
  end

  FILE_TYPES = {
    'file' => '-',
    'directory' => 'd',
    'characterSpecial' => 'c',
    'blockSpecial' => 'b',
    'fifo' => 'p',
    'link' => 'l',
    'socket' => 's'
  }.freeze

  PERMISSIONS = {
    '0' => '---',
    '1' => '--x',
    '2' => '-w-',
    '3' => '-wx',
    '4' => 'r--',
    '5' => 'r-x',
    '6' => 'rw-',
    '7' => 'rwx'
  }.freeze

  def name
    @list
  end

  def blocks
    @file_stat.blocks
  end

  def mode
    @file_stat.mode
  end

  def nlink
    @file_stat.nlink
  end

  def uid
    Etc.getpwuid(@file_stat.uid).name
  end

  def gid
    Etc.getpwuid(@file_stat.gid).name
  end

  def size
    @file_stat.size
  end

  def mtime
    @file_stat.mtime
  end

  def file_types
    FILE_TYPES[@file_stat.ftype]
  end

  def permissions
    fill = mode.to_s(8)
    PERMISSIONS[fill[-3]] + PERMISSIONS[fill[-2]] + PERMISSIONS[fill[-1]]
  end
end
