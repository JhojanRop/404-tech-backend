# Test Store

## Descripción

Este repositorio contiene el código fuente para Test Store, una aplicación [breve descripción de la aplicación].

## Requisitos previos

- Ruby (versión 3.0.0 o superior)
- Rails (versión 7.0 o superior)
- PostgreSQL (o la base de datos que utilices)
- Bundler

## Instalación

1. Clona este repositorio:

```bash
git clone https://github.com/usuario/test-store.git
cd test-store
```

2. Instala las dependencias:

```bash
bundle install
```

3. Configura la base de datos:

```bash
rails db:create
rails db:migrate
rails db:seed # si es necesario
```

4. Configura las variables de entorno:
    - Copia el archivo `.env.example` a `.env`
    - Actualiza las variables según tu entorno local

## Ejecución

Para iniciar la aplicación en modo desarrollo:

```bash
rails server
# o forma abreviada
rails s
```

La aplicación estará disponible en `http://localhost:3000`.

## Estructura del proyecto

```plainttext
test-store/
├── app/            # Lógica principal de la aplicación
│   ├── controllers/ # Controladores
│   ├── models/     # Modelos
│   ├── views/      # Vistas
│   ├── assets/     # JavaScript, CSS e imágenes
│   └── ...
├── config/         # Configuración de la aplicación
├── db/             # Migraciones y seeds
├── public/         # Archivos estáticos
├── .env.example    # Plantilla para variables de entorno
├── Gemfile         # Dependencias
└── README.md       # Esta documentación
```

## Scripts disponibles

- `rails server`: Inicia el servidor de desarrollo
- `rails test`: Ejecuta las pruebas
- `rails db:migrate`: Ejecuta las migraciones pendientes
- `rails console`: Abre la consola de Rails

## Contribuir

1. Haz fork del repositorio
2. Crea una rama para tu funcionalidad (`git checkout -b feature/amazing-feature`)
3. Haz commit de tus cambios (`git commit -m 'Add some amazing feature'`)
4. Empuja a la rama (`git push origin feature/amazing-feature`)
5. Abre un Pull Request

## Licencia

MIT

---

**Nota:** Este README es una plantilla. Por favor, personaliza cada sección con la información específica de tu proyecto.
