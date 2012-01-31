module MadChatter
  class Users
    
    def initialize
      @users = {}
    end

    def add(token, username = nil)
      @users[token] = username
    end
        
    def update(token, username)
      @users[token] = username
    end
    
    def remove(token)
      @users.delete(token)
    end
    
    def find_username_by_token(token)
      @users[token]
    end
    
    def current
      @users.values
    end
    
    def token_exists?(token)
      @users[token].exists?
    end
    
    def to_json
      JSON.generate({
        type: 'users',
        json: current,
      })
    end
    
  end
end