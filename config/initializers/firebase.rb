require 'google/cloud/firestore'
require 'jwt'

SECRET_KEY = Rails.application.credentials.secret_key_base || ENV['SECRET_KEY_BASE']

firestore = Google::Cloud::Firestore.new(
  project_id: ENV['FIREBASE_PROJECT_ID'],
  credentials: ENV['GOOGLE_APPLICATION_CREDENTIALS']
)

PRODUCTS_REF = firestore.col('Products')
USERS_REF = firestore.col('Users')
