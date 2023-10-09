//
//  MemberManagementView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/27.
//

import SwiftUI

struct MemberManagementView: View {
    @StateObject private var sampleMemeberStore: SampleMemeberStore = SampleMemeberStore()
    @State private var isShowingAlert: Bool = false
    @State private var isEditing: Bool = false
    @State private var isShowingEditSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(sampleMemeberStore.members, id: \.self.name) { member in
                    HStack {
                        MemberCell(member: member)
                        
                        if member.userId == nil {
                            ShareLink(item: sampleMemeberStore.getURL(userName: member.name)) {
                                Text("초대하기")
                                    .font(Font.caption02)
                                    .foregroundColor(Color.systemGray07)
                            }
                            
                        } else {
                            Text("초대됨")
                                .font(Font.caption02)
                                .foregroundColor(Color.systemGray07)
                        }
                    }
                }
                .padding([.leading, .trailing], 24)
                Spacer()
            }
        }
        Section {
            Button {
                withAnimation {
                    sampleMemeberStore.addMember()
                }
            } label: {
                Text("인원 추가")
                    .font(Font.body02)
            }
            .frame(width: 332, height: 52)
            .background(Color.primary)
            .cornerRadius(12)
            .foregroundColor(.white)
            .padding(.bottom, 59)
            .animation(.easeIn(duration: 2), value: sampleMemeberStore.members)
        }
        .navigationTitle("인원관리")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("편집") {
                    isEditing.toggle()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("저장") {
                    sampleMemeberStore.saveMemeber()
                }
            }
            
            
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    isShowingAlert = true
                } label:{
                    /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                }
            }
        }
        .alert(isPresented: $isShowingAlert) {
            Alert(title: Text("수정을 취소하겠습니까?"),
                  primaryButton: .destructive(Text("계속작성")),
                  secondaryButton: .cancel(Text("확인"), action: {
                // dismiss
            }))
        }
        .sheet(isPresented: $isShowingEditSheet) {
            // onDismiss
        } content: {
            Text("hi")
        }

    }
}

#Preview {
    NavigationStack {
        MemberManagementView()
    }
}
