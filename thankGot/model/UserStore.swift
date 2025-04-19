import SwiftUI

class UserStore: ObservableObject {
    @Published var currentUser: User? = nil  
    
    // 사용자 정보 업데이트 메서드
    func updateUser(with user: User) {
        self.currentUser = user
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
