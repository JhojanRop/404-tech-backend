class ProductosController < ApplicationController
    def index
        productos = Producto.all
        render json: productos
    end

    def show
        producto = Producto.find(params[:id])
        render json: producto
    end

    def create
        producto = Producto.create(
            title: params[:title],
            description: params[:description],
            category: params[:category],
            price: params[:price],
            discountPercentage: params[:discountPercentage],
            rating: params[:rating],
            stock: params[:stock],
            tags: params[:tags],
            thumbail: params[:thumbail]
        )
        render json: producto
    end

    def update
        producto = Producto.find(params[:id])
        producto.update(producto_params)
        render json: producto
    end

    def destroy
        producto = Producto.find(params[:id])
        producto.destroy
        render json: { message: 'Producto deleted' }
    end

    private

    def producto_params
        params.require(:producto).permit(:title, 
                                            :description, 
                                            :category, 
                                            :price, 
                                            :discountPercentage, 
                                            :rating, 
                                            :stock, 
                                            :tags, 
                                            :thumbail
                                        )
    end
end
