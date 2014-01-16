class Remote
  include Mongoid::Document
  include Mongoid::Timestamps

	field :name, :type => String
	field :published, :type => Boolean, :default => false

	belongs_to :user
	has_many :buttons
end
