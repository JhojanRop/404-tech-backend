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
end