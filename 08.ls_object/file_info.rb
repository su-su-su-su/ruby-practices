# frozen_string_literal: true

class FileInfo
  def initialize(file_path)
    @file_stat = File::Stat.new(file_path)
  end

  def mode
    @file_stat.mode
  end

  def nlink
    @file_stat.nlink
  end

  def uid
    @file_stat.uid
  end

  def gid
    @file_stat.gid
  end

  def size
    @file_stat.size
  end

  def mtime
    @file_stat.mtime
  end

  def file_types
    types = {
      'file' => '-',
      'directory' => 'd',
      'characterSpecial' => 'c',
      'blockSpecial' => 'b',
      'fifo' => 'p',
      'link' => 'l',
      'socket' => 's'
    }
    types[@file_stat.ftype]
  end

  def permissions
    permissions = {
      '0' => '---',
      '1' => '--x',
      '2' => '-w-',
      '3' => '-wx',
      '4' => 'r--',
      '5' => 'r-x',
      '6' => 'rw-',
      '7' => 'rwx'
    }
    fill = mode.to_s(8)
    permissions[fill[-3]] + permissions[fill[-2]] + permissions[fill[-1]]
  end
end
