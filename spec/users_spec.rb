# require 'spec_helper'
# 
# describe MadChatter::Users do
#   
#   it 'should have a well-known interface' do
#     [:users, :add, :update, :remove, :find_username_by_token, :current, :token_exists?].each do |m|
#       MadChatter::Users.should respond_to(m)
#     end
#   end
#   
#   it 'should store users and their usernames' do
#     MadChatter::Users.add 'token1', 'username1'
#     MadChatter::Users.add 'token2', 'username2'
#     MadChatter::Users.current.should == ['username1', 'username2']
#   end
#   
#   it 'should encode into JSON correctly' do
#     MadChatter::Users.add 'token1', 'username1'
#     MadChatter::Users.add 'token2', 'username2'
#     MadChatter::Users.to_json.should == '{"type":"users","json":["username1","username2"]}'
#   end
#   
# end