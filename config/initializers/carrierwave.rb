CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
 
  config.fog_credentials = {
    provider:              'AWS',
    aws_access_key_id:     ENV['AWS_APP_KEY'],
    aws_secret_access_key: ENV['AWS_APP_SECRET'],
    region:                'ap-southeast-1',
  }

  config.fog_directory  = ENV['AWS_BUCKET_NAME']                          
end