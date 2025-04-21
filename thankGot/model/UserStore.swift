import FirebaseAuth
import FirebaseFirestore

class UserStore: ObservableObject {
    @Published var currentUser: User? = nil
    
    func updateUser(with user: User) {
        self.currentUser = user
    }

    func fetchCurrentUserIfLoggedIn() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("⚠️ 로그인된 유저 없음")
            return
        }

        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("🔥 유저 정보 불러오기 실패: \(error.localizedDescription)")
                return
            }

            guard let data = snapshot?.data() else {
                print("📭 문서 데이터 없음")
                return
            }

            // 파싱
            if let nickname = data["nickname"] as? String,
               let email = data["email"] as? String {
                self.currentUser = User(nickname: nickname, email: email, id: uid)
                print("✅ 유저 정보 로드 완료: \(nickname)")
            } else {
                print("⚠️ 필드 누락 또는 파싱 실패")
            }
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

class PreviewUserStore: UserStore {
    override init() {
        super.init()
        self.currentUser = User( nickname: "chang", email: "chang@test.com",id: "u1")
    }
}
