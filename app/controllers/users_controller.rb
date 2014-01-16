class UsersController < ApplicationController
	before_filter :require_user_login, :only=> [:index, :waiting, :discard_waiting, :favorites]
	def index
		@user = current_user
		@remotes = @user.remotes
	end
	def get_pushed
		user = User.find(params[:id])
		pushed_b = user.get_pushed
		# render text: pushed_b.join(',')
		render text: "record,123"
	end
	def update_button
		current_user.waiting_code(params[:code])
		render nothing: true
	end
	def waiting
		@button = nil
		current_user.remotes.each do |remote|
	      x = remote.buttons.where(:waiting_code => true).first
	      if x
	      	@button = x
	        break
	      end
	  	end
		unless @button
			redirect_to root_url, alert: "There are no buttons waiting to be defined."
		end
	end
	def answered
		@button = nil
		user = User.find(params[:id])
		user.remotes.each do |remote|
	      x = remote.buttons.where(:waiting_code => true).first
	      if x
	      	@button = x
	        break
	      end
	  	end
		unless @button
			render text: 'supplied'
		else
			render text: 'fail'
		end
	end
	def discard_waiting
		@button = nil
		current_user.remotes.each do |remote|
	      x = remote.buttons.where(:waiting_code => true).first
	      if x
	      	@button = x
	        break
	      end
	  	end
	  	if @button
	  		@button.delete
	  	end
	  	redirect_to root_url, alert: "Discarded #{@button.function.humanize} Button!"
	end
	def favorites
		@songs = current_user.songs
	end
	def add_favorite
		if params[:song] && params[:artist] && params[:id]
			@user = User.find(params[:id])
			if @user
				song = Song.create(:name => params[:song], :name_cred => params[:song_id], :artist => params[:artist], :artist_cred => params[:artist_id], :user => @user)
				if params[:download_link]
					song.download_link = params[:download_link]
					song.save
				end
				if params[:img]
					song.image = params[:img]
					song.save
				end
			end
		end
		render nothing: true
	end
end
