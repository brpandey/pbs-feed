require 'rubygems'
require 'csv'
require 'xml/xslt'
require 'rexml/document'

class PBS_Feed

	@@c_report_header_id_token = "call letters"
	@@c_report_footer_id_token = "carriage information"

	#make map out of feed column names
	@@c_report_headers_map = {
		"Call Letters" => "station_name",
		"Date Aired" => "airdate",
		"Time Aired" => "airtime",
		"T.Z." => "timezone",
		"Episode" => "episode",
		"Duration" => "duration",
		"DMA Rank" => "dma_rank",
		"Percent Coverage" => "percent_coverage"
		"Market" => "market"
	}

	def transform(special)
		#transform 1
		xslt1 = XML::XSLT.new
		xslt1.xml = "tmp/station.listing.xml"
		xslt1.xsl = "app/helpers/station.listing.xsl"

		#write contents to file
		File.open('tmp/station.display.xml', 'w') do |file|
			file.print xslt1.serve
		end

		#transform 2
		xslt2 = XML::XSLT.new
		xslt2.xml = "tmp/station.display.xml"

		if special then
			xslt2.xsl = "app/helpers/station.jordan.display.xsl"
		else
			xslt2.xsl = "app/helpers/station.display.xsl"
		end

		#write html contents to file
		File.open('app/views/workflow/station.html', 'w') do |file|
			file.print xslt2.serve
		end
	end

	def parse_csv(path)
		reached_table_header_flag = FALSE
		reached_table_footer_flag = FALSE

		initialized_xml_flag = FALSE
		token = NIL
		xml_document = NIL
		listing = NIL

		CSV.open(path, 'r') do |row|
			
			#look at the valid csv cells
			if row[0].instance_of? CSV::Cell
				token = row[0].to_str.downcase

				#handle row
				#note: order of conditionals important here:
				#footer, middle, then header
				#check to make sure if we've reached the table end
				if token.start_with? @@c_report_footer_id_token
					reached_table_footer_flag = TRUE

				#parse only if we are between the table header and footer
				elsif TRUE == reached_table_header_flag && 
					FALSE == reached_table_footer_flag

					#invoke initialize_feed method only once per csv parse
					if FALSE == initialized_xml_flag
						xml_document, listing = initialize_feed
						initialized_xml_flag = TRUE
					end

					parse_csv_helper(row, listing)

				#indicate we've found beginning of data section
				elsif token == @@c_report_header_id_token &&
					@@c_report_headers_map.length == row.length
					reached_table_header_flag = TRUE

				end
			end
		end

		if FALSE == reached_table_footer_flag || FALSE == reached_table_header_flag
			puts "Input report file missing proper delimiters"
		end

		#write xml contents to file
		File.open('tmp/station.listing.xml', 'w') do |file|
			file.puts xml_document.to_s
		end

		xml_document
	end

	def parse_csv_helper(row, xml_document)

		if @@c_report_headers_map.length == row.length
			station_name = row[0].to_s
			station_record = Station.find(:first, :conditions => ["name = ? AND broadcast_area != ? AND url != ?", station_name, "", ""])

			if station_record.instance_of? Station
				item = xml_document.add_element 'item'
				station = item.add_element 'station'
				station.add_element('name').text = station_name
				station.add_element('link').text = station_record.url.to_s
				item.add_element('date').text = row[1].to_s
				item.add_element('time').text = row[2].to_s
				item.add_element('timezone').text = row[3].to_s
				item.add_element('episode').text = row[4].to_s
				item.add_element('duration').text = row[5].to_s
				item.add_element('state').text = station_record.state.to_s
				item.add_element('area').text = station_record.broadcast_area.to_s
			else
				#handle new stations not already in the db
			end
		end
	end

	def initialize_feed

		t = Time.now

		doc = REXML:: Document.new('<?xml version="1.0" encoding="UTF-8"?>')

		channel = doc.add_element 'channel'
		channel.attributes['xmlns:globetrotting'] = "http://www.globetrotting.com/schema"
		channel.attributes['xmlns:cms'] = "http://www.globetrotting.com/internal/CMS/schema"
		channel.add_element('type').text = "station_listing"
		channel.add_element('name').text = "pbs_national_broadcast_airdates"
		channel.add_element('media_type').text = "tv"
		channel.add_element('description')
		channel.add_element('provider').text = "trac"

		channel.add_element('date_created').text = t.ctime
		channel.add_element('cms:expires').text = "12/30/2099"
		channel.add_element('cms:node-type').text = "station display"
		
		gt_show = channel.add_element('globetrotting show')
		gt_show.attributes['type'] = 'internal'

		gt_show.add_element('globetrotting:title').text = "Globe Trotting Jordan"
		gt_show.add_element('globetrotting:subtitle').text = "Globe Trotting Jordan Yesterday and Today"
		gt_show.add_element('globetrotting:author').text = "Laura McKenzie, Anthony Bourdain, Tony Wheeler"
		gt_show.add_element('globetrotting:summary').text = "Come see a place that's packed with 
			sumptuous cuisine and rich history..."

		gt_show.add_element('globetrotting:category').text = "Jordan Special"

		listing = channel.add_element 'listing' 
		[doc, listing]
	end

end
