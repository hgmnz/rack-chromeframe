require 'rubygems'
require 'rack/test'
require 'test/unit'
require File.expand_path(File.dirname(__FILE__) + '/../chrome_frame')

# To run this test, you need to have rack-test gem installed: sudo gem install rack-test

class ChromeFrameTestOptionalPrompt < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    hello_world_app =  lambda {|env| [200, {'Content-Type' =>  'text/html', 'Content-Length' => '66'}, Rack::Response.new(["<html><head></head><body><form></form>Hello World!</body></html>"]) ] }
    app = Rack::ChromeFrame.new(hello_world_app, @options)
  end

  def test_no_prompt
    @options = { install_prompt: false }
    do_request

    assert_nil last_response.body.index(install_script)
  end

  def test_prompt
    @options = { install_prompt: true }
    do_request

    assert last_response.body.index(install_script)
  end

  def test_default_to_true
    @options = {}
    do_request

    assert last_response.body.index(install_script)
  end

  def do_request
    header "User-Agent", "MSIE"
    get '/'
    assert_equal 200, last_response.status
  end

  def install_script
    %{CFInstall.check({node: "cf-placeholder"})}
  end
end
