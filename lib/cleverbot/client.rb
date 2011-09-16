require 'cleverbot/parser'

module Cleverbot
  # Ruby wrapper for Cleverbot.com.
  class Client
    include HTTParty

    # The default form variables for POSTing to Cleverbot.com
    DEFAULT_PARAMS = {
      'stimulus' => '',
      'start' => 'y',
      'sessionid' => '',
      'vText8' => '',
      'vText7' => '',
      'vText6' => '',
      'vText5' => '',
      'vText4' => '',
      'vText3' => '',
      'vText2' => '',
      'icognoid' => 'wsf',
      'icognocheck' => '',
      'fno' => '0',
      'prevref' => '',
      'emotionaloutput' => '',
      'emotionalhistory' => '',
      'asbotname' => '',
      'ttsvoice' => '',
      'typing' => '',
      'lineref' => '',
      'sub' => 'Say',
      'islearning' => '1',
      'cleanslate' => 'false',
    }

    # The path to the form endpoint on Cleverbot.com.
    PATH = '/webservicemin'

    base_uri 'http://www.cleverbot.com'

    parser Parser

    # Creates a digest from the form parameters.
    #
    # ==== Parameters
    #
    # [<tt>body</tt>] <tt>String</tt> to be digested.
    def self.digest body
      Digest::MD5.hexdigest body[9...29]
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
  end
end
