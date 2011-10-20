require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'builder'

NAME     = 0
LOCATION = 1
DATE     = 2
TIME     = 3

get '/' do
  today = Time.now.strftime("%Y-%m-%d")
  get_schedule_for today
end

get '/StickAndPuck' do
  today = Time.now.strftime("%Y-%m-%d")
  get_schedule_for today, "stick and puck"
end

private
def get_schedule_for(date, event_filter=nil)
  doc  = Nokogiri::HTML(open('http://www.thechiller.com/rink-schedule'))
  rows = doc.css("tr[@class='#{date}']")

  return "No events found for #{date}" if rows.empty?
  return_val = build_xml_for_rows rows, event_filter
  puts "return value is #{return_val.class} #{return_val.inspect}"

  return_val
end

def build_xml_for_rows(rows, event_filter)
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.schedule do
      rows.each do |row|
        contents = row.children.collect {|c| c.content}
        if event_filter.nil? or contents.join(" ").match /event_filter/i
          xml.event do
            xml.name contents[NAME]
            xml.location contents[LOCATION]
            xml.date contents[DATE]
            xml.time contents[TIME]
          end
        end
      end
    end
  end
end

