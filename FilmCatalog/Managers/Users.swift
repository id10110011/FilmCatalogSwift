import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserInfo {
    let email: String
    var firstname: String = ""
    var lastname: String = ""
    var city: String = ""
    var country: String = ""
    var education: String = ""
    var dateOfBirth: String = ""
    var gender: String = ""
    var description: String = ""
}

class UsersManager {
    static let shared = UsersManager()
    private init() {}
    
    func createUser(data: UserAuthData) async throws {
        let userData = [
            "email": data.email,
        ]
        try await Firestore.firestore().collection("users").document(data.id).setData(userData)
    }
    
    func getUser(email: String) async throws -> UserInfo? {
        let snapshot = try await Firestore.firestore().collection("users").document(email).getDocument()
        
        guard let data = snapshot.data() else {
            return nil
        }
        
        return UserInfo(
            email: data["email"] as! String,
            firstname: data["firstname"] as? String ?? "",
            lastname: data["lastname"] as? String ?? "",
            city: data["city"] as? String ?? "",
            country: data["country"] as? String ?? "",
            education: data["education"] as? String ?? "",
            dateOfBirth: data["dateOfBirth"] as? String ?? "",
            gender: data["gender"] as? String ?? "",
            description: data["description"] as? String ?? ""
        )
    }
    
    func updateUser(data: UserInfo) async throws -> UserInfo? {
        var userData: [String: Any] = [:]
        let mirror = Mirror(reflecting: data)
        for child in mirror.children {
            if let label = child.label {
                userData[label] = child.value
            }
        }
        try await Firestore.firestore().collection("users").document(data.email).updateData(userData)
        return try await getUser(email: data.email)
    }
    
    func deleteUserDB(email: String) async throws {
        try await Firestore.firestore().collection("users").document(email).delete()
    }
}
