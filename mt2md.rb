$:.unshift File.dirname(__FILE__)

require 'lib/base'
require 'lib/category'
require 'lib/entry'
require 'logger'

logger = Logger.new(STDOUT)

entries = Entry.find_all
logger.info("Export #{entries.size} entries by markdown file")

entries.each_with_index do |entry, index|
  logger.info("Exporting ... #{index+1}/#{entries.size}") if index % 10 == 0

  entry.make_build_dir! unless entry.has_build_dir?
  entry.export!
end

logger.info("Done.")
