//
//  editPage.swift
//  thankGot
//
//  Created by Woody on 4/18/25.
//

import SwiftUI

struct editPage: View {
    let letter: Letter
    @EnvironmentObject var letterStore: LetterStore
    @Environment(\.dismiss) var dismiss
    @State private var updatedContent = ""
    
    init(letter: Letter) {
        self.letter = letter
        _updatedContent = State(initialValue: letter.content)
    }
    
    var body: some View {
        ZStack{
            Color.background.ignoresSafeArea()
                .onTapGesture {
                    hideKeyboard()
                }
            
            ScrollView{
                VStack (alignment: .leading,spacing: 20){
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            Image(systemName: "arrow.backward")
                                .foregroundColor(.white)
                                .padding(.vertical)
                        } //button
                        Spacer()
                    }//: HStack
                   
                    
                    ZStack(alignment: .topLeading){
                        VStack(alignment: .leading){
                           
                            
                           
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text:$updatedContent)
                                    .overlay(alignment: .topLeading) {
                                        Text("입력하세요.")
                                            .foregroundStyle(updatedContent.isEmpty ? .gray : .clear)
                                            .font(.title2)
                                    }
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .frame(height: 500)
                                    .scrollContentBackground(.hidden)
                                    .background(Color.texteditor)
                                    .cornerRadius(12)
                                    .foregroundColor(.white)
                                    .lineSpacing(20)
                                    .overlay(alignment: .bottomTrailing) {
                                        Text("\(updatedContent.count) / 200")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(UIColor.systemGray2))
                                            .padding(.trailing, 15)
                                            .padding(.bottom, 15)
                                    }
                                    .onChange(of: updatedContent) {
                                        // 글자수 제한 (200)
                                        if updatedContent.count > 200 {
                                            updatedContent = String(updatedContent.prefix(200))
                                        }
                                        // 줄 수 제한 (10)
                                        let lines = updatedContent.components(separatedBy: "\n")
                                        if lines.count > 10 {
                                            updatedContent = lines.prefix(10).joined(separator: "\n")
                                        }
                                    }
                                VStack(alignment: .leading,spacing: 40) {
                                    ForEach(0..<10, id: \.self) { _ in
                                        Rectangle()
                                            .fill(Color.line)
                                            .frame(height: 2)
                                            .padding(.horizontal,16)
                                    }
                                } //: VStack
                                .padding(.top, 38)
                            } //: ZStack
                            
                            
                        } // vstack
                        
                       
                        
                        
                    }// zstack
                    

                   

                  

                    Button {
                        print("\(letter.id ?? "없음")")
                        letterStore.updateLetter(letter.id ?? "", newContent: updatedContent) { error in
                                if error == nil {
                                    dismiss()
                                }
                            }
                       

                    } label: {
                        Text("Edit")
                            .font(.system(size: 24))
                            .fontWeight(.regular)
                        Image(systemName: "pencil")
                    }
                    .frame(maxWidth: .infinity, maxHeight: 40)
                    .padding(.vertical, 5)
                    .background(Color.button)
                    .cornerRadius(12)
                    .foregroundColor(Color.white)


                    Spacer()
                } //: VStack
                .frame(width:UIScreen.main.bounds.width-40)
                .ignoresSafeArea(.keyboard)
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }

    
    }
