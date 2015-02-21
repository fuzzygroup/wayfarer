require "sinatra"

class TestApp < Sinatra::Base

  set :public_folder, File.dirname(__FILE__) + "/static"

  get "/redirects/redirect_loop" do
    redirect to "/redirects/redirect_loop"
  end

  get "/pagination/by_param" do
    file = case params[:page].to_i
           when 1
             read_static_file("pagination/page_1.html")
           when 2
             read_static_file("pagination/page_2.html")
           when 3
             read_static_file("pagination/page_3.html")
           end
    send_file(file)
  end

  private
  def read_static_file(file_path)
    File.expand_path(file_path, settings.public_folder)
  end

end