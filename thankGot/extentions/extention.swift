import SwiftUI




extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
    
    func TopTitle(_ title: String) -> some View {
            ZStack {
                Image("wood")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width - 40, height: 80)
                    .cornerRadius(15)

                // Stroke 텍스트
                Text(title)
                    .font(Font.custom("WoodyWood", size: 60))
                    .foregroundColor(.clear)
                    .overlay(
                        Text(title)
                            .font(Font.custom("WoodyWood", size: 60))
                            .foregroundColor(.black)
                            .offset(x: 1, y: 1)
                            .opacity(0.4)
                    )

                // 본문 텍스트
                Text(title)
                    .font(Font.custom("WoodyWood", size: 60))
                    .foregroundColor(.black)
            }
            .padding(.top, 20)
        }
        
    
    
    func customAlert(isPresented: Binding<Bool>,
                     title: String,
                     message: String,
                     confirmText: String = "확인",
                     confirmTextColor: Color = .button,
                     backgroundColor: Color = Color.backAdd,
                     action: (() -> Void)? = nil) -> some View {
        
        ZStack {
            self
            
            if isPresented.wrappedValue {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.white)
                    
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                    
                    Button(action: {
                        withAnimation {
                            isPresented.wrappedValue = false
                        }
                        action?()
                    }) {
                        Text(confirmText)
                            .font(.body)
                            .fontWeight(.bold)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.clear)
                            .foregroundColor(confirmTextColor)
                            .cornerRadius(12)
                    }
                }
                .padding()
                .background(backgroundColor)
                .cornerRadius(20)
                .padding(40)
                .transition(.scale)
            }
        }
    }
    
    func cloverItem(date: Date, count: Int, action: @escaping () -> Void) -> some View {
        ZStack {
            VStack(spacing: 10) {
                Image("clover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 100)
                    .onTapGesture { action() }
                
                Text(formattedDay(date))
                    .font(.caption)
                    .foregroundColor(Color.text)
            }
            
            if count > 0 {
                Text("\(count)")
                    .font(.subheadline)
                    .foregroundColor(Color.black)
                    .frame(width: 24, height: 24)
                    .background(Circle().fill(Color.clovernumberback))
                    .offset(x: 36, y: 28)

            }
        }
    }
    
    func formattedFullDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM d, yyyy"
        return formatter.string(from: date)
    }
    
    func groupedLetters(for date: Date, letters: [Letter], currentUserNickname: String?) -> [Letter] {
        let calendar = Calendar.current
        return letters.filter {
            calendar.startOfDay(for: $0.date) == date &&
            $0.receiverUser == currentUserNickname
        }
    }
    
    // 날짜 → "d일" (clover 아래 표시용)
    func formattedDay(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d일"
        return formatter.string(from: date)
    }
    
}


