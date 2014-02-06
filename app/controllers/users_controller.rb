class UsersController < ApplicationController
	before_filter :require_user_login, :only=> [:index, :waiting, :discard_waiting, :favorites]
	def index
		@user = current_user
		@remotes = @user.remotes
	end
	def get_pushed
		user = User.find(params[:id])
		pushed_b = user.get_pushed
		render text: pushed_b.join(',')
		# render text: "record,123"
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

	def query
		if params[:q]
			user = User.find(params[:id])
			str = params[:q].downcase.split()
			if (str.size == 2 || str.size == 3)
				remote = user.remotes.where(:name => str[0]).first
				if remote
					if str.size == 2
						button = remote.buttons.where(:function => (str[1])).first
					else
						button = remote.buttons.where(:function => (str[1]+"_"+str[2])).first
					end
					if button
						button.currently_pressed = true
						button.save
						render text: "Accepted"
					else
						if str.size == 2
							render text: "You specified non defined remote functionality: "+str[1]
						else
							render text: "You specified non defined remote functionality: "+str[1]+" "+str[2]
						end
					end
				else
					render text: "You specified non existing remote: "+str[0]
				end
			else
				render text: "Text length is not matching: "+str.join(" ")
			end
		else
			render text: "You are sending no query!"
		end
	end
end
