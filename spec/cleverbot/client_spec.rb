require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Cleverbot::Client do
  subject { Cleverbot::Client }

  it { should <= HTTParty }

  describe '::DEFAULT_PARAMS' do
    subject { Cleverbot::Client::DEFAULT_PARAMS }

    it do
      should == {
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
    end
  end

  describe '::PATH' do
    subject { Cleverbot::Client::PATH }

    it { should == '/webservicemin' }
  end

  describe '.base_uri' do
    subject { Cleverbot::Client.base_uri }

    it { should == 'http://www.cleverbot.com' }
  end

  describe '.parser' do
    subject { Cleverbot::Client.parser }

    it { should == Cleverbot::Parser }
  end

  describe '.digest' do
    subject { Cleverbot::Client.digest @body }
    context 'given a body of 0123456789abcdefghijklmnopqrstuvwxyz' do
      before :each do
        @body = '0123456789abcdefghijklmnopqrstuvwxyz-truncateme'
      end

      it 'should call Digest::MD5.hexdigest with 9abcdefghijklmnopqrstuvwxyz' do
        Digest::MD5.should_receive(:hexdigest).with @body[9..34]
        subject
      end

      context 'when Digest::MD5.hexdigest returns abcd' do
        before :each do
          Digest::MD5.stub(:hexdigest).and_return 'abcd'
        end

        it { should == 'abcd' }
      end
    end
  end

  describe '.write' do
    subject { Cleverbot::Client.write @message, @params }

    context 'with params {}' do
      before :each do
        @params = {}
      end

      context 'with an empty message' do
        before :each do
          @message = ''
        end

        it 'should post to PATH' do
          Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, hash_including).and_return double(:parsed_response => {})
          subject
        end

        Cleverbot::Client::DEFAULT_PARAMS.each do |key, value|
          next if ['stimulus', 'icognocheck'].include? key
          it "should add #{key} => #{value.inspect} to the post body" do
            Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, :body => hash_including(key => value)).and_return double(:parsed_response => {})
            subject
          end
        end

        it 'should add stimulus => "" to the post body' do
          Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, :body => hash_including('stimulus' => '')).and_return double(:parsed_response => {})
          subject
        end

        context 'when digest returns abcd' do
          before :each do
            Digest::MD5.stub(:hexdigest).and_return 'abcd'
          end

          it 'should add icognocheck => "abcd" to the post body' do
            Cleverbot::Client.should_receive(:post).with(Cleverbot::Client::PATH, :body => hash_including('icognocheck' => 'abcd')).and_return double(:parsed_response => {})
            subject
          end
        end

        context 'when the parsed response is {}' do
          before :each do
            Cleverbot::Client.stub(:post).and_return double(:parsed_response => {})
          end

          it { should == {} }
        end
      end
    end
  end

  describe '#initialize' do
    subject { Cleverbot::Client.new @params }

    context 'with params { "a" => "b" }' do
      before :each do
        @params = { 'a' => 'b' }
      end

      it 'sets #params to { "a" => "b" }' do
        subject.params.should == { 'a' => 'b' }
      end
    end
  end

  describe '#write' do
    before :each do
      @client = Cleverbot::Client.new
    end

    subject { @client.write @message }

    context 'with an empty message' do
      before :each do
        @message = ''
      end

      it 'should call .write with "" and #params' do
        Cleverbot::Client.should_receive(:write).with(@message, @client.params).and_return({})
        subject
      end

      context 'when .write returns { "message" => "Hi.", "sessionid" => "abcd" }' do
        before :each do
          Cleverbot::Client.stub(:write).and_return 'message' => 'Hi.', 'sessionid' => 'abcd'
        end

        it 'should set #params[sessionid] to abcd' do
          subject
          @client.params['sessionid'].should == 'abcd'
        end

        it 'should not set #params[message] to Hi.' do
          subject
          @client.params['message'].should_not == 'abcd'
        end
      end
    end
  end
end
