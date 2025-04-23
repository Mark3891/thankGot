import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                        to: nil, from: nil, for: nil)
    }
}


extension View {
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
                        .foregroundColor(.gray)
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
                    .font(.subheadline)
                    .foregroundColor(.white)
                    .padding(5)
                    .background(Color.letter)
                    .clipShape(Circle())
                    .offset(x: 50, y:-45)
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


