class UsuariosController < ApplicationController
    def index
        usuarios = Usuario.all
        render json: usuarios
    end

    def show
        usuario = Usuario.find(params[:id])
        render json: usuario
    end

    def login
        usuario = Usuario.find_by(email: params[:email])
        if usuario && usuario.authenticate(params[:password])
            render json: { message: 'Login successful', usuario: usuario }
        else
            render json: { message: 'Invalid email or password' }, status: :unauthorized
        end
    end

    def create
        usuario = Usuario.create(
            username: params[:username],
            email: params[:email],
            password: params[:password]
        )
        render json: usuario
    end

    def update
        usuario = Usuario.find(params[:id])
        usuario.update(usuario_params)
        render json: usuario
    end

    def destroy
        usuario = Usuario.find(params[:id])
        usuario.destroy
        render json: { message: 'Usuario deleted' }
    end

    private

    def usuario_params
        params.require(:usuario).permit(:username, :email, :password)
    end
end