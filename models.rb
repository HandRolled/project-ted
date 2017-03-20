require 'neo4j'

class Appearance
  include Neo4j::ActiveRel

  property :position # Where in the talk the word appears

  from_class 'Word'
  to_class 'Talk'

  type :APPEARED_IN
end

class Talk
  include Neo4j::ActiveNode

  # Properties
  id_property :title

  property :created_at
  property :updated_at

  # Associations
  has_many :in, :words, model_class: :Word, rel_class: 'Appearance'

  # Validations
  validates :title, presence: true
end

class Word
  include Neo4j::ActiveNode

  # Properties
  id_property :normalized_text
  property :is_stop_word, type: Boolean, default: false

  property :created_at
  property :updated_at

  # Associations
  has_many :out, :appearances, model_class: :Talk, rel_class: 'Appearance'

  # Validations
  validates :normalized_text, presence: true
end
