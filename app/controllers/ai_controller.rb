require 'net/http'
require 'uri'
require 'json'

class AiController < ApplicationController
  def ask
    question = params[:question]
    if question.blank?
      render json: { error: "Debes enviar el parámetro 'question'" }, status: :bad_request
      return
    end

    api_key = ENV["GEMINI_API_KEY"]
    url = URI("https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=#{api_key}")

    headers = { 'Content-Type' => 'application/json' }
    body = {
      contents: [
        {
          parts: [
            { text: "Respondeme la siguiente pregunta en menos de 200 palabras: " + question + ". Solo quiero que me devuelvas texto y no le des formato" }
          ]
        }
      ]
    }.to_json

    begin
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(url, headers)
      request.body = body
      response = http.request(request)
      result = JSON.parse(response.body)

      # Extrae la respuesta del modelo Gemini
      answer = result.dig("candidates", 0, "content", "parts", 0, "text") || result

      render json: { answer: answer }
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end
end