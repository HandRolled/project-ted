#!/usr/bin/env ruby

require '../database'
require '../models'

###############################################################################

Dir.glob('../transcripts/*.txt') do |text_file|
  title = text_file.split('/').last.split('.').first

  # Find or create Talk
  talk = Talk.find_or_create_by(title: title)
  talk.words = []

  # Scan file for words
  position = 0
  File.foreach(text_file) do |line|
    line.split.map(&:strip).map(&:downcase).each do |w|
      # Remove punctuation from start/end of string
      normalized_word = w.gsub(/^[?.!,:;'"]?/, '').gsub(/[?.!,:;'"]?$/, '')

      unless normalized_word.empty?
        word = Word.find_or_create_by(normalized_text: normalized_word)
        Appearance.create(from_node: word, to_node: talk, position: position)
        position += 1
      end
    end
  end
end

