//
//  MemberShareSheet.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/15/23.
//

import SwiftUI
import UIKit

struct MemberShareSheet: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var sampleMemeberStore: SampleMemeberStore
    @EnvironmentObject var notificationStore: NotificationStore
    @Binding var isShowingShareSheet: Bool
    @State private var searchText: String = ""
    @State private var isShowingInviteAlert: Bool = false
    @State private var seletedUser: User = User(email: "", name: "", phoneNum: "", bankName: "", bankAccountNum: "", isPremium: false, premiumDueDate: Date.now)
    var body: some View {
        NavigationStack {
            VStack() {
                if sampleMemeberStore.searchResult.isEmpty {
                    ForEach(sampleMemeberStore.searchResult) { user in
                        Button {
                            seletedUser = user
                            isShowingInviteAlert = true
                        } label: {
                            VStack {
                                Image("DBPin")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                    .padding(.leading, 8)
                                
                                VStack(alignment: .leading, spacing: 0) {
                                    Text(user.name)
                                        .font(.body04)
                                        .frame(height: 20)
                                    Text(user.email)
                                        .font(.body02)
                                        .frame(height: 20)
                                }
                            }
                            .padding(.leading, 12)
                            .foregroundColor(Color.systemBlack)
                        }
                        .alert(isPresented: $isShowingInviteAlert) {
                            Alert(title: Text("해당인원을 초대하시겠습다."),
                                  message: Text("모든 변경내용이 저장됩니다."),
                                  primaryButton: .destructive(Text("취소하고 나가기")),
                                  secondaryButton: .default(Text("저장"), action: {
                                Task {
                                    let noti = UserNotification(
                                        type: .invite,
                                        content: "\(sampleMemeberStore.travel.travelTitle) 에서 당신을 초대했습니다",
                                        contentId: "\(URLSchemeBase.scheme.rawValue)://travel?travelId=\(sampleMemeberStore.travel.id )&memberId=\(sampleMemeberStore.seletedMember.id)",
                                        addDate: Date.now)
                                    await sampleMemeberStore.inviteMemberAndSave()
                                    notificationStore.sendNotification(users: [seletedUser], notification: noti)
                                    isShowingShareSheet = false
                                }
                            }))
                        }
                    }
                } else {
                    Text("검색결과가 없습니다.")
                }
            }
            
            .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "이름 또는 이메일을 검색해주세요")
            .onSubmit(of: .search) {
                sampleMemeberStore.searchUser(query: searchText)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image("arrow_back")
                            .resizable()
                            .frame(width: 24, height: 24)
                    })
                }
                ToolbarItem(placement: .principal) {
                    Text("유저 초대하기")
                        .font(.title05)
                        .foregroundColor(Color.systemBlack)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    ShareLink("초대하기", items: [sampleMemeberStore.getURL(memberId: sampleMemeberStore.seletedMember.id)])
                        .foregroundStyle(Color.systemBlack)
                }
            }
        }
    }
    
}

#Preview {
    NavigationStack {
        MemberShareSheet(sampleMemeberStore: SampleMemeberStore(), isShowingShareSheet: .constant(true))
            .environmentObject(NotificationStore())
    }
}
