import SwiftUI

struct TopTitle: View {
    
    var title: String
    
    var body: some View {
        ZStack {
            Image("wood")
                .resizable()
                .frame(width: UIScreen.main.bounds.width - 40, height: 80)
                .cornerRadius(15) // Optional: 둥글게
            
            // Stroke 텍스트
            Text(title)
                .font(Font.custom("WoodyWood", size: 60))
                .foregroundColor(.clear) // 본문 텍스트는 투명하게
                .overlay(
                    Text(title)
                        .font(Font.custom("WoodyWood", size: 60))
                        .foregroundColor(.black)
                        .offset(x: 1, y: 1) // Stroke 효과 (살짝 움직임)
                        .opacity(0.4) // 투명도 40%
                )
            
            // 본문 텍스트
            Text(title)
                .font(Font.custom("WoodyWood", size: 60))
                .foregroundColor(.black) // 실제 텍스트 색상
        }//: ZStack
    }
}

#Preview {
    TopTitle(title: "Sent")
}
