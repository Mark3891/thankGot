import SwiftUI

struct sentLetterCard: View {
    let letter: Letter
    @EnvironmentObject var letterStore: LetterStore
    @State private var isShowingEditSheet = false
    
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
        .swipeActions {
            Button(action: {
                isShowingEditSheet = true
            }) {
                ZStack {
                    Color.clear 
                    VStack {
                        Image(systemName: "pencil")
                            .font(.title2)
                            .foregroundColor(.white)
                        Text("Edit")
                            .font(.caption2)
                            .foregroundColor(.white)
                    }
                   
                }
                
            }
            .tint(Color.button)
        }
        .sheet(isPresented: $isShowingEditSheet) {
            editPage(letter: letter)
                .environmentObject(letterStore)
        }
        
        
    }
    
   
}

#Preview {
    sentLetterCard(
        letter: Letter(
            id: "1",
            sentUser: "changgeon",
            receiverUser: "minji",
            date: Date(),
            content: "안녕 민지야! 잘 지내고 있니?"
        )
    )
    .environmentObject(LetterStore())
}
