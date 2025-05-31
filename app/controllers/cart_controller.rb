class CartController < ActionController::API
    def index
        cart = []
        CART_REF.get do |doc|
            cart << doc.data.merge(id: doc.document_id)
        end
        render json: cart
    rescue => e
        render json: { error: e.message }, status: :internal_server_error
    end

    def create
        cart_item = params[:cart_item]
        if cart_item.blank?
            render json: { error: "Faltan parametros" }, status: :bad_request
            return
        end

        # Limpia campos vacíos (hashes o arrays vacíos)
        cart_item = cart_item.reject { |_, v| v == {} || v == [] }

        # CONVIERTE A HASH PLANO
        cart_item = cart_item.to_unsafe_h if cart_item.respond_to?(:to_unsafe_h)

        Rails.logger.info "Producto a guardar en Firestore: #{cart_item.inspect}"

        begin
            CART_REF.add(cart_item)
            render json: { message: "Producto creado" }, status: :created
        rescue => e
            Rails.logger.error "Error al crear producto: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    def delete
        id = params[:id]
        if id.blank?
            render json: { error: "Faltan parametros" }, status: :bad_request
            return
        end

        begin
            cart_ref = CART_REF.document(id)
            cart_ref.delete
            render json: { message: "Producto eliminado" }, status: :ok
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    def remove_items
        ids = params[:ids]
        if ids.blank?
            render json: { error: "Faltan parametros" }, status: :bad_request
            return
        end

        begin
            ids.each do |id|
                cart_ref = CART_REF.document(id)
                cart_ref.delete
            end
            render json: { message: "Productos eliminados" }, status: :ok
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    def update
        id = params[:id]
        cart_item = params[:cart_item]
        if id.blank? || cart_item.blank?
            render json: { error: "Faltan parametros" }, status: :bad_request
            return
        end

        # Convierte a hash plano si es necesario
        cart_item = cart_item.to_unsafe_h if cart_item.respond_to?(:to_unsafe_h)

        begin
            cart_ref = CART_REF.document(id)
            cart_ref.update(cart_item)
            render json: { message: "Producto actualizado" }, status: :ok
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
end

class InteractiveRecommendationsController < ApplicationController
  def recommend
    # Recibe las respuestas del usuario desde el frontend
    user_responses = params[:responses]
    
    # Validación de parámetros
    unless user_responses.is_a?(Hash) && !user_responses.empty?
      return render json: { error: "Se requieren respuestas para generar recomendaciones" }, status: :bad_request
    end
    
    # Llama al servicio que procesará las respuestas y generará recomendaciones
    recommended_products = InteractiveRecommendationService.get_recommendations(user_responses)
    
    render json: { products: recommended_products }
  end
end

class InteractiveRecommendationService
  def self.get_recommendations(user_responses)
    # Inicializa el cliente de Gemini
    gemini_client = GeminiService.new
    
    # Formatea las respuestas del usuario para el prompt
    formatted_responses = format_user_responses(user_responses)
    
    # Construye el prompt para Gemini
    prompt = build_recommendation_prompt(formatted_responses)
    
    # Obtiene recomendaciones de Gemini
    recommendations = gemini_client.generate_product_recommendations(prompt)
    
    # Extrae los IDs de productos recomendados
    product_ids = parse_recommendations(recommendations)
    
    # Busca los productos recomendados en Firestore
    return find_products(product_ids)
  end
  
  private
  
  def self.format_user_responses(responses)
    # Formatea las respuestas del usuario para ser utilizadas en el prompt
    formatted = []
    
    responses.each do |question, answer|
      formatted << "Pregunta: #{question}\nRespuesta: #{answer}"
    end
    
    formatted.join("\n\n")
  end
  
  def self.build_recommendation_prompt(formatted_responses)
    <<~PROMPT
      Actúa como un asistente experto en tecnología para 404 TechStore.
      
      Basándote en las siguientes respuestas del usuario, recomienda 3-5 productos específicos
      que satisfagan sus necesidades. Solo recomienda productos que existan en nuestra base de datos.
      
      Respuestas del usuario:
      #{formatted_responses}
      
      Devuelve tu respuesta en el siguiente formato JSON:
      {
        "recommended_products": [
          {"id": "product_id_1", "reasoning": "Razón para recomendar este producto"},
          {"id": "product_id_2", "reasoning": "Razón para recomendar este producto"},
          ...
        ],
        "explanation": "Explicación general de las recomendaciones"
      }
    PROMPT
  end
  
  def self.parse_recommendations(recommendations)
    begin
      data = JSON.parse(recommendations)
      
      if data["recommended_products"] && data["recommended_products"].is_a?(Array)
        return data["recommended_products"].map { |product| product["id"] }
      end
    rescue JSON::ParserError => e
      Rails.logger.error("Error al parsear recomendaciones: #{e.message}")
    end
    
    # Fallback: busca IDs de productos en la respuesta utilizando regex
    product_ids = recommendations.scan(/product_id["']?\s*[:=]\s*["']([a-zA-Z0-9_-]+)["']/)
    product_ids.flatten.uniq
  end
  
  def self.find_products(product_ids)
    products = []
    
    product_ids.each do |id|
      product_doc = PRODUCTS_REF.doc(id).get
      if product_doc.exists?
        product_data = product_doc.data
        product_data[:id] = id
        products << product_data
      end
    end
    
    # Si no se encontraron productos específicos, devolver algunos productos populares
    if products.empty?
      popular_products = PRODUCTS_REF.order("popularity", "desc").limit(5).get
      popular_products.each do |doc|
        product_data = doc.data
        product_data[:id] = doc.document_id
        products << product_data
      end
    end
    
    products
  end
end

class GeminiService
  def initialize
    @api_key = Rails.application.credentials.dig(:gemini, :api_key)
    @base_url = Rails.application.credentials.dig(:gemini, :base_url)
  end

  def generate_product_recommendations(prompt)
    payload = {
      contents: [
        { role: "user", parts: [{ text: prompt }] }
      ],
      generationConfig: {
        temperature: 0.2,
        maxOutputTokens: 1500
      }
    }
    
    response = HTTP.auth("Bearer #{@api_key}")
                   .post(@base_url, json: payload)
    
    data = JSON.parse(response.body.to_s)
    data.dig("candidates", 0, "content", "parts", 0, "text") || "No se pudieron generar recomendaciones."
  end
end

post 'recommendations/interactive' => 'interactive_recommendations#recommend'