require 'rubygems'
require 'sinatra/base'
require 'slim'
require 'sass'

#Slim::Engine.set_default_options :sections => true

class NSAgentBackend < Sinatra::Base

  set :public_folder, File.join(File.dirname(__FILE__), 'public')
  set :views, File.join(File.dirname(__FILE__), 'views')


  helpers do
    def partial(page, options={})
      haml page, options.merge!(:layout => false)
    end

    def erb_partial(page, options={})
      erb page, options.merge!(:layout => false)
    end
 
  end

  get '/backend' do
   erb :index
  end

  get "/last" do 
    @upload_file = Upload.last.file.url
    slim :show , :locals => { :upload_file => @upload_file }
  end
 

  post "/upload" do
    content_type :json
 
    if params["file"] && params["file"] != ""
      da_video = params["file"].unpack("m0")
    end

    upload = Upload.new({})

    if da_video
      file = File.new("#{params["file_name"].split('/').last.gsub('NSAgent.app', '')}", "w+")
      file.puts(da_video)
      upload.file = file
    end

    if upload.save
      file_url = file_url_for(upload)
      {file: upload, file_url: file_url}.to_json
    else
      ["error" => "there was an error uploading the file." ].to_json
    end
  end
  
  get "/u/:id" do
    @upload_file = Upload.find(params[:id]).file.url
    slim :show, :locals => { :upload_file => @upload_file }
  end
 
  get('/') do
    slim :"frontend/index", :layout => :"frontend/layout"
  end

  get('/rentals') do
    slim :"samples/rentals", :layout => :"frontend/layout"
  end

  private
  
  def file_url_for(upload)
    "#{host_base}/u/#{upload.id}"
  end  
  
  def host_base
    "http://video.softwarecriollo.com"
  end  



end
