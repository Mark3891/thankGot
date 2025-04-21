import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct SignUpView: View {
    @State private var nickname = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @FocusState private var isNicknameFocused: Bool
    @FocusState private var isPasswordFocused: Bool
    @FocusState private var isEmailFocused: Bool
    @AppStorage("userId") var userID = ""
    @EnvironmentObject var userStore: UserStore
    @Binding var selectedTab: cp_login.LoginTab
    
    
    var body: some View {
        VStack(spacing: 20) {
            
            VStack(spacing: 20){
                
                VStack(alignment: .leading, spacing:10){
                    Text("Email")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    
                    
                    TextField("", text: $email, prompt: Text("Email").foregroundColor(.gray))
                        .padding(10)
                        .background(Color.background)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .focused($isEmailFocused)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .autocorrectionDisabled(true)
                    
                    
                } //VStack
                
                VStack(alignment: .leading, spacing:10){
                    Text("NickName")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    TextField("", text: $nickname, prompt: Text("NickName").foregroundColor(.gray))
                        .padding(10)
                        .background(Color.background)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .focused($isNicknameFocused)
                    
                } //VStack
                
                
                VStack(alignment: .leading, spacing:10){
                    Text("PassWord")
                        .font(.system(size: 24))
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                    
                    SecureField("", text: $password, prompt: Text("Password").foregroundColor(.gray))
                        .padding(10)
                        .background(Color.background)
                        .cornerRadius(20)
                        .foregroundColor(.white)
                        .focused($isPasswordFocused)
                    
                } // VStack
                
            } // VStack
            .padding(.top,20)
            .padding(.bottom,20)
            
            
            
            
            Button {
                
                signUp()
               
                
            } label: {
                Text("Sign up")
                    .font(.system(size: 24,weight: .bold))
                
                
            }
            .padding(.vertical,5)
            .padding(.horizontal,30)
            .background(Color.button) // 배경화면
            .cornerRadius(20)
            .foregroundColor(Color.white) // 텍스트 색상
            
            
            
            
            
            if !errorMessage.isEmpty {
                Text(errorMessage).foregroundColor(.red)
            }
            
        }
        .padding()
        
    }
    
    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            if let uid = result?.user.uid {
                userID = uid
                
            }
            // Firestore에 nickname 저장
            let db = Firestore.firestore()
            db.collection("users").document(userID).setData([
                "nickname": nickname,
                "email": email,
                "id" : userID
            ]) { err in
                if let err = err {
                    errorMessage = "Firestore error: \(err.localizedDescription)"
                } else {
                    errorMessage = "Sign up successful!"
                    selectedTab = .login
                }
            }
        }
    } //sign up
}

#Preview {
    
    cp_login()
}
