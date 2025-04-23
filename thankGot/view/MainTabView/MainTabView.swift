import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var userStore: UserStore // @EnvironmentObject로 UserStore 접근
    @EnvironmentObject var letterStore: LetterStore // letterStore
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        if let backgroundImage = UIImage(named: "wood") {
            appearance.backgroundImage = backgroundImage
        }
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.button,
            .font: UIFont.systemFont(ofSize: 14, weight: .bold)
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
                
                myPage()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("My page")
                    }
      
            }
            .accentColor(Color.backgroundColor2) // 선택된 탭 아이템 색상
            
        }
        
    }
}
