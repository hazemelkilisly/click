class Button
  include Mongoid::Document
  include Mongoid::Timestamps

	field :function, :type => String
	field :code, :type => String
	field :currently_pressed, :type => Boolean, :default => false
	field :waiting_code, :type => Boolean, :default => true

	belongs_to :remote
end
