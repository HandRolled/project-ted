#!/usr/bin/env ruby

require 'mechanize'

INDEX_URL = 'https://www.ted.com/talks/quick-list'.freeze
TALK_URL_REGEX = /\A\/talks\/[A-Za-z0-9\w]*\z/

mechanize = Mechanize.new

###############################################################################
# Fetch all talks from the index
puts "\nFetching talks:"
talk_urls = []
page_number = 1
loop do
  page = mechanize.get("#{INDEX_URL}?page=#{page_number}")
  links = page.links.select { |l| !TALK_URL_REGEX.match(l.uri.to_s).nil? }
  urls = links.map { |link| "#{link.resolved_uri.to_s}/transcript?language=en" }

  break if urls.empty?
  talk_urls.concat urls
  page_number = page_number + 1
end

puts " found #{talk_urls.count} talks"

###############################################################################
puts "\nFetching transcripts:"

talk_urls.each do |talk_url|
  begin
    talk = mechanize.get(talk_url)
    transcript = talk.at('.talk-transcript__body')
    unless transcript.nil?
      title = /\/talks\/([A-Za-z0-9_\-.]*)\/transcript/.match(talk.uri.to_s).captures.first
      File.open("../transcripts/#{title}.txt", 'w') { |f| f.write(transcript.text.strip) }
      puts " saved #{title}.txt"
    end
  rescue
    puts "[ERROR]#{talk_url}"
  end
end
