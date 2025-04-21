import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userStore: UserStore // @EnvironmentObject로 UserStore 접근
    @EnvironmentObject var letterStore: LetterStore // letterStore


    init() {
        // 탭바 배경색 & 선택 색상 설정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        // 배경 이미지 설정
        if let backgroundImage = UIImage(named: "wood") {
            appearance.backgroundImage = backgroundImage
        }
        
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.button,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold) // ✅ 폰트 크기, 굵기 설정
        ]
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.button
        
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.nonselect
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.nonselect]
        
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        NavigationStack {
            TabView {
                sentPage()
                    .tabItem {
                        Image(systemName: "paperplane.fill")
                        Text("Sent")
                    }
                    
                    
                

                receivePage()
                    .tabItem {
                        Image(systemName: "tray.and.arrow.down.fill")
                        Text("Received")
                    }
                   
                   
            }
            .accentColor(Color.backgroundColor2) // 선택된 탭 아이템 색상
            
        }
        
    }
}
