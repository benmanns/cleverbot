require 'httparty'

module Cleverbot
  # Used in Client to parse responses from Cleverbot.com.
  class Parser < HTTParty::Parser
    # Keys that correspond to the <tt>Array</tt> that Cleverbot.com returns.
    # They are combined with the <tt>Array</tt> to form a response <tt>Hash</tt>.
    KEYS = [
      'message',
      'sessionid',
      'logurl',
      'vText8',
      'vText7',
      'vText6',
      'vText5',
      'vText4',
      'vText3',
      'vText2',
      'prevref',
      nil,
      'emotionalhistory',
      'ttsLocMP3',
      'ttsLocTXT',
      'ttsLocTXT3',
      'ttsText',
      'lineref',
      'lineURL',
      'linePOST',
      'lineChoices',
      'lineChoicesAbbrev',
      'typingData',
      'divert',
    ]

    # Formats supported by the parser.
    # Parser handles <tt>text/html</tt> responses only with #html.
    SupportedFormats = { 'text/html' => :html }

    # Splits the body on <tt>"\\r"</tt> and zips the result with KEYS, which is then formed into a <tt>Hash</tt>.
    def html
      Hash[KEYS.zip(body.split("\r"))]
    end
  end
end
