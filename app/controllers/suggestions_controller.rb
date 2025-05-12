class SuggestionsController < ApplicationController
  def index
    begin
      if defined?(SuggestionAI)
        result = SuggestionAI.process(params)
        render json: result
      else
        render json: { error: "SuggestionAI no está definido" }, status: :internal_server_error
      end
    rescue => e
      render json: { error: e.message, backtrace: e.backtrace }, status: :internal_server_error
    end
  end

  def show
    begin
      if defined?(SuggestionAI)
        result = SuggestionAI.process(params)
        render json: result
      else
        render json: { error: "SuggestionAI no está definido" }, status: :internal_server_error
      end
    rescue => e
      render json: { error: e.message, backtrace: e.backtrace }, status: :internal_server_error
    end
  end
end