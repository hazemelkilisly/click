class Song
  include Mongoid::Document
  include Mongoid::Timestamps

	field :name, :type => String
	field :name_cred, :type => String

	field :artist, :type => String
	field :artist_cred, :type => String
	
	field :download_link, :type => String
	field :image, :type => String

	belongs_to :user
end
