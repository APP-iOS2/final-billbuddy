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
    @State private var isShowingShareSheet: Bool = false
    
    var body: some View {
        List {
            ForEach(Array(sampleMemeberStore.members.enumerated()), id: \.element) { index ,member in
                HStack {
                    MemberCell(
                        member: member,
                        onEditing: {
                            sampleMemeberStore.startEdit(index)
                            isShowingEditSheet = true
                        },
                        onRemove: {
                            withAnimation {
                                sampleMemeberStore.removeMember(memberId: member.id)
                            }
                        }
                    )
                    
                    RoundedRectangle(cornerRadius: 15.5)
                        .strokeBorder(Color.gray100, lineWidth: 1)
                        .frame(width: 80, height: 28)
                        .clipShape(RoundedRectangle(cornerRadius: 15.5))
                        .overlay(alignment: .center) {
                            ZStack(alignment: .center) {
                                Text(member.userId == nil ? "초대하기" : "초대됨")
                                    .font(Font.caption02)
                                    .foregroundColor(Color.gray600)
                                if member.userId == nil {
                                    Button {
                                        sampleMemeberStore.startEdit(index)
                                        isShowingShareSheet = true
                                    } label: {
                                        
                                    }
                                }
                            }
                        }
                        .padding(.trailing, 24)

                    
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
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if sampleMemeberStore.isSelectedMember {
                        self.isShowingSaveAlert = true
                    } else {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                })
                
            }
            
            ToolbarItem(placement: .principal) {
                Text("인원 관리")
                    .font(.title05)
                    .foregroundColor(Color.systemBlack)
            }
        }
        .alert(isPresented: $isShowingSaveAlert) {
            Alert(title: Text("변경사항을 저장하시겠습니까?"),
                  message: Text("뒤로가기 시 변경사항이 삭제됩니다."),
                  primaryButton: .destructive(Text("취소하고 나가기"), action: {
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
            MemberEditSheet(member: $sampleMemeberStore.members[sampleMemeberStore.selectedmemberIndex], isShowingEditSheet: $isShowingEditSheet)
                .presentationDetents([.height(374)])
                .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $isShowingShareSheet) {
            // onDismiss
        } content: {
            MemberShareSheet(activityItems: [sampleMemeberStore.getURL()])
                .presentationDetents([.medium])
                .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    NavigationStack {
        MemberManagementView()
    }
}
