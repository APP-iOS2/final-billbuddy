//
//  MemberShareSheet.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/15/23.
//

import SwiftUI
import UIKit

struct MemberShareSheet: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var sampleMemeberStore: SampleMemeberStore
    @EnvironmentObject private var notificationStore: NotificationStore
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @Binding var isShowingShareSheet: Bool
    @State private var searchText: String = ""
    @State private var isShowingInviteAlert: Bool = false
    @State private var seletedUser: User = User(email: "", name: "", bankName: "", bankAccountNum: "", isPremium: false, premiumDueDate: Date.now, reciverToken: "")
    @State private var isfinishsearched: Bool = true
    let saveAction: () -> Void
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                HStack(spacing: 0) {
                    Image(.search)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 12)
                        .padding(.trailing, 8)
                    TextField("이름 또는 이메일을 입력해주세요", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .font(.body04)
                        .onChange(of: searchText) { _ in
                            sampleMemeberStore.isfinishsearched = true
                        }
                        .onSubmit() {
                            if searchText.isEmpty == false {
                                sampleMemeberStore.searchUser(query: searchText)
                            }
                        }
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            self.searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .frame(width: 24, height: 24)
                                .padding(.trailing, 12)
                        }
                    } else {
                        EmptyView()
                            .frame(width: 24, height: 24)
                    }
                }
                .frame(height: 40)
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(12.0)
                .padding(.horizontal, 17)
                .padding(.top, 15)
                .padding(.bottom, 8)
                
                if sampleMemeberStore.isSearching == false {
                    if sampleMemeberStore.searchResult.isEmpty == false {
                        ForEach(sampleMemeberStore.searchResult) { user in
                            Button {
                                seletedUser = user
                                isShowingInviteAlert = true
                            } label: {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        Image(.defaultUser)
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .padding(.trailing, 12)
                                        Text(user.name)
                                            .foregroundStyle(Color.systemBlack)
                                            .padding(.trailing, 6)
                                        Text(user.email)
                                            .foregroundStyle(Color.gray600)
                                            .font(.body02)
                                        Spacer()
                                    }
                                    .font(.body04)
                                    
                                    .frame(height: 64)
                                }
                                .padding([.leading, .trailing], 24)
                                .foregroundColor(Color.systemBlack)
                            }
                            .alert(isPresented: $isShowingInviteAlert) {
                                Alert(title: Text("해당인원을 초대하시겠습다."),
                                      message: Text("모든 변경내용이 저장됩니다."),
                                      primaryButton: .destructive(Text("취소")),
                                      secondaryButton: .default(Text("초대"), action: {
                                    Task {
                                        let noti = UserNotification(
                                            type: .invite,
                                            content: "\(sampleMemeberStore.travel.travelTitle) 에서 당신을 초대했습니다",
                                            contentId: "\(URLSchemeBase.scheme.rawValue)://travel?travelId=\(sampleMemeberStore.travel.id )&memberId=\(sampleMemeberStore.seletedMember.id)",
                                            addDate: Date.now)
                                        await sampleMemeberStore.inviteMemberAndSave() {
                                            saveAction()
                                        }
                                        notificationStore.sendNotification(users: [seletedUser], notification: noti)
                                        
                                        if let serverKey = ServerKeyManager.loadServerKey() {
                                            PushNotificationManager.sendPushNotificationToToken(seletedUser.reciverToken, title: "여행 초대", body: "\(sampleMemeberStore.travel.travelTitle)에서 당신을 초대했습니다", senderToken: UserService.shared.currentUser?.reciverToken ?? "", serverKey: serverKey)
                                        }
                                        
                                        isShowingShareSheet = false
                                    }
                                }))
                            }
                        }
                    } else {
                        VStack {
                            if sampleMemeberStore.isfinishsearched == false && sampleMemeberStore.searchResult.isEmpty {
                                Text("'\(searchText)'에 대한 검색 결과가 없어요")
                                    .font(.body03)
                                    .foregroundStyle(Color.systemBlack)
                                
                            }
                        }
                        .padding(.top, 15)

                    }
                } else {
                    ProgressView()
                        .padding(.top, 25)
                }
            }
            Spacer()
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
                    ShareLink(items: [sampleMemeberStore.getURL(memberId: sampleMemeberStore.seletedMember.id)]) {
                        Image(systemName: "square.and.arrow.up")
                    }
                    .foregroundStyle(Color.systemBlack)
                    
                }
            }
        }
        .onDisappear {
            sampleMemeberStore.searchResult = []
        }
     
    }
    
}

#Preview {
    NavigationStack {
        MemberShareSheet(sampleMemeberStore: SampleMemeberStore(), isShowingShareSheet: .constant(true), saveAction: { })
            .environmentObject(NotificationStore.shared)
    }
}
