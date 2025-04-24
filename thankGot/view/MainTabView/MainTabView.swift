import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore
    
    enum Tab {
        case sent, received, myPage
    }
    
    @State private var selectedTab: Tab = .sent
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // 현재 선택된 페이지
                Group {
                    switch selectedTab {
                    case .sent:
                        sentPage()
                    case .received:
                        receivePage()
                    case .myPage:
                        myPage()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 커스텀 탭바
                HStack {
                    
                    TabBarButton(
                        isSelected: selectedTab == .sent,
                        systemImage: selectedTab == .sent ? "paperplane.fill" : "paperplane",
                        text: "Sent"
                    ) {
                        selectedTab = .sent
                    }
                    
                    TabBarButton(
                        isSelected: selectedTab == .received,
                        systemImage: selectedTab == .received ? "envelope.fill" : "envelope",
                        text: "Received"
                    ) {
                        selectedTab = .received
                    }
                    
                    TabBarButton(
                        isSelected: selectedTab == .myPage,
                        systemImage: selectedTab == .myPage ? "person.fill" : "person",
                        text: "My page"
                    ) {
                        selectedTab = .myPage
                    }
                    
                }
                .frame(height: 50)
                .padding(.bottom, 30)
                .background(
                    Image("wood")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea(edges: .bottom)
                )
               
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct TabBarButton: View {
    let isSelected: Bool
    let systemImage: String
    let text: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Image(systemName: systemImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: isSelected ? 36 : 28, height: isSelected ? 36 : 28)
                    .foregroundColor(isSelected ? Color.nonselect : Color.nonselect)
                
                
            }
        }
        .frame(maxWidth: .infinity)
        
    }
}

