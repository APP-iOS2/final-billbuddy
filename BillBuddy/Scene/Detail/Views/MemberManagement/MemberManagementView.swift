//
//  MemberManagementView.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/27.
//

import SwiftUI



struct MemberManagementView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var sampleMemeberStore: SampleMemeberStore = SampleMemeberStore()
    @EnvironmentObject private var travelDetailStore: TravelDetailStore

    var travel: TravelCalculation
    @State private var isShowingAlert: Bool = false
    @State private var isShowingSaveAlert: Bool = false
    @State private var isShowingEditSheet: Bool = false
    @State private var isShowingShareSheet: Bool = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            List {
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("연결된 인원")
                        .listRowSeparator(.hidden)
                        .font(.body04)
                        .foregroundStyle(Color.gray600)
                        .padding(.top, 12)
                    Divider()
                        .listRowSeparator(.hidden)
                        .padding(.top, 9)
                        .padding(.bottom, 12)
                }
                .listRowSeparator(.hidden)
                
                ForEach(sampleMemeberStore.connectedMemebers) { member in
                    MemberCell(
                        sampleMemeberStore: sampleMemeberStore,
                        isShowingShareSheet: $isShowingShareSheet,
                        member: member,
                        onEditing: {
                            sampleMemeberStore.selectMember(member.id)
                            isShowingEditSheet = true
                        },
                        onRemove: {
                            withAnimation {
                                sampleMemeberStore.removeMember(memberId: member.id)
                            }
                        }
                    )
                }
                .listRowSeparator(.hidden)
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("더미 인원")
                        .listRowSeparator(.hidden)
                        .font(.body04)
                        .foregroundStyle(Color.gray600)
                        .padding(.top, 12)
                    Divider()
                        .listRowSeparator(.hidden)
                        .padding(.top, 9)
                        .padding(.bottom, 12)
                }
                .listRowSeparator(.hidden)
                
                ForEach(sampleMemeberStore.dummyMemebers) { member in
                    MemberCell(
                        sampleMemeberStore: sampleMemeberStore,
                        isShowingShareSheet: $isShowingShareSheet,
                        member: member,
                        onEditing: {
                            sampleMemeberStore.selectMember(member.id)
                            isShowingEditSheet = true
                        },
                        onRemove: {
                            withAnimation {
                                sampleMemeberStore.removeMember(memberId: member.id)
                            }
                        }
                    )
                }
                .listRowSeparator(.hidden)
                VStack(alignment: .leading, spacing: 0) {
                    
                    Text("제외된 인원")
                        .listRowSeparator(.hidden)
                        .font(.body04)
                        .foregroundStyle(Color.gray600)
                        .padding(.top, 12)
                    Divider()
                        .listRowSeparator(.hidden)
                        .padding(.top, 9)
                        .padding(.bottom, 12)
                }
                .listRowSeparator(.hidden)
                
                ForEach(sampleMemeberStore.excludedMemebers) { member in
                    MemberCell(
                        sampleMemeberStore: sampleMemeberStore,
                        isShowingShareSheet: $isShowingShareSheet,
                        member: member,
                        onEditing: {
                            sampleMemeberStore.selectMember(member.id)
                            isShowingEditSheet = true
                        },
                        onRemove: {
                            withAnimation {
                                sampleMemeberStore.removeMember(memberId: member.id)
                            }
                        }
                    )
                }
                .listRowSeparator(.hidden)
            }
            .listStyle(.inset)
            
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
            .padding(.bottom, 54)
            .animation(.easeIn(duration: 2), value: sampleMemeberStore.members)
            
        }
        .padding(.top, 3)
        .onAppear {
            if sampleMemeberStore.InitializedStore == false {
                sampleMemeberStore.initStore(travel: travelDetailStore.travel)
            }
            travelDetailStore.listenTravelDate { travel in
                sampleMemeberStore.initStore(travel: travelDetailStore.travel)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    if sampleMemeberStore.isSelectedMember {
                        self.isShowingSaveAlert = true
                    } else {
                        travelDetailStore.stoplistening()
                        dismiss()
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
                travelDetailStore.stoplistening()
                dismiss()
            }),
                  secondaryButton: .default(Text("저장"), action: {
                Task {
                    travelDetailStore.stoplistening()
                    await sampleMemeberStore.saveMemeber()
                    dismiss()
                }
            }))
        }
        .sheet(isPresented: $isShowingEditSheet) {
            // onDismiss
        } content: {
            MemberEditSheet(
                member: $sampleMemeberStore.members[sampleMemeberStore.selectedmemberIndex],
                isShowingEditSheet: $isShowingEditSheet,
                isExcluded: sampleMemeberStore.members[sampleMemeberStore.selectedmemberIndex].isExcluded)
                .presentationDetents([.height(374)])
                .presentationDragIndicator(.hidden)
        }
        .sheet(isPresented: $isShowingShareSheet) {
            // onDismiss
        } content: {
            MemberShareSheet(sampleMemeberStore: sampleMemeberStore, isShowingShareSheet: $isShowingShareSheet)
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
        }
    }
}

#Preview {
    NavigationStack {
        MemberManagementView(travel: TravelCalculation.sampletravel)
    }
}
