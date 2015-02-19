require "sinatra"

class TestApp < Sinatra::Base
  get "/" do
    "HELLO"
  end
end