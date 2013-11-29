class Upload
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :file, NSAgentUploader
  
end