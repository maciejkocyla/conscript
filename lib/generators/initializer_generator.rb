class InitializerGenerator < Rails::Generators::Base

  def create_initializer_file
    create_file "config/initializers/initializer.rb", "# Add initialization content here"
  end

  def scaffold_user_and_session
    generate "scaffold", "users name:string email:string remember_token:string"
    generate "controller", "sessions "
  end

  def set_of_gems
    gem "bcrypt-ruby"
  end

  def session_helper_autocomplete

    inject_into_file "app/helpers/sessions_helper.rb", after: "module SessionsHelper\n" do <<-'RUBY'
      def sign_in(user)        
        remember_token = User.new_remember_token
        cookies.permanent[:remember_token] = remember_token
        user.update_attribute(:remember_token, User.encrypt(remember_token))
        self.current_user = user
      end                      
     
      def signed_in?           
        !current_user.nil?     
      end       

      def current_user=(user)  
        @current_user = user   
      end                      

      def current_user?(user)  
        user == current_user   
      end
  
      def current_user
        remember_token = User.encrypt(cookies.permanent[:remember_token])
        @current_user ||= User.find_by(remember_token: remember_token)
      end
       
      def sign_out
        current_user.update_attribute(:remember_token, User.encrypt(User.new_remember_token))
        cookies.delete(:remember_token) 
        self.current_user = nil
      end
       
      def root?
        signed_in? && current_user.admin?
      end

    RUBY
  end
  end

  def users_model_autocomplete
    inject_into_file "app/models/user.rb", after: "class User < ActiveRecord::Base\n" do <<-'RUBY'
        
      has_secure_password      
      before_save { self.email = email.downcase } 
      before_save :create_remember_token
      validates :password, length: { minimum: 6 }
      validates :name, presence: true, length: { maximum: 25 }
      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
      validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

      def User.new_remember_token
        SecureRandom.urlsafe_base64
      end
       
      def User.encrypt(token)
        Digest::SHA1.hexdigest(token.to_s)
      end
      
      private
        def create_remember_token
          if self.remember_token.nil?     
            self.remember_token = User.encrypt(User.new_remember_token)
          end
        end

    RUBY
    end
  end

end
