import SwiftUI

struct receivePage: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore

    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedDate: Date? = nil
    @State private var isShowingLetters = false

    var body: some View {
        ZStack(alignment: .top) {
            Color.background.ignoresSafeArea()

            VStack(spacing: 20) {
                TopTitle(title: "Receive")
                    .padding(.top, 20)

                // 월 선택 뷰
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

                let calendar = Calendar.current
                let today = calendar.startOfDay(for: Date())

                // 월 필터링 + 닉네임 필터링
                let lettersThisMonth = letterStore.letters.filter {
                    calendar.component(.month, from: $0.date) == selectedMonth &&
                    $0.receiverUser == userStore.currentUser?.nickname
                }

                // 날짜별로 그룹화
                let groupedByDate = Dictionary(grouping: lettersThisMonth) { letter in
                    calendar.startOfDay(for: letter.date)
                }

                // 날짜 정렬
                let pastDates = groupedByDate.keys.filter { $0 < today }.sorted()
                let futureDates = groupedByDate.keys.filter { $0 >= today }.sorted()

              
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: 📬 오늘 이전
                        if !pastDates.isEmpty {
                            Text("📬 열려 있는 편지함")
                                .foregroundColor(.gray)
                                .font(.headline)
                                .padding(.horizontal)
                        ScrollView{
                           
                                
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                                    ForEach(pastDates, id: \.self) { date in
                                        cloverItem(date: date, count: groupedByDate[date]?.count ?? 0) {
                                            selectedDate = date
                                            isShowingLetters = true
                                        }
                                    }
                                }
                                .padding(.horizontal)
                                
                            Spacer()
                                
                                
                            } //Scrollview 오늘이전
                        }
                        if !futureDates.isEmpty {
                            Text("📅 개봉 예정 편지함")
                                .foregroundColor(.gray)
                                .font(.headline)
                                .padding(.horizontal)
                                .padding(.top)
                            
                            ScrollView{
                                // MARK: 📅 오늘 이후
                                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 3), spacing: 20) {
                                    ForEach(futureDates, id: \.self) { date in
                                        cloverItem(date: date, count: groupedByDate[date]?.count ?? 0) {
                                            selectedDate = date
                                            isShowingLetters = false
                                        }
                                    }
                                }
                                .padding(.horizontal)
                               
                                Spacer()
                                
                            }
                        }
                      
                    }
                
            }
        }
        .overlay {
            if let date = selectedDate, isShowingLetters {
                LetterDetailView(date: date, isPresented: $isShowingLetters)
                    .environmentObject(userStore)
                    .environmentObject(letterStore)
            }
        }
        .onAppear {
            if let nickname = userStore.currentUser?.nickname {
                letterStore.fetchLetters(for: nickname) { _ in
                    let calendar = Calendar.current
                    let today = calendar.startOfDay(for: Date())

                    let lettersThisMonth = letterStore.letters.filter {
                        calendar.component(.month, from: $0.date) == selectedMonth &&
                        $0.receiverUser == nickname
                    }

                    let groupedByDate = Dictionary(grouping: lettersThisMonth) { letter in
                        calendar.startOfDay(for: letter.date)
                    }

                    let pastDates = groupedByDate.keys.filter { $0 < today }.sorted()

                    if let firstPastDate = pastDates.first {
                        selectedDate = firstPastDate
                        isShowingLetters = false
                    }
                }
            }
        }


    }

    // 클로버 뷰 컴포넌트
    func cloverItem(date: Date, count: Int, action: @escaping () -> Void) -> some View {
        ZStack {
            VStack(spacing: 4) {
                Image("clover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .onTapGesture { action() }

                Text(formattedDay(date))
                    .font(.caption)
                    .foregroundColor(.white)
            }

            if count > 0 {
                Text("\(count)")
                    .font(.caption2)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.background)
                    .clipShape(Circle())
                    .offset(x: 20, y: -20)
            }
        }
    }



    // 날짜 → "d일" (clover 아래 표시용)
    func formattedDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d일"
        return formatter.string(from: date)
    }

}

#Preview {
    receivePage()
        .environmentObject(UserStore())
        .environmentObject(LetterStore())
}
