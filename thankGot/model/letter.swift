import Foundation
import FirebaseFirestore

struct Letter: Identifiable, Codable {
    @DocumentID var id: String?
    let sentUser: String
    let receiverUser: String
    let date: Date
    let content: String
}
