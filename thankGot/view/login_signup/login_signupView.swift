//
//  login_signupView.swift
//  thankGot
//
//  Created by Woody on 4/15/25.
//

import SwiftUI

struct login_signupView: View {
    @AppStorage("isLoggedIn") var isLoggedIn = false
 
    var body: some View {
        
        NavigationStack{
            
            ZStack{
                Color.background
                    .ignoresSafeArea()
                
                ScrollView{
                    VStack{
                        
                        
                        TopTitle("ThankGot")
                            .padding(.top, UIScreen.main.bounds.height * 0.1)
                            .padding(.bottom,20)
                        
                        cp_login().background(Color.clear)
                        
                    }
                    
                }
                
                
                
                
            } //ZStack
            .navigationDestination(isPresented: $isLoggedIn) {
                MainTabView()            }
            
        } // NavigationView
        
    }
}

