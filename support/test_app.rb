require "sinatra"

class TestApp < Sinatra::Base

  set :public_folder, File.dirname(__FILE__) + "/static"

  get "/redirects/redirect_loop" do
    redirect to "/redirects/redirect_loop"
  end

end