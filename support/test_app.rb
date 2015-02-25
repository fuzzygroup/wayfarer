require "sinatra"

class TestApp < Sinatra::Base

  set :public_folder, File.dirname(__FILE__) + "/static"

  get "/status_code/:code" do
    status params[:code]
  end

  get "/hello_world" do
    headers "hello" => "world"
    send_file read_static_file("hello_world.html")
  end

  get "/user_agent" do
    "Hello there, #{request.user_agent}!"
  end

  get "/redirect_loop" do
    redirect to "/redirect_loop"
  end

  get "/redirect" do
    n = params[:times].to_i
    n.zero? ? "You arrived!" : (redirect to "/redirect?times=#{n - 1}")
  end

  private
  def read_static_file(file_path)
    File.expand_path(file_path, settings.public_folder)
  end

end