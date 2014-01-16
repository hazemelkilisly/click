class ApplicationController < ActionController::Base
  protect_from_forgery
  after_filter :set_access_control_headers

  def require_user_login
    unless current_user
      redirect_to new_user_session_path, alert: 'You must log-in first!'
    end
  end
  def require_user_auth(args)
    remote = Remote.find(args)
    if(current_user)
    	if(remote)
		    unless remote.user == current_user
		      redirect_to root_path, alert: "You don't own this remote!"
		    end
  		else
  			redirect_to root_path, alert: "Please choose a correct remote!"
  		end
  	else
  		redirect_to new_user_session_path, alert: 'You must log-in first!'
  	end
  end

  def set_access_control_headers
          headers['Access-Control-Allow-Origin'] = '*'
          headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
          headers['Access-Control-Allow-Headers'] = %w{Origin Accept Content-Type X-Requested-With X-CSRF-Token}.join(',')
          headers['Access-Control-Max-Age'] = "1728000"
  end

end
