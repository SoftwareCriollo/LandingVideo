CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',                        # required
    :aws_access_key_id      => 'AKIAJBEHTPHY7TQS65ZA',                        # required
    :aws_secret_access_key  => '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'                        # required
  }
  config.fog_directory  = 'chalbaudvideos'                        # required
  config.fog_public     = false                                   # optional, defaults to true
  config.fog_attributes = {'Cache-Control'=>'max-age=315576000'}  # optional, defaults to {}
end

class NSAgentUploader < CarrierWave::Uploader::Base    #via a Carrierwave tutorial
  storage :fog
  
  def extensions_white_list
    %w(mov)
  end
end

class CarrierStringIO < StringIO
  def content_type
    "image/jpeg"
  end
end
class Upload
  include Mongoid::Document
  include Mongoid::Timestamps

  mount_uploader :file, NSAgentUploader
  
end
