import SwiftUI

struct myPage: View {
    
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(gradient: Gradient(colors: [.background]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack {
                
                TopTitle("My Page")
                // Profile section
                VStack(spacing: 16) {
                    // Profile picture or avatar (optional)
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white)
                    
                    Text("\(userStore.currentUser?.nickname ?? "누구세요")")
                        .font(.title)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    Text("\(userStore.currentUser?.email ?? "로그인 안됨")")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                    
                    Text("\(userStore.currentUser?.id ?? "누구세요")")
                        .font(.subheadline)
                        .foregroundStyle(.white)
                }
                .padding(.top, 40)
                
                Spacer()
                
                // Logout button with rounded edges
                Button(action: {
                    userStore.logout { success in
                        if success {
                            print("➡️ 로그인 화면으로 전환할 수 있음")
                        }
                    }
                }) {
                    Text("Logout")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                }
                .padding()
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    myPage()
}
