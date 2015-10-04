require "rubygems"
require "activerecord"

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", database => "db/stations.db")

class Station < ActiveRecord::Base
end
