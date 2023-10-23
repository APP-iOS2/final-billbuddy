//
//  ChattingRoomView.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/04.
//

import SwiftUI
import PhotosUI

struct ChattingRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var messageStore: MessageStore
    @EnvironmentObject private var notificationStore: NotificationStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    var travel: TravelCalculation
    @State private var inputText: String = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var imageData: Data?
    @State private var imagePath: String?
    
    var body: some View {
        VStack {
            if messageStore.messages.isEmpty {
                emptyChat
            } else {
                chattingItem
            }
            chattingInputBar
        }
        .onAppear {
            tabBarVisivilyStore.hideTabBar()
            messageStore.fetchMessages(travelCalculation: travel)
        }
        .onChange(of: selectedPhoto) { newValue in
            guard let item = selectedPhoto else {
                return
            }
            item.loadTransferable(type: Data.self) { result in
                switch result {
                case .success(let data):
                    if let data = data {
                        self.imageData = data
                    } else {
                        print("no image")
                    }
                case .failure(let failure):
                    fatalError("\(failure)")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    SchemeService.shared.removeUrl()
                    dismiss()
                }, label: {
                    Image(.arrowBack)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            ToolbarItem(placement: .principal) {
                Text(travel.travelTitle)
                    .font(.title05)
                    .foregroundColor(.systemBlack)
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    ChattingMenuView(travel: travel)
                } label: {
                    Image(.steps13)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
    
    /// 아직 채팅을 시작하지 않았을 때
    private var emptyChat: some View {
        VStack {
            Text("여행 친구들과 대화를 시작해보세요")
                .font(Font.body04)
                .foregroundColor(.gray500)
                .padding()
            Spacer()
        }
    }
    
    /// 채팅 메세지 버블
    private var chattingItem: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                ForEach(messageStore.messages) { message in
                    if message.senderId == AuthStore.shared.userUid {
                        HStack {
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text(message.userName ?? "이름없음")
                                    .font(Font.caption02)
                                    .foregroundColor(.systemBlack)
                                HStack {
                                    VStack {
                                        Spacer()
                                        Text(message.sendDate.toFormattedChatDate())
                                            .font(Font.caption02)
                                            .foregroundColor(.gray500)
                                    }
                                    VStack(alignment: .trailing) {
                                        if let imageMessage = message.imageString {
                                            AsyncImage(url: URL(string: imageMessage)) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width:120, height: 120)
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width:120, height: 120)
                                            }
                                        }
                                        if message.message != "" {
                                            Text(message.message)
                                                .font(Font.body04)
                                                .foregroundColor(.systemBlack)
                                                .padding(.horizontal)
                                                .padding(.vertical, 10)
                                                .background(Color.lightBlue300)
                                                .cornerRadius(12)
                                        }
                                    }
                                }
                            }
                            VStack {
                                Image(.defaultUser)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    } else {
                        HStack {
                            VStack {
                                Image(.defaultUser)
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                Spacer()
                            }
                            VStack(alignment: .leading) {
                                Text(message.userName ?? "이름없음")
                                    .font(Font.caption02)
                                    .foregroundColor(.systemBlack)
                                HStack {
                                    VStack(alignment: .leading) {
                                        if let imageMessage = message.imageString {
                                            AsyncImage(url: URL(string: imageMessage)) { image in
                                                image
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width:120, height: 120)
                                            } placeholder: {
                                                ProgressView()
                                                    .frame(width:120, height: 120)
                                            }
                                        }
                                        if message.message != ""  {
                                            Text(message.message)
                                                .font(Font.body04)
                                                .foregroundColor(.systemBlack)
                                                .padding(.horizontal)
                                                .padding(.vertical, 10)
                                                .background(Color.gray050)
                                                .cornerRadius(12)
                                        }
                                    }
                                    VStack {
                                        Spacer()
                                        Text(message.sendDate.toFormattedChatDate())
                                            .font(Font.caption02)
                                            .foregroundColor(.gray500)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 5)
                    }
                }
                HStack { }
                    .id("last")
            }
            .onReceive(messageStore.$isAddedNewMessage, perform: { _ in
                if !messageStore.messages.isEmpty {
                    withAnimation {
                        scrollProxy.scrollTo("last", anchor: .bottom)
                    }
                }
            })
        }
    }
    
    /// 채팅 메세지/이미지 입력창
    private var chattingInputBar: some View {
        VStack {
            if let photoImage = imageData, let uiImage = UIImage(data: photoImage) {
                HStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .padding(.horizontal, 10)
                        .overlay(alignment: .topTrailing) {
                            Button(action: {
                                imageData?.removeAll()
                                selectedPhoto = nil
                            }, label: {
                                Image(.close)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                            })
                        }
                    Spacer()
                }
            }
            HStack() {
                if selectedPhoto != nil {
                    TextField("", text: $inputText)
                        .disabled(true)
                        .padding()
                } else {
                    TextField("내용을 입력해주세요", text: $inputText)
                        .padding()
                }
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Image(.gallery)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray600)
                }
                Button {
                    PushNotificationManager.sendPushNotification(title: "\(travel.travelTitle) 채팅방", body: "읽지 않은 메세지를 확인해보세요.")
                    NotificationStore().sendNotification(members: travel.members, notification: UserNotification(type: .chatting, content: "읽지 않은 메세지를 확인해보세요.", contentId: "\(URLSchemeBase.scheme.rawValue)://travel?travelId=\(travel.id)", addDate: Date(), isChecked: false))
                    sendChat()
                    selectedPhoto = nil
                    imageData?.removeAll()
                    inputText.removeAll()
                } label: {
                    Image(.mailSendEmailMessage35)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray600)
                }
                .padding(.trailing, 10)
            }
            .frame(height: 50)
            .background(Color.gray050)
            .cornerRadius(12)
            .padding(.horizontal, 10)
        }
    }
        
    /// 채팅 콘텐츠 분기처리해서 스토어로
    private func sendChat() {
        if let photoItem = selectedPhoto {
            Task {
                imagePath = await messageStore.getImagePath(item: photoItem, travelCalculation: travel)
                let newMessage = Message(
                    senderId: AuthStore.shared.userUid,
                    message: inputText,
                    imageString: imagePath,
                    sendDate: Date().timeIntervalSince1970,
                    isRead: false
                )
                messageStore.sendMessage(travelCalculation: travel, message: newMessage)
                imageData?.removeAll()
            }
        } else {
            imageData?.removeAll()
            let newMessage = Message(
                senderId: AuthStore.shared.userUid,
                message: inputText,
                sendDate: Date().timeIntervalSince1970,
                isRead: false
            )
            messageStore.sendMessage(travelCalculation: travel, message: newMessage)
        }
    }
}

#Preview {
    NavigationStack {
        ChattingRoomView(travel: TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: []))
            .environmentObject(MessageStore())
            .environmentObject(TabBarVisivilyStore())
            .environmentObject(NotificationStore())
    }
}
