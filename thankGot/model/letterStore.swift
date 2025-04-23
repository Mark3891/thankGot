import Foundation
import FirebaseFirestore

class LetterStore: ObservableObject {
    @Published var letters: [Letter] = []
    
    private let db = Firestore.firestore()
    
    // MARK: - 보내기
    func sendLetter(letter: Letter, completion: @escaping (Error?) -> Void) {
        let data: [String: Any] = [
            "sentUser": letter.sentUser,
            "receiverUser": letter.receiverUser,
            "date": Timestamp(date: letter.date),
            "content": letter.content
        ]
        
        // 자동 문서 ID 생성 + 저장
        let docRef = db.collection("letters").document() // 여기서 문서 ID를 먼저 생성
        var newData = data
        newData["id"] = docRef.documentID // 문서 ID를 직접 포함
        
        docRef.setData(newData) { error in
            completion(error)
        }
    }
    
    // MARK: - 수정하기
    func updateLetter(_ letterID: String, newContent: String, completion: @escaping (Error?) -> Void = { _ in }) {
        
        let docRef = db.collection("letters").document(letterID)
        
        docRef.updateData([
            "content": newContent,
            
        ]) { error in
            if let error = error {
                print("❌ Error updating letter: \(error.localizedDescription)")
            } else {
                print("✅ Letter updated successfully.")
            }
            completion(error)
        }
    }
    
    
    // MARK: - 불러오기
    func fetchLetters(for nickname: String, completion: @escaping (Error?) -> Void = { _ in }) {
        db.collection("letters")
            .order(by: "date", descending: false)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    completion(error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(nil)
                    return
                }
                
                let fetchedLetters = documents.compactMap { doc -> Letter? in
                    let data = doc.data()
                    
                    guard let sentUser = data["sentUser"] as? String,
                          let receiverUser = data["receiverUser"] as? String,
                          let timestamp = data["date"] as? Timestamp,
                          let content = data["content"] as? String else {
                        return nil
                    }
                    
                    return Letter(
                        id: doc.documentID,
                        sentUser: sentUser,
                        receiverUser: receiverUser,
                        date: timestamp.dateValue(),
                        content: content
                    )
                }
                
                DispatchQueue.main.async {
                    self.letters = fetchedLetters
                    completion(nil)
                }
                
            }
    }
    
    
    
    
    
}
