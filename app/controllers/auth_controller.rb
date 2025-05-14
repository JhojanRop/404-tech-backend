require 'net/http'
require 'uri'
require 'json'

class AuthController < ActionController::API
  before_action :authenticate_user, only: [:protected]

  def public
    render json: { message: "Esta ruta es publica" }
  end

  def protected
    render json: {
      message: "Acceso permitido",
      user: @current_user
    }
  end

  def register 
    email = params[:email]
    password = params[:password]

    if email.blank? || password.blank?
      render json: { error: "Faltan parametros" }
      return
    end

    api_key = ENV["FIREBASE_API_KEY"]
    url = URI("https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=#{api_key}")

    body = {
      email: email,
      password: password,
      returnSecureToken: true
    }.to_json

    headers = { 'Content-Type' => 'application/json' }

    begin
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(url, headers)
      request.body = body
      response = http.request(request)
      result = JSON.parse(response.body)

      if result["error"]
        render json: { error: result["error"]["message"] }, status: :unprocessable_entity
      else
        render json: { message: "Usuario creado", firebase: result }
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def login
    email = params[:email]
    password = params[:password]

    if email.blank? || password.blank?
        render json: { error: "Faltan parametros" }
        return
    end

    api_key = ENV["FIREBASE_API_KEY"]
    url = URI("https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=#{api_key}")

    body = {
      email: email,
      password: password,
      returnSecureToken: true
    }.to_json

    headers = { 'Content-Type' => 'application/json' }

    begin
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        request = Net::HTTP::Post.new(url, headers)
        request.body = body
        response = http.request(request)
        result = JSON.parse(response.body)
        if result["error"]
            render json: { error: result["error"]["message"] }, status: :unprocessable_entity
        else
            render json: { message: "Usuario logueado", firebase: result }
        end
    rescue => e
        render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

end
