class ApplicationController < ActionController::API

  def index
    if request.headers['Authorization']
      token = request.headers['Authorization'].split(" ")[1]
      render json: {
        data: verify_token(token)[0]
      }
    else
      display
    end
  end

  def app_login
    is_logged_in = login(name: params[:name], email: params[:email])
    if is_logged_in
      display(token: create_token, name:params[:name], email: params[:email], status: "authorized", status_code: 200)
    else
      display
    end
  end



  private

  def display(name: nil, email:nil, status:"unauthorized", status_code: 401, token: nil)
    render json: {
      name: name,
      email: email,
      status: status,
      token: token
    }, status: status_code
  end

  def login(name: nil, email: nil)
    email == "sample@mail.com" && name == "sample"
  end

  def create_token
    expiry = Time.now.to_i + 3000
    number = rand(max = 100)
    data = {
      "expiry": expiry,
      "lucky_number": number
    }
    JWT.encode(data, "mbogo", 'HS256')
  end

  def verify_token(token)
   JWT.decode(token, "mbogo", true, {'algorithm':'HS256'})
  end


end
