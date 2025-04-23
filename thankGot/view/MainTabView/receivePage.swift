import SwiftUI

struct receivePage: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore
    
    @State private var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    @State private var selectedDate: Date? = nil
    @State private var isShowingLetters = false
    @State private var isAlert = false
    
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
                                        isAlert = true
                                        
                                        
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
        .customAlert(
            isPresented: $isAlert,
            title: "아직 개봉할 수 없어요!",
            message: "이 편지는 설정된 날짜에 도착할 예정이에요.",
            confirmText: "확인",
            confirmTextColor: Color.button
        )
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
    
}

#Preview {
    receivePage()
        .environmentObject(UserStore())
        .environmentObject(LetterStore())
}



