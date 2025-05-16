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