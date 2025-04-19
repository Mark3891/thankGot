import SwiftUI

struct cp_login: View {
    
    
    @State  var selectedTab: LoginTab = .signup
    @EnvironmentObject var userStore: UserStore // @EnvironmentObject로 UserStore 접근


    var body: some View {
      
           
                Image("wood")
                    .resizable()
                    .frame(width: 333, height: (selectedTab == .signup) ? 450 : 420)
                
                    .cornerRadius(15)
                    .overlay(
                        VStack(alignment: .leading, spacing: 0) {
                            
                            HStack(spacing: 0) {
                                tabButton(title: "Login", tab: .login)
                                
                                tabButton(title: "Sign Up", tab: .signup)
                            }
                            .frame(width: 333, height: 40)
                            .background(Color.backgroundColor2)
                            .clipShape(
                                RoundedCorner(radius: 15, corners: [.topLeft, .topRight])
                            )
                            // : HStack
                            
                            if (selectedTab == .login){
                                LoginView().environmentObject(userStore)
                            } else if (selectedTab == .signup){
                                SignUpView().environmentObject(userStore)
                            }
                            
                            
                            Spacer()
                        } // :VStack
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                    
                    ) //overlay
                    
            
       
       
        
    } // body
    
    
    
    struct RoundedCorner: Shape {
        var radius: CGFloat = 15.0
        var corners: UIRectCorner = .allCorners

        func path(in rect: CGRect) -> Path {
            let path = UIBezierPath(
                roundedRect: rect,
                byRoundingCorners: corners,
                cornerRadii: CGSize(width: radius, height: radius)
            )
            return Path(path.cgPath)
        }
    }
    
    
    func tabButton(title: String, tab: LoginTab) -> some View {
           
        ZStack{
            if(selectedTab == tab){
                Capsule()
                    .frame(width: 160, height: 30)
                    .foregroundColor(Color.background)
             }
            Button(action: {
                   selectedTab = tab
               }) {

                       Text(title)
                           .font(.system(size: selectedTab == tab ? 24 : 20, weight: selectedTab == tab ? .bold: .regular))
                           .foregroundColor(.white)
                           .opacity(selectedTab == tab ? 1 : 0.5)
   
               } //Button
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity )
        
        
       
           
       }

// MARK: - 탭 enum
       enum LoginTab {
           case login
           case signup
       }
    
}



#Preview {
    cp_login()
}
