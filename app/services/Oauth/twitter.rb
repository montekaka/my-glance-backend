module Oauth
  class TwitterOauth
    def initialize(params)
      @callback = params[:callback]
      @app_key = params[:app_key]
      @app_secret = params[:app_secret]
    end
    # params = {callback: "http://localhost:9000/twitter_connection", app_key: app_key, app_secret: app_secret}
    # twitter_service = Sharebot::TwitterOauth.new(params)
    # twitter_service.get_request_token  
    
    def get_redirect_url
      # our front end will go to the callback url
      # and user will need to login from there

      # e.g.
      # https://api.twitter.com/oauth/authenticate?oauth_token=Bviz-wAAAAAAiEDZAAABdOLQn-s
      tokens = get_request_token
      oauth_token = tokens["oauth_token"]
      oauth_token_secret = tokens["oauth_token_secret"]

      callback_url = "https://api.twitter.com/oauth/authenticate?oauth_token=#{oauth_token}"

      return {
        "oauth_token": oauth_token,
        "url": callback_url,
        "oauth_token_secret": oauth_token_secret
      }

    end 
    
    def obtain_access_token(oauth_token, oauth_token_secret, oauth_verifier)
      tokens = get_access_token(oauth_token, oauth_token_secret, oauth_verifier)
    end

    private

    def get_access_token(oauth_token, oauth_token_secret, oauth_verifier)
      method = 'POST'
      uri = "https://api.twitter.com/oauth/access_token"
      url = URI(uri)
      oauth_timestamp = Time.now.getutc.to_i.to_s
      oauth_nonce = generate_nonce

      oauth_params = {
        'oauth_consumer_key' => @app_key, # Your consumer key
        'oauth_nonce' => oauth_nonce, # A random string, see below for function
        'oauth_signature_method' => 'HMAC-SHA1', # How you'll be signing (see later)
        'oauth_timestamp' => oauth_timestamp, # Timestamp
        'oauth_version' => '1.0', # oAuth version
        'oauth_verifier' => oauth_verifier,
        'oauth_token' => oauth_token
      }

      oauth_params['oauth_callback'] = url_encode(@callback+"\n")
      oauth_callback = oauth_params['oauth_callback']

      base_string = signature_base_string(method, uri, oauth_params)      
      oauth_signature = url_encode(sign(@app_secret + '&', base_string))
      
      authorization = "OAuth oauth_callback=\"#{oauth_callback}\", oauth_consumer_key=\"#{@app_key}\", oauth_nonce=\"#{oauth_nonce}\", oauth_signature=\"#{oauth_signature}\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"#{oauth_timestamp}\", oauth_token=\"#{oauth_token}\", oauth_verifier=\"#{oauth_verifier}\", oauth_version=\"1.0\""
      # authorization = 'OAuth oauth_callback="http%3A%2F%2Flocalhost%3A9000%2Ftwitter_connection%0A", oauth_consumer_key="QJImAUogu5MUalOP2Tv5jRt3X", oauth_nonce="a9900fe68e2573b27a37f10fbad6a755", oauth_signature="Y6y8dg4ENFXorvDPu7kyjrdbVYI%3D", oauth_signature_method="HMAC-SHA1", oauth_timestamp="1601796648", oauth_token="NPASDwAAAAAAiEDZAAABdOzo3sU", oauth_verifier="KiPMEx5rkceLjH1sCV3LfIVsxko0sBrc%0A", oauth_version="1.0"'

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(url)
      request["authorization"] = authorization

      response = http.request(request)

      parse_response_body(response)
    end
    
    def get_request_token
      # https://wiki.openstreetmap.org/wiki/OAuth_ruby_examples
      # http://www.drcoen.com/2011/12/oauth-1-0-in-ruby-without-a-gem/
      # http://www.drcoen.com/2011/12/oauth-with-the-twitter-api-in-ruby-on-rails-without-a-gem/

      method = 'POST'
      uri = "https://api.twitter.com/oauth/request_token"
      url = URI(uri)
      oauth_timestamp = Time.now.getutc.to_i.to_s
      oauth_nonce = generate_nonce

      oauth_params = {
        'oauth_consumer_key' => @app_key, # Your consumer key
        'oauth_nonce' => oauth_nonce, # A random string, see below for function
        'oauth_signature_method' => 'HMAC-SHA1', # How you'll be signing (see later)
        'oauth_timestamp' => oauth_timestamp, # Timestamp
        'oauth_version' => '1.0' # oAuth version
      }

      oauth_params['oauth_callback'] = url_encode(@callback+"\n")

      base_string = signature_base_string(method, uri, oauth_params)
      oauth_signature = url_encode(sign(@app_secret + '&', base_string))

      oauth_callback = oauth_params['oauth_callback']

      authorization = "OAuth oauth_callback=\"#{oauth_callback}\", oauth_consumer_key=\"#{@app_key}\", oauth_nonce=\"#{oauth_nonce}\", oauth_signature=\"#{oauth_signature}\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"#{oauth_timestamp}\", oauth_version=\"1.0\""
      puts authorization

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      request = Net::HTTP::Post.new(url)
      request["authorization"] = authorization
      response = http.request(request)

      parse_response_body(response)
      
    end

    def url_encode(string)
      CGI::escape(string)
    end
    
    def signature_base_string(method, uri, params)
      encoded_params = params.sort.collect{ |k, v| url_encode("#{k}=#{v}") }.join('%26')
      method + '&' + url_encode(uri) + '&' + encoded_params
    end

    def sign(key, base_string)
      digest = OpenSSL::Digest::Digest.new('sha1')
      hmac = OpenSSL::HMAC.digest(digest, key, base_string)
      Base64.encode64(hmac).chomp.gsub(/\n/, '')
    end

    def generate_nonce(size=7)
      Base64.encode64(OpenSSL::Random.random_bytes(size)).gsub(/\W/, '')
    end  
    
    def parse_response_body(response)
      ret = {}
      body = response.read_body
      body.split('&').each do |pair|
        key_and_val = pair.split('=')
        ret[key_and_val[0]] = key_and_val[1]
      end

      ret
    end
  end
end