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
  doc   = Nokogiri::HTML(open('http://www.thechiller.com/rink-schedule'))
  rows  = doc.css("tr[@class='#{today}']")

  return "No events found for #{today}" if rows.empty?
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.schedule do
      rows.each do |row|
        xml.event do
          xml.name row.children[NAME].content
          xml.location row.children[LOCATION].content
          xml.date row.children[DATE].content
          xml.time row.children[TIME].content
        end
      end
    end
  end
end