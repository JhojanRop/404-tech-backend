FROM ruby:3.2.4-slim-bookworm

# Instala dependencias del sistema y actualiza paquetes
RUN apt-get update -qq && apt-get install -y --no-install-recommends build-essential libpq-dev nodejs \
	&& apt-get upgrade -y \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Establece el directorio de trabajo
WORKDIR /app

# Copia el Gemfile y Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Instala las gemas
RUN bundle install

# Copia el resto del código
COPY . .

# Expone el puerto por defecto de Rails
EXPOSE 3000

# Comando para iniciar el servidor
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]