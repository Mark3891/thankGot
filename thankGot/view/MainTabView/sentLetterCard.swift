import SwiftUI

struct sentLetterCard: View {
    let letter: Letter
   
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("To: \(letter.receiverUser)")
                .font(.title)
                .fontWeight(.semibold)
                .foregroundColor(.white)
            
            Text(letter.content)
                .foregroundColor(.white)
                .lineLimit(3)
                .frame(width: UIScreen.main.bounds.width - 60, alignment: .leading)
                
            Text(letter.date.formatted(.dateTime.month().day().year()))
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding()
        .frame(width: UIScreen.main.bounds.width - 40,height: 120)
        .background(Color.texteditor)
        .cornerRadius(12)
        
       
    }
}

struct SwipeableLetterCard: View {
    let letter: Letter
    var onEdit: () -> Void

    @State private var offsetX: CGFloat = 0
    @GestureState private var dragOffset: CGFloat = 0
    @State private var isShowingEditSheet = false

    var body: some View {
        ZStack(alignment: .trailing) {
            // 배경 Edit 버튼
            HStack {
                Spacer()
                Button(action: {
                    isShowingEditSheet = true
                    print("asdfsadfas")
                    withAnimation {
                        offsetX = 0
                    }
                }) {
                    Image(systemName: "pencil")
                        .font(.largeTitle)
                        .foregroundStyle(Color.white)
                   
                }
                .padding(.trailing)
            }
            
            .frame(width: UIScreen.main.bounds.width - 40, height: 120)
            .background(Color.button)
            .clipShape(RoundedRectangle(cornerRadius: 12)) // 👉 순서 중요!!
            

            sentLetterCard(letter: letter)
            
                .overlay(
                    
                    GeometryReader { geometry in
                        Color.clear
                            .frame(width: 150)
                            .contentShape(Rectangle())
                            .position(x: geometry.size.width / 2, y: geometry.size.height / 2)
                            
                            .gesture(
                                DragGesture()
                                    .updating($dragOffset) { value, state, _ in
                                        if value.translation.width < 0 {
                                            state = value.translation.width
                                        }
                                    }
                                    .onEnded { value in
                                        withAnimation {
                                            if value.translation.width < -80 {
                                                offsetX = -100
                                            } else {
                                                offsetX = 0
                                            }
                                        }
                                    }
                            )
                    }
                )
                .offset(x: offsetX + dragOffset)
        }
        .sheet(isPresented: $isShowingEditSheet) {
            editPage(letter: letter)
                       .environmentObject(LetterStore()) 
               }
       
    }
}

#Preview {
    ScrollView {
        LazyVStack(spacing: 40) {
            ForEach(dummySentLetters, id: \.id) { letter in
                SwipeableLetterCard(letter: letter) {
                    print("Edit tapped")
                }
            }
        }
        .padding(.horizontal)
    }
}

