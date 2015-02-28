require "sinatra"

class TestApp < Sinatra::Base

  set :root, File.dirname(__FILE__)
  set :public_folder, -> { File.join(root, "static") }

  get "/status_code/:code" do
    status params[:code]
  end

  get "/hello_world" do
    headers "hello" => "world"
    "Hello world!"
  end

  get "/redirect_loop" do
    redirect to "/redirect_loop"
  end

  get "/redirect" do
    n = params[:times].to_i
    n.zero? ? "You arrived!" : (redirect to "/redirect?times=#{n - 1}")
  end

  get "/pagination" do
    n = params[:page].to_i
    send_file static_file("pagination/page_#{n}.html")
  end

  private
  def static_file(file_path)
    File.expand_path(file_path, settings.public_folder)
  end

end