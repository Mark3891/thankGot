import Foundation
import FirebaseFirestore
import FirebaseCore


// Letter 모델
struct Letter: Identifiable, Codable {
    
    @DocumentID var id: String?  // Firebase 문서 ID 관련
    let sentUser: String
    let receiverUser: String
    let date: Date
    let content: String
}

// User 모델
struct User: Identifiable, Codable {
    let nickname: String
    let email: String
    var id: String
    
    init?(from data: [String: Any], id: String) {
        guard
            let nickname = data["nickname"] as? String,
            let email = data["email"] as? String
        else {
            return nil
        }
        
        self.nickname = nickname
        self.email = email
        self.id = id
    }
}
