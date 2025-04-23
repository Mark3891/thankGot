import SwiftUI
import FirebaseAuth

struct sentPage: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore
    @State private var isShowingAddPage = false
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
    
    var body: some View {
        ZStack (alignment: .bottomTrailing){
            Color.background.ignoresSafeArea()
            
            HStack {
                Spacer()
                
                VStack(alignment: .center ,spacing: 20) {
                    TopTitle(title: "Sent")
                    HStack {
                        Button(action: {
                            withAnimation {
                                selectedMonth = selectedMonth > 1 ? selectedMonth - 1 : 12
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                        
                        Text("\(selectedMonth)월")
                            .foregroundColor(.white)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation {
                                selectedMonth = selectedMonth < 12 ? selectedMonth + 1 : 1
                            }
                        }) {
                            Image(systemName: "chevron.right")
                                .font(.title)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    
                    List {
                        if let nickname = userStore.currentUser?.nickname {
                            let calendar = Calendar.current
                            let sentLetters = letterStore.letters.filter {
                                calendar.component(.month, from: $0.date) == selectedMonth &&
                                $0.sentUser == nickname
                            }
                            
                            ForEach(sentLetters.indices, id: \.self) { index in
                                VStack(spacing: 20) {
                                    sentLetterCard(letter: sentLetters[index])
                                        .padding(.vertical, 8)
                                        
                                    
                                    if index != sentLetters.indices.last {
                                        Divider().background(Color.white.opacity(0.3))
                                    }
                                }
                                .listRowBackground(Color.clear)
                            }
                        } else {
                            ProgressView("유저 정보 로딩 중...")
                                .progressViewStyle(CircularProgressViewStyle())
                                .foregroundColor(.gray)
                                .listRowBackground(Color.clear)
                        }
                    }
                    .listStyle(PlainListStyle())
                    .background(Color.clear) // List 전체 배경 투명하게
                    .scrollContentBackground(.hidden)
                    
                }
                .frame(width: UIScreen.main.bounds.width - 40)
                
                Spacer()
            } //: HStack
            
            // Floating Button
            Button(action: {
                isShowingAddPage = true
            }) {
                Image(systemName: "plus")
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.button)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            .padding()
            
            // Logout Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        userStore.logout { success in
                            if success {
                                print("➡️ 로그인 화면으로 전환할 수 있음")
                            }
                        }
                    }) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        } //: ZStack 마지막
        .sheet(isPresented: $isShowingAddPage) {
            addPage().environmentObject(letterStore)
        }
        .onAppear {
            userStore.fetchCurrentUserIfLoggedIn {
                if let nickname = userStore.currentUser?.nickname {
                    print("유저 편지 가져오는 중: \(nickname)")
                    letterStore.fetchLetters(for: nickname) { error in
                        if let error = error {
                            print("🔥 편지 불러오기 실패: \(error.localizedDescription)")
                        }
                    }
                }
            }
        }    }
}
