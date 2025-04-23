import SwiftUI

struct LetterDetailView: View {
    let date: Date
    @Binding var isPresented: Bool
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore

    var body: some View {
        // 옵셔널을 빈 배열로 대체
        let letters = groupedLetters(
            for: date,
            letters: letterStore.letters,
            currentUserNickname: userStore.currentUser?.nickname
        ) ?? []

        ZStack {
            // 어두운 배경
            Color.black.opacity(0.6)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }

            // 카드형 팝업
            VStack(spacing: 20) {
                if letters.isEmpty {
                    ProgressView("편지를 불러오는 중입니다...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.5) // ProgressView 크기 증가
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    TabView {
                        ForEach(letters, id: \.id) { letter in
                            VStack(alignment: .leading, spacing: 16) {
                                // 수신자 이름과 제목
                                Text("Dear. \(letter.receiverUser)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)

                                ZStack(alignment: .topLeading) {
                                    
                                    
                                    // 편지 내용 텍스트
                                    Text(letter.content.isEmpty ? "입력된 편지가 없습니다." : letter.content)
                                        .font(.body)
                                        .foregroundColor(.white)
                                       
                                        .padding(.vertical, 16)
                                        .frame(maxWidth: .infinity,alignment: .topLeading)
                                        .lineSpacing(20)

                                    // 줄무늬
                                    VStack(alignment: .leading, spacing: 39) {
                                        ForEach(0..<10, id: \.self) { _ in
                                            Rectangle()
                                                .fill(Color.white)
                                                .frame(height: 1.5)
                                               
                                        }
                                    }
                                    .padding(.top, 38)
                                }

                                // 날짜 및 발신자 정보
                                VStack (alignment: .trailing, spacing: 8) {
                                    Text(formattedFullDate(letter.date))
                                        .font(.caption)
                                        .foregroundColor(.white.opacity(0.7))
                                  
                                    Text("From. \(letter.sentUser)")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(.white)
                                } // VStack
                                .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.horizontal, 16)
                            .background(Color.clear)
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                    } //tabview
                    .tabViewStyle(PageTabViewStyle())
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                }
            }
            .padding()
            .background(Color.letter)
            .cornerRadius(25)
            .frame(width: UIScreen.main.bounds.width * 0.9,
                   height: UIScreen.main.bounds.height * 0.7)
            .shadow(radius: 15) // 그림자 강도 약간 조정
            .transition(.scale)
            .onTapGesture {
                // 카드 내부 터치 시 닫히지 않도록
            }
        }
    }
}
