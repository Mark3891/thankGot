import FirebaseAuth
import FirebaseFirestore
import Foundation

class UserStore: ObservableObject {
    @Published var currentUser: User? = nil
    
    func updateUser(with user: User) {
        self.currentUser = user
    }

    func fetchCurrentUserIfLoggedIn(completion: @escaping () -> Void = {}) {
           guard let uid = Auth.auth().currentUser?.uid else {
               print("⚠️ 로그인된 유저 없음")
               completion()
               return
           }

           let db = Firestore.firestore()
           db.collection("users").document(uid).getDocument { snapshot, error in
               if let error = error {
                   print("🔥 유저 정보 불러오기 실패: \(error.localizedDescription)")
                   completion()
                   return
               }

               guard let data = snapshot?.data() else {
                   print("📭 문서 데이터 없음")
                   completion()
                   return
               }

               if let user = User(from: data, id: uid) {
                   self.currentUser = user
                   print("✅ 유저 정보 로드 완료: \(user.nickname)")
               } else {
                   print("⚠️ 필드 누락 또는 파싱 실패")
               }

               completion()
           }
       }
    
  

    
    func fetchUser(uid: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let doc = snapshot, let data = doc.data() {
                if let user = User(from: data, id: uid) {
                    self.currentUser = user
                    completion(true)
                } else {
                    completion(false)
                }
            } else {
                completion(false)
            }
        }
    }
    func logout(completion: @escaping (Bool) -> Void = { _ in }) {
           do {
               try Auth.auth().signOut()
               self.currentUser = nil
               UserDefaults.standard.set(false, forKey: "isLoggedIn")
               print("👋 로그아웃 완료")
               completion(true)
           } catch let signOutError as NSError {
               print("🚫 로그아웃 실패: \(signOutError.localizedDescription)")
               completion(false)
           }
       }
    
  
}


let dummyUsers: [String] = [
    "Mosae", "Heggy", "HappyJay", "Gus", "Chloe", "Gigi", "Hidy", "Wonjun", "Henry", "Kirby",
    "Avery", "Ell", "GO", "Snow", "Angie", "Brandnew", "Yuu", "Martin", "Three", "Elena",
    "Noter", "Elian", "Sana", "Ito", "KON", "Zhen", "min", "Elphie", "Noah", "Fine",
    "Moo", "Judyj", "simi", "Murphy", "Kave", "Junia", "J", "Ella", "Ken", "ssol",
    "Finn", "Steve", "Jam", "Leo", "Cherry", "gabi", "Ethan", "Jaeryong", "Taeni", "Way",
    "Sera", "RIA", "Woody", "Glowny", "Jun", "Mini", "Ted", "Jomi", "Wade", "Bin",
    "Sky", "Echo", "Dodin", "JIN", "Berry", "kwangro", "Joy", "Wish", "Baba", "Air",
    "Frank", "Hyun", "Mingky", "Viera", "Evan", "Nyx", "Hama", "Demian", "Yeony", "OneThing",
    "Cheshire", "Pherd", "May", "Jenki", "Sena", "Dean", "Friday", "Bear", "Nika", "Yan",
    "Nike"
]


