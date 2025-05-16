require 'google/cloud/firestore'

firestore = Google::Cloud::Firestore.new(
  project_id: ENV['FIREBASE_PROJECT_ID'],
  credentials: ENV['GOOGLE_APPLICATION_CREDENTIALS']
)

PRODUCTS_REF = firestore.col('Products')
CART_REF = firestore.col('Cart')
USER_REF = firestore.col('Users')