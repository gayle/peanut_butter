require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'builder'

get '/' do
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

  builder :index

end