import SwiftUI
import FirebaseAuth

struct sentPage: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore
    @State private var isShowingAddPage = false
    @State private var selectedYear: Int = Calendar.current.component(.year, from: Date())
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color.background.ignoresSafeArea()

            VStack(spacing: 20) {
                TopTitle(title: "Sent")

                HStack {
                    Button(action: {
                        withAnimation {
                            if selectedMonth == 1 {
                                selectedMonth = 12
                                selectedYear -= 1
                            } else {
                                selectedMonth -= 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    Text(String(format: "%d년 %d월", selectedYear, selectedMonth))
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)


                    Spacer()

                    Button(action: {
                        withAnimation {
                            if selectedMonth == 12 {
                                selectedMonth = 1
                                selectedYear += 1
                            } else {
                                selectedMonth += 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.right")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal)

                List {
                    if let nickname = userStore.currentUser?.nickname {
                        let calendar = Calendar.current
                        let sentLetters = letterStore.letters.filter {
                            let letterMonth = calendar.component(.month, from: $0.date)
                            let letterYear = calendar.component(.year, from: $0.date)
                            return letterMonth == selectedMonth &&
                                   letterYear == selectedYear &&
                                   $0.sentUser == nickname
                        }

                        if sentLetters.isEmpty {
                            Text("보낸 편지가 없습니다.")
                                .foregroundColor(.gray)
                                .listRowBackground(Color.clear)
                        } else {
                            ForEach(sentLetters.indices, id: \.self) { index in
                                VStack(spacing: 0) {
                                    sentLetterCard(letter: sentLetters[index])
                                        .padding(.vertical, 8)

                                    if index != sentLetters.indices.last {
                                        Divider().background(Color.white.opacity(0.3))
                                    }
                                }
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                            }
                        }
                    } else {
                        ProgressView("유저 정보 로딩 중...")
                            .progressViewStyle(CircularProgressViewStyle())
                            .foregroundColor(.gray)
                            .listRowBackground(Color.clear)
                    }
                }
                .listStyle(PlainListStyle())
                .scrollContentBackground(.hidden)
            }
            .padding(.horizontal)

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
        }
        .sheet(isPresented: $isShowingAddPage) {
            addPage()
                .environmentObject(userStore)
                .environmentObject(letterStore)
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
        }
    }
}
