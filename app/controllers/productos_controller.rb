class ProductosController < ActionController::API
    def index
        products = []
        PRODUCTS_REF.get do |doc|
            products << doc.data.merge(id: doc.document_id)
        end
        render json: products
    rescue => e
        render json: { error: e.message }, status: :internal_server_error
    end

    def create
    product = params[:product]
    if product.blank?
        render json: { error: "Faltan parametros" }, status: :bad_request
        return
    end

    # Limpia campos vacíos (hashes o arrays vacíos)
    product = product.reject { |_, v| v == {} || v == [] }

    # CONVIERTE A HASH PLANO
    product = product.to_unsafe_h if product.respond_to?(:to_unsafe_h)

    Rails.logger.info "Producto a guardar en Firestore: #{product.inspect}"

    begin
        PRODUCTS_REF.add(product)
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
            product_ref = PRODUCTS_REF.document(id)
            product_ref.delete
            render json: { message: "Producto eliminado" }, status: :ok
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end

   def update
        id = params[:id]
        product = params[:product]
        if id.blank? || product.blank?
            render json: { error: "Faltan parametros" }, status: :bad_request
            return
        end

        # Convierte a hash plano si es necesario
        product = product.to_unsafe_h if product.respond_to?(:to_unsafe_h)

        begin
            product_ref = PRODUCTS_REF.document(id)
            product_ref.update(product)
            render json: { message: "Producto actualizado" }, status: :ok
        rescue => e
            Rails.logger.error "Error al actualizar producto: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    def filter_products
        category = params[:category]
        price = params[:price]

        # Aquí filtras tus productos según los parámetros recibidos
        # Ejemplo si usas Firestore:
        query = PRODUCTS_REF
        query = query.where("category", "array-contains", category) if category.present?
        query = query.where("price", "==", price.to_f) if price.present?

        products = []
        query.get.each do |doc|
            products << doc.data.merge(id: doc.document_id)
        end

        render json: products
    end
end
