require 'firebase_id_token'

FirebaseIdToken.configure do |config|
    config.project_ids = [ENV['FIREBASE_PROJECT_ID']] # Replace with your Firebase project ID
end