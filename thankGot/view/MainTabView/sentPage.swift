import SwiftUI

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
                    
                    ScrollView {
                        LazyVStack(spacing: 40) {
                            if let nickname = userStore.currentUser?.nickname {
                                let calendar = Calendar.current
                                let sentLetters = letterStore.letters.filter {
                                    calendar.component(.month, from: $0.date) == selectedMonth &&
                                    $0.sentUser == nickname }

                                ForEach(sentLetters, id: \.id) { letter in
                                    SwipeableLetterCard(letter: letter) {
                                        print("Edit tapped")
                                    }
                                }
                            } else {
                                Text("로그인된 유저 정보가 없습니다.")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.horizontal)
                    }

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
        } //: ZStack 마지막
        .sheet(isPresented: $isShowingAddPage) {
            addPage().environmentObject(letterStore)
        }
        .onAppear {
            if let nickname = userStore.currentUser?.nickname {
                letterStore.fetchLetters(for: nickname) { error in
                    if let error = error {
                        print("🔥 편지 불러오기 실패: \(error.localizedDescription)")
                    } else {
                        print("✅ 보낸 편지 불러오기 성공")
                    }
                }
            }
            
            
            
        }
    }
    
    
}
