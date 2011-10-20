require 'sinatra'
require 'nokogiri'
require 'open-uri'
require 'builder'

NAME     = 0
LOCATION = 1
DATE     = 2
TIME     = 3

get '/' do
  puts "DBG params=#{params.inspect}"
  get_schedule_for params["date"], params["filter"]
end

get '/StickAndPuck' do
  get_schedule_for params["date"], "stick and puck"
end

private
def get_schedule_for(date, event_filter=nil)
  date ||= Time.now.strftime("%Y-%m-%d")
  doc  = Nokogiri::HTML(open('http://www.thechiller.com/rink-schedule'))
  rows = doc.css("tr[@class='#{date}']")

  return "No events found for #{date}" if rows.empty?
  xml = build_xml_for_rows rows, event_filter
  return "No events found for '#{date}' and '#{event_filter}'" if !xml.include?("<event>")
  xml
end

def build_xml_for_rows(rows, event_filter)
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.schedule do
      rows.each do |row|
        contents = row.children.collect {|c| c.content}
        if event_filter.nil? or contents.join(" ").match /#{event_filter}/i
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
