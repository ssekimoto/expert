class User
    attr_accessor :id, :name, :email, :active
  
    def initialize(id:, name:, email:, active: true)
      @id = id
      @name = name
      @active = active
      @email = email
    end
  
    # Firestore からすべてのユーザーを取得
    def self.all
      FirebaseFirestore.col("users").get.map do |doc|
        data = doc.data
        new(id: doc.document_id, name: data[:name], email: data[:email], active: data[:active])
      end
    end
  
    # Firestore からアクティブなユーザーを取得
    def self.active
      FirebaseFirestore.col("users").where("active", "==", true).get.map do |doc|
        data = doc.data
        new(id: doc.document_id, name: data[:name], email: data[:email], active: data[:active])
      end
    end
  
    # Firestore にユーザーを保存
    def save!
      FirebaseFirestore.col("users").doc(id || SecureRandom.uuid).set({
        name: name,
        email: email,
        active: active,
        updated_at: Time.current
      }, merge: true)
    end
  
    # Firestore からユーザーを削除
    def delete
      FirebaseFirestore.col("users").doc(id).delete
    end
end
  
  