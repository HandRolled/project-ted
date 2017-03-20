require 'neo4j'
require 'neo4j/session_manager'

# Setup Database Connection
neo4j_url = ENV['NEO4J_URL'] || 'http://neo4j:password@localhost:7474'

# Neo4j::Core::CypherSession::Adaptors::Base.subscribe_to_query(&method(:puts))

adaptor_type = neo4j_url.match(/^bolt:/) ? :bolt : :http
Neo4j::ActiveBase.on_establish_session do
  Neo4j::SessionManager.open_neo4j_session(adaptor_type, neo4j_url)
end

session = Neo4j::ActiveBase.current_session
