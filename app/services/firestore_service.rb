require "google/cloud/firestore" 

class FirestoreService
    def self.firestore
      @firestore ||= Google::Cloud::Firestore.new
    end
  
    def self.col(collection_name)
      firestore.col(collection_name)
    end
end
  