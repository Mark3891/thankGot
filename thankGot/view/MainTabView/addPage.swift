import SwiftUI

struct addPage: View {
    @EnvironmentObject var userStore: UserStore
    @EnvironmentObject var letterStore: LetterStore
    @Environment(\.dismiss) var dismiss
    @State private var letter_receiverUser = ""
    @State private var showDatePicker = false
    @State private var selectedDate = Date()
    @State private var content = ""
    @State private var filteredUsers: [String] = []
    @State private var errorMessage: String = ""
    @State private var isError : Bool = false
    @State private var isSending = false // 중복 방지용 플래그

    

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
                            VStack{
                                HStack{
                                    ZStack{
                                        TextField("", text: $letter_receiverUser, prompt: Text("nickname").foregroundColor(Color.gray))
                                            .padding(.leading,70)
                                            .padding(.vertical,10)
                                            .padding(.trailing,30)
                                            .frame(height:50)
                                            .background(Color.texteditor)
                                            .cornerRadius(12)
                                            .foregroundColor(.white)
                                            .onChange(of: letter_receiverUser) { newValue in
                                                if !newValue.isEmpty {
                                                    filteredUsers = dummyUsers
                                                        .filter { $0.lowercased().contains(newValue.lowercased()) }
                                                        .prefix(3)
                                                        .map { $0 }
                                                } else {
                                                    filteredUsers = []
                                                }
                                            }

                                        

                                        HStack {
                                            Text("Dear")
                                                .font(.title2)
                                                .foregroundColor(Color.white)
                                                
                                            Spacer()
                                            Button(action: {
                                                letter_receiverUser = ""
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                            }
                                        }.padding(.horizontal,10)
                                    } //: ZStack
                                    .frame(width: 180)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        showDatePicker = true
                                    }) {
                                        HStack(spacing: 10) {
                                            Image(systemName: "calendar")
                                            Text("\(selectedDate.formatted(.dateTime.month(.abbreviated).day().year()))")
                                                .foregroundColor(.white)
                                               
                                        }
                                        .foregroundColor(.white)
                                        .padding()
                                        .background(Color.texteditor)
                                        .cornerRadius(10)
                                    } // button
                                } //: HStack
                                
                                if isError {
                                    HStack{
                                        Text("\(errorMessage)")
                                            .font(.caption)
                                            .foregroundStyle(.red)
                                            
                                            .padding(.horizontal,5)
                                        Spacer()
                                    }
                                   
                                }
                                }
                           
                            .frame(height:50)
                            .padding(.bottom, 30)
                            
                           
                            
                            ZStack(alignment: .topLeading) {
                                TextEditor(text: $content)
                                    .overlay(alignment: .topLeading) {
                                        Text("입력하세요.")
                                            .foregroundStyle(content.isEmpty ? .gray : .clear)
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
                                        Text("\(content.count) / 200")
                                            .font(.system(size: 12))
                                            .foregroundColor(Color(UIColor.systemGray2))
                                            .padding(.trailing, 15)
                                            .padding(.bottom, 15)
                                    }
                                    .onChange(of: content) {
                                        // 글자수 제한 (200)
                                        if content.count > 200 {
                                            content = String(content.prefix(200))
                                        }
                                        // 줄 수 제한 (10)
                                        let lines = content.components(separatedBy: "\n")
                                        if lines.count > 10 {
                                            content = lines.prefix(10).joined(separator: "\n")
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
                        
                        if !filteredUsers.isEmpty {
                            ScrollView {
                                VStack(alignment: .leading,spacing: 0) {
                                    ForEach(filteredUsers, id: \.self) { name in
                                        Button(action: {
                                            letter_receiverUser = name
                                            filteredUsers = []
                                        }) {
                                            Text(name)
                                                .foregroundColor(.white)
                                                .padding(.horizontal)
                                                .padding(.vertical, 6)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                                .background(Color.gray.opacity(0.3))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                            }
                            .frame(width: 130,height: 120)
                            .padding(.leading, 55)
                            .padding(.top, 50)
                        }
                        
                        
                    }// zstack
                    

                   

                  

                    Button {
                        
                        
                        guard !isSending else { return }
                        
                        // 1. nickname이 dummyUsers 목록에 있는지 확인
                        guard dummyUsers.contains(letter_receiverUser) else {
                            errorMessage = "잘못된 닉네임입니다."
                            isError = true
                            return
                        }
                        
                
                        isSending = true // 중복 방지를 위해 잠금
                        
                        // 모든 조건을 만족하면 편지 보내기
                        let newLetter = Letter(
                            id: "", // 실제 저장될 때 Firestore 문서 ID가 사용되니 이건 무시돼도 돼
                            sentUser: userStore.currentUser?.nickname ?? "unknown",
                            receiverUser: letter_receiverUser,
                            date: selectedDate,
                            content: content
                        )

                        letterStore.sendLetter(letter: newLetter) { error in
                            isSending = false // 전송 끝나면 다시 풀어줌
                            if let error = error {
                                print("🔥 편지 보내기 실패: \(error.localizedDescription)")
                            } else {
                                print("✅ 편지 보냈습니다!")
                                dismiss() // 성공했으면 화면 닫기 등
                            }
                        }

                    } label: {
                        Text("Send")
                            .font(.system(size: 24))
                            .fontWeight(.regular)
                        Image(systemName: "paperplane")
                    }
                    .disabled(isSending) // 버튼 비활성화
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
            
            if showDatePicker {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        showDatePicker = false
                    }

                VStack(spacing: 20) {
                    DatePicker("Pick a date", selection: $selectedDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                        .accentColor(Color.background)
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding()
                    
                    if isError {
                        Text(errorMessage)
                            .foregroundColor(.red)
                    }

                    Button("확인") {
                        let today = Date()
                        if selectedDate < today {
                            errorMessage = "선택한 날짜는 오늘 날짜보다 이전일 수 없습니다."
                            isError = true
                            return
                        }
                        errorMessage = ""
                        showDatePicker = false
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.backAdd)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(20)
                .padding(.horizontal, 30)
                .shadow(radius: 10)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
  addPage()
}
