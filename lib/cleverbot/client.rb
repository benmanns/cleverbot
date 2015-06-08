require 'cleverbot/parser'

module Cleverbot
  # Ruby wrapper for Cleverbot.com.
  class Client
    include HTTParty

    # The default form variables for POSTing to Cleverbot.com
    DEFAULT_PARAMS = {
      'stimulus' => '',
      'vText2' => '',
      'vText3' => '',
      'vText4' => '',
      'vText5' => '',
      'vText6' => '',
      'vText7' => '',
      'vText8' => '',
      'sessionid' => '',
      'cb_settings_language' => 'en',
      'cb_settings_scripting' => 'no',
      'islearning' => '1',
      'icognoid' => 'wsf',
      'icognocheck' => '',
    }

    # The path to the form endpoint on Cleverbot.com.
    PATH = '/webservicemin'

    base_uri 'http://www.cleverbot.com'

    parser Parser
    headers 'Accept-Encoding' => 'gzip'

    # Holds the parameters for an instantiated Client.
    attr_reader :params

    # Creates a digest from the form parameters.
    #
    # ==== Parameters
    #
    # [<tt>body</tt>] <tt>String</tt> to be digested.
    def self.digest body
      Digest::MD5.hexdigest body[9...35]
    end

    # Sends a message to Cleverbot.com and returns a <tt>Hash</tt> containing the parameters received.
    #
    # ==== Parameters
    #
    # [<tt>message</tt>] Optional <tt>String</tt> holding the message to be sent. Defaults to <tt>''</tt>.
    # [<tt>params</tt>] Optional <tt>Hash</tt> with form parameters. Merged with DEFAULT_PARAMS. Defaults to <tt>{}</tt>.
    def self.write message='', params={}
      body = DEFAULT_PARAMS.merge params
      body['stimulus'] = message
      body['icognocheck'] = digest HashConversions.to_params(body)

      post(PATH, :body => body).parsed_response
    end

    # Initializes a Client with given parameters.
    #
    # ==== Parameters
    #
    # [<tt>params</tt>] Optional <tt>Hash</tt> holding the initial parameters. Defaults to <tt>{}</tt>.
    def initialize params={}
      @params = params
    end

    # Sends a message and returns a <tt>String</tt> with the message received. Updates #params to maintain state.
    #
    # ==== Parameters
    #
    # [<tt>message</tt>] Optional <tt>String</tt> holding the message to be sent. Defaults to <tt>''</tt>.
    def write message=''
      response = self.class.write message, @params
      message = response['message']
      response.keep_if { |key, value| DEFAULT_PARAMS.keys.include? key }
      @params.merge! response
      @params.delete_if { |key, value| DEFAULT_PARAMS[key] == value }
      message
    end
  end
end
