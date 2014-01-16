class RemotesController < ApplicationController
	before_filter :require_user_login
	# before_filter(:only => [:index]) do |c| c.send(:check_responsibility, params[:id]) end
	def show
		@remote = Remote.find(params[:id])
		unless @remote.published
 			render :template => "remotes/new"
 		end
	end

	def new
		if params[:fun]
			@remote = Remote.create(:name => params[:fun])
			@remote.user = current_user
			@remote.save
		else
			redirect_to root_path, alert: "No type was correctly chosen!"
		end
	end

	def create
		@remote = Remote.new(params[:remote])
		@remote.user = current_user
	    @remote.save
	    redirect_to root_path
	end

	def edit
		@remote = Remote.find(params[:id])
	end

	def update
		@remote = Remote.update_attributes(params[:remote])
	    @remote.save
	    redirect_to root_path
	end

	def press
		@button = Button.find(params[:id])
	    @button.currently_pressed = true
	    @button.save
	    render nothing: true
	end
	
	def publish
		@remote = Remote.find(params[:id])
		@remote.published = true
		@remote.save
		redirect_to root_path, notice: "Successfully Added the remote!"
	end
	def discard
		@remote = Remote.find(params[:id])
		@remote.buttons.delete_all
	    @remote.delete
		redirect_to root_path, notice: "Successfully discarded the remote!"
	end
	def define
		@button = nil
		current_user.remotes.each do |remote|
	      x = remote.buttons.where(:waiting_code => true).first
	      if x
	      	@button = x
	        break
	      end
	  	end
		unless @button
			@remote = Remote.find(params[:id])
			@button = Button.create(:function => params[:function])
			@button.remote = @remote
			@button.save
			redirect_to waiting_users_path
		else
			redirect_to waiting_users_path, alert: "You already have a button that needs defining!"
		end		
	end
end
