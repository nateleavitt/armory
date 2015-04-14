require "spec_helper"

RSpec.describe Armory do

  def app
    Armory # this defines the active application for this test
  end

  describe "hello world" do 
    authorize ENV['AUTH_USER'], ENV['AUTH_PASSWORD']
    get '/' do 
      expect(last_response.body).to eq("Hello World.. this is Armory")
      expect(last_response.status).to eq 200
    end
  end

end
