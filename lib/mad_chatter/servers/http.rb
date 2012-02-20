# require 'sqlite3'
# require 'sequel'
# require 'carrierwave/sequel'
require 'sinatra/base'

module MadChatter
  module Servers    
    class Http < Sinatra::Base

      class FileUploader < CarrierWave::Uploader::Base
        storage :file
      end

      # class FileUpload < Sequel::Model
      #   mount_uploader :file, FileUploader
      # end
      
      # set :environment, :production
      # set :root, File.dirname(__FILE__)
      # set :public_folder, File.dirname(__FILE__) + '/public'
      # set :views, File.dirname(__FILE__) + '/views'

      post '/upload' do
        puts 'upload received'
        # upload = Upload.new
        # upload.file = params[:file]
        # upload.save
        uploader = FileUploader.new
        uploader.store!(params[:file])
        puts uploader.url
      end
    end
  end  
end