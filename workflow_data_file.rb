require 'rubygems'
require 'pbs_feed'

class WorkflowDataFile < ActiveRecord::Base
	
	#upload
	def self.save(upload)

		name = upload["datafile"].original_filename
		directory = "public/data"

		#create the file path
		path = File.join(directory, name)

		#write file
		File.open(path, "wb") { |f| f.write( upload['datafile'].read ) }

		path
	end

	#feed generate
	def self.feed_generate(path, special)

		feed = PBS_Feed.new
		feed.parse_csv path
		feed.transform special
	end
end