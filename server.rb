module Drive
  class Server < Sinatra::Base



    get("/") do
      render(:erb, :index, { :layout => :default_layout })
    end


  end
end
