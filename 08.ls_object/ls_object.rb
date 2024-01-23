#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'directory'

options = ARGV.getopts('alr')
directory = Directory.new(options)
directory.print_ls
