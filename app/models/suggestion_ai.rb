class SuggestionAI
  def self.process(params)
    Rails.logger.info "PARAMS RECIBIDOS: #{params.inspect}"
    title = params[:title] rescue nil
    title ||= params.dig(:suggestion, :title) rescue nil
    title ||= "Producto"
    {
      suggestion: "¿Te gustaría conocer más productos similares a '#{title}'?",
      received: params
    }
  end
end