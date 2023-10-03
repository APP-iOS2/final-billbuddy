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
        
        Form {
            Section {
                ForEach(sampleMemeberStore.members, id: \.self.name) { member in
                    HStack {
                        Button {
                            print("a")
                        } label: {
                            HStack {
                                Text(member.name)
                                Spacer()
                                Text("선금: \(member.advancePayment)")
                                Spacer()
                            }
                            
                        }
                        
                        if member.userId == nil && !isEditing {
                            ShareLink(item: sampleMemeberStore.getURL(userName: member.name), subject: Text("d"), message: Text("초대합니다")) {
                                Text("초대하기")
                            }
                        } else if isEditing {
                            Button {
                                isShowingEditSheet = true
                            } label: {
                                Text("편집")
                            }

                        } else {
                            EmptyView()
                        }
                    }
                }
            }
            Section {
                Button {
                    withAnimation {
                        sampleMemeberStore.addMember()
                    }
                } label: {
                    Label("인원추가하기", systemImage: "plus")
                }
                .animation(.easeIn(duration: 2), value: sampleMemeberStore.members)
                

            }
           
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
