module MadChatter
  
  class Users
    
    # Singleton storage for all current users
    class << self
      
      def users
        @users ||= {}
      end
    
      def update(token, username)
        MadChatter::Users.users[token] = username
      end
      
      def remove(token)
        MadChatter::Users.users.delete(token)
      end
      
      def username(token)
        MadChatter::Users.users[token]
      end
      
      def current
        MadChatter::Users.users.values
      end
      
      def token_exists?(token)
        MadChatter::Users.users[token].exists?
      end
    end
    
  end
  
end