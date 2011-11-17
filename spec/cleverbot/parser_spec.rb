require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cleverbot::Parser do
  subject { Cleverbot::Parser }

  it { should <= HTTParty::Parser }

  it('should support format :html') { should be_supports_format :html }

  describe '::KEYS' do
    subject { Cleverbot::Parser::KEYS }

    it do
      should == [
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
    end
  end

  describe '#call' do
    subject { Cleverbot::Parser.call @body, @format }

    context 'with a format of :html' do
      before :each do
        @format = :html
      end

      context 'with an empty body' do
        before :each do
          @body = ''
        end

        it { should be_nil }
      end

      context 'with an body of 0\r1\r2' do
        before :each do
          @body = (0..2).to_a.join "\r"
        end

        (0..2).each do |key|
          it { should include({ Cleverbot::Parser::KEYS[key] => key.to_s }) }
        end
        (3..(Cleverbot::Parser::KEYS.length - 1)).each do |key|
          it { should include({ Cleverbot::Parser::KEYS[key] => nil }) }
        end
      end

      context 'with a body of length greater than KEYS.length' do
        before :each do
          @body = (0..Cleverbot::Parser::KEYS.length).to_a.join "\r"
        end

        (0..(Cleverbot::Parser::KEYS.length - 1)).each do |key|
          it { should include({ Cleverbot::Parser::KEYS[key] => key.to_s }) }
        end
        it { should_not have_key Cleverbot::Parser::KEYS.length }
      end
    end
  end
end
