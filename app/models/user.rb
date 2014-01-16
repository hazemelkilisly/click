class User
  include Mongoid::Document
  include Mongoid::Timestamps
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable, :registerable, :recoverable and :omniauthable
  devise :database_authenticatable,
         , :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""
  
  # ## Recoverable
  # field :reset_password_token,   :type => String
  # field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  ## Token authenticatable
  # field :authentication_token, :type => String
  has_many :remotes
  has_many :songs

  def get_pushed
    pressed = []
    remotes.each do |remote|
      remote.buttons.each do |button|
        if(button.currently_pressed)
          pressed << button.code
          button.currently_pressed = false
          button.save
          if(button.function == "play")
            pressed << "record"
          end
        end
      end
    end
    pressed
  end

  def waiting_code(c)
    remotes.each do |remote|
      x = remote.buttons.where(:waiting_code => true).first
      if x
        x.code = c
        x.waiting_code = false
        x.save
        break
      end
      # remote.buttons.each do |button|
      #   if(button.waiting_code)
      #     button.code = c
      #     button.waiting_code = false
      #     button.save
      #     break
      #   end
      # end
    end
  end

end
