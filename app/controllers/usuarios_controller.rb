class UsuariosController < ApplicationController
    def index
        users = []
        USERS_REF.get.each do |doc|
            users << doc.data.merge(id: doc.document_id)
        end
        render json: users
    rescue => e
        render json: { error: e.message }, status: :internal_server_error
    end

    def login
        email = params[:email]
        password = params[:password]
        if email.blank? || password.blank?
            render json: { error: "Faltan parametros" }, status: :bad_request
            return
        end

        begin
            user_ref = USERS_REF.where("email", "==", email).where("password", "==", password).get.first
            if user_ref.nil?
                render json: { error: "Usuario no encontrado" }, status: :not_found
            else
                render json: user_ref.data.merge(id: user_ref.document_id), status: :ok
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
end