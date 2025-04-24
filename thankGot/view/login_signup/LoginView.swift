import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct LoginView: View {
    @State private var nickname = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @FocusState private var isNicknameFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @AppStorage("userId") var userID = ""
    @EnvironmentObject var userStore: UserStore // @EnvironmentObject로 UserStore 접근
    
    var body: some View {
        
        VStack(spacing: 20) {
            VStack(spacing: 30) {
                // Nickname TextField
                VStack(alignment: .leading, spacing: 10) {
                    Text("Nickname")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    TextField("", text: $nickname, prompt: Text("Nickname").foregroundColor(Color.gray))
                        .padding(10)
                        .background(Color.background)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .focused($isNicknameFocused)
                }
                
                // Password SecureField
                VStack(alignment: .leading, spacing: 10) {
                    Text("Password")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    SecureField("", text: $password, prompt: Text("Password")
                        .foregroundColor(.gray)
                                
                    )
                    .padding(10)
                    .background(Color.background)
                    .cornerRadius(20)
                    .foregroundColor(.white)
                    .focused($isPasswordFocused)
                }
            }
            .padding(.vertical, 30)
            
            // Log In Button
            Button {
                loginWithNickname()
            } label: {
                Text("Log in")
                    .font(.system(size: 24))
                    .fontWeight(.bold)
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 30)
            .background(Color.button)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            
            // Error message
            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            }
        }
        .padding()
    }
    
    // 로그인 메서드
    
    
    func loginWithNickname() {
        let db = Firestore.firestore()
        db.collection("users")
            .whereField("nickname", isEqualTo: nickname)
            .getDocuments { snapshot, error in
                if let error = error {
                    errorMessage = "Firestore error: \(error.localizedDescription)"
                    return
                }
                
                guard let doc = snapshot?.documents.first,
                      let email = doc.data()["email"] as? String else {
                    errorMessage = "Nickname not found"
                    return
                }
                
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if let error = error {
                        errorMessage = error.localizedDescription
                    } else {
                        errorMessage = ""
                        isLoggedIn = true
                        if let uid = result?.user.uid {
                            userID = uid
                            
                            // Firestore에서 가져온 사용자 정보를 User 모델로 저장
                            let data = doc.data()
                            print(data)
                            if let user = User(from: data, id: uid) {
                                userStore.updateUser(with: user) // UserStore에 사용자 정보 업데이트
                                print(userStore.currentUser?.email ?? "email not found")
                                print(userStore.currentUser?.id ?? "id not found")
                                print(userStore.currentUser?.nickname ?? "nickname not found")
                            } else {
                                errorMessage = "Failed to parse user data"
                            }
                        }
                    }
                }
            }
    }
    
}

#Preview {
    LoginView()
}
