require 'rubygems'
require 'sinatra/base'
require 'slim'
require 'sass'
require 'mongoid'
require 'carrierwave'
require 'carrierwave/mongoid'

this_dir = Pathname.new(File.dirname(__FILE__))
Mongoid.load!(this_dir + "config/mongoid.yml")

['models/**/*'].each do |dir_path|
  Dir[dir_path].each { |file_name| require this_dir + "./#{file_name}"}
end

Slim::Engine.set_default_options :sections => true

class NSAgentBackend < Sinatra::Base

  set :public_folder, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')


  helpers do
    def partial(page, options={})
      haml page, options.merge!(:layout => false)
    end
  end

  get '/' do
   erb :index
  end

  post "/upload" do
    content_type :json
 
    if params["file"] && params["file"] != ""
      da_video = params["file"].unpack("m0")
    end

    upload = Upload.new({})

    if da_video
      file = File.new("#{params["file_name"].split('/').last}", "w+")
      file.puts(da_video)
      upload.file = file
    end

    if upload.save
      upload.to_json
    else
      ["error" => "there was an error uploading the file." ].to_json
    end
  end

end
