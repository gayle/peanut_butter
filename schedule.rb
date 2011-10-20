require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'builder'

get '/' do
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.schedule do
      xml.event do
        xml.name "Stick and Puck"
        xml.location "Easton"
        xml.date "10/19/2011"
        xml.time "10am - 11am"
      end
    end
  end
#  today = Time.now.strftime("%Y-%m-%d")
#  doc = Nokogiri::HTML(open('http://www.thechiller.com/rink-schedule'))
#  rows = doc.css("tr[@class='#{today}']")
#  rows_to_display = []
#  rows.each do |r|
#    puts "-----"
#    r.children.each do |child|
#      puts child.content
#      if child.content.include?("Dublin 2")
#        rows_to_display << r
#      end
#    end
#  end
#
#  output_str = ""
#  rows_to_display.each do |row|
#    output_str += "<br />-----"
#    row.children.each do |c|
#      output_str += "<br />#{c.content}"
#    end
#    output_str += "<br />-----"
#  end
#  output_str

end