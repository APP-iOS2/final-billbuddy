//
//  MemberManagementView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/27.
//

import SwiftUI

struct MemberManagementView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @StateObject private var sampleMemeberStore: SampleMemeberStore = SampleMemeberStore()
    @State private var isShowingAlert: Bool = false
    @State private var isShowingSaveAlert: Bool = false
    @State private var isEditing: Bool = false
    @State private var isShowingEditSheet: Bool = false
    
    var body: some View {
        List {
            ForEach(sampleMemeberStore.members, id: \.self.name) { member in
                HStack {
                    MemberCell(
                        member: member,
                        onEditing: {
                            isShowingEditSheet = true
                        },
                        onRemove: {
                            withAnimation {
                                sampleMemeberStore.removeMember(memberId: member.id)
                            }
                        }
                    )
                    
                    if member.userId == nil {
                        
                        ShareLink(item: sampleMemeberStore.getURL(userId: member.id), message: Text("여행에 초대합니다")) {
                            Text("초대하기")
                                .font(Font.caption02)
                                .foregroundColor(Color.gray600)
                                .padding(.trailing, 24)
                        }
                        
                    } else {
                        Text("초대됨")
                            .font(Font.caption02)
                            .foregroundColor(Color.gray600)
                            .padding(.trailing, 24)

                    }
                }
                
            }
            .listRowSeparator(.hidden)
        }
        .listStyle(.inset)

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
            .background(Color.myPrimary)
            .cornerRadius(12)
            .foregroundColor(.white)
            .padding(.bottom, 59)
            .animation(.easeIn(duration: 2), value: sampleMemeberStore.members)
        }
        .navigationTitle("인원관리")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if sampleMemeberStore.isEdited {
                        self.isShowingSaveAlert = true
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                .alert(isPresented: $isShowingSaveAlert) {
                    Alert(title: Text("변경사항을 저장하시겠습니까?"),
                          message: Text("뒤로가기 시 변경사항이 삭제됩니다."),
                          primaryButton: .destructive(Text("뒤로가기"), action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }),
                          secondaryButton: .default(Text("저장"), action: {
                        Task {
                            await sampleMemeberStore.saveMemeber()
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    }))
                }
                
                .sheet(isPresented: $isShowingEditSheet) {
                    // onDismiss
                } content: {
                    Text("hi")
                }
            }
            
            ToolbarItem(placement: .principal) {
                Text("결산")
                    .font(.title05)
                    .foregroundColor(Color.systemBlack)
            }
        }
       
        
        

    }
}

#Preview {
    NavigationStack {
        MemberManagementView()
    }
}
