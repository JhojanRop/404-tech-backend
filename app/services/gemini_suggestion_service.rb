require 'gemini-ai'

class GeminiSuggestionService
    attr_reader :client

    def initialize
        api_key = ENV['GEMINI_API_KEY']

        if api_key.blank?
            Rails.logger.error("Gemini API key is not set in the environment variables.")
            @client = nil
        else
            @client = Gemini::Client.new(api_key: api_key)
        end
    end

    def get_recommendations(prompt:, model: 'gemma-3-1b-it')
        return {  error: 'Gemini client is not initialized.' } if client.nil?

        begin
            response = client.generate_content(
                model: "models/#{model}",
                content: { role: "user", parts: { text: prompt } }
            )

            if response.candidates.any?
                suggestion_text = response.candidates.first.content.parts.first.text
                return { suggestion: suggestion_text }
            else
                Rails.logger.error("No candidates found in the response.")
                return { error: 'No suggestions available.' }
            end

        rescue StandardError => e
            Rails.logger.error("Error while fetching suggestions: #{e.message}")
            return { error: 'An error occurred while fetching suggestions.' }
        end
    end
end