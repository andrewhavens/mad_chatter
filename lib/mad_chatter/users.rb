module MadChatter
  class Users
    
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
      
      def find_username_by_token(token)
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