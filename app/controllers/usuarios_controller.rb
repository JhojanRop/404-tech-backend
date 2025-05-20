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

    def register
        email = params[:email]
        password = params[:password]
        fullname = params[:fullname]
        role = params[:role]
        username = params[:username]
        id = params[:id]

        if email.blank? || password.blank? || fullname.blank? || role.blank? || username.blank?
            render json: { error: "Faltan parametros" }, status: :bad_request
            return
        end

        new_user = {
            email: email,
            password: password,
            fullname: fullname,
            role: role,
            username: username
        }

        new_user = new_user.reject { |_, v| v == {} || v == [] }
        new_user = new_user.to_unsafe_h if new_user.respond_to?(:to_unsafe_h)

        Rails.logger.info "Usuario a guardar en Firestore: #{new_user.inspect}"

        begin
            if id.present?
                user_ref = USER_REF.document(id)
                user_ref.set(new_user)
                render json: { message: "Usuario actualizado" }, status: :ok
            else
                USER_REF.add(new_user)
                render json: { message: "Usuario creado" }, status: :created
            end
        rescue => e
            Rails.logger.error "Error al crear usuario: #{e.message}"
            Rails.logger.error e.backtrace.join("\n")
            render json: { error: e.message }, status: :internal_server_error
        end
    end

    def login
        email = params[:email]
        password = params[:password]
        if email.blank? || password.blank?
            render json: { error: "Faltan parametros" }, status: :bad_request
            return
        end

        begin
            user_ref = USER_REF.where("email", "==", email).where("password", "==", password).get.first
            if user_ref.nil?
                render json: { error: "Usuario no encontrado" }, status: :not_found
            else
                user_data = user_ref.data.merge(id: user_ref.document_id)
                payload = { user_id: user_data[:id], email: user_data[:email], exp: 24.hours.from_now.to_i }
                secret = Rails.application.secret_key_base || ENV['SECRET_KEY_BASE']
                token = JWT.encode(payload, secret, 'HS256')
                render json: { user: user_data, token: token }, status: :ok
            end
        rescue => e
            render json: { error: e.message }, status: :internal_server_error
        end
    end
end