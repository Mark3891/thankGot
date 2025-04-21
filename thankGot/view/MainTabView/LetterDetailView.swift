import SwiftUI

struct LetterDetailView: View {
    let date: Date
    @Binding var isPresented: Bool
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore

    var body: some View {
        let letters = groupedLetters(for: date)

        ZStack {
            // 어두운 배경
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }

            // 카드형 팝업
            VStack(spacing: 20) {
                if let letters = letters {
                    TabView {
                        ForEach(letters, id: \.id) { letter in
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Dear. \(letter.receiverUser)")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text(letter.content)
                                    .font(.body)
                                    .foregroundColor(.white)
                                    .lineSpacing(5)

                                HStack {
                                    Text(formattedFullDate(letter.date))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                    Spacer()
                                    Text("From. \(letter.sentUser)")
                                        .font(.caption)
                                        .foregroundColor(.white)
                                        .bold()
                                }
                            }
                            .padding()
                            .background(Color.letter)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    }
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                } else {
                    Text("편지를 불러오는 중입니다...")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(Color.clear)
            .cornerRadius(25)
            .frame(width: UIScreen.main.bounds.width*0.9, height: UIScreen.main.bounds.height*0.7 )
            .shadow(radius: 20)
            .transition(.scale)
            .onTapGesture {
                // 카드 내부 터치 시 닫히지 않도록
            }
        }
    }

    func formattedFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }

    func groupedLetters(for date: Date) -> [Letter]? {
        let calendar = Calendar.current
        return letterStore.letters.filter {
            calendar.startOfDay(for: $0.date) == date &&
            $0.receiverUser == userStore.currentUser?.nickname
        }
    }
}
