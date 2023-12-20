//
//  ChattingRoomView.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/04.
//

import SwiftUI
import PhotosUI
import Kingfisher

struct ChattingRoomView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userService: UserService
    @EnvironmentObject private var messageStore: MessageStore
    @EnvironmentObject private var notificationStore: NotificationStore
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    var travel: TravelCalculation
    ///pagination 적용 시 스크롤 올릴 때 몇개의 데이터를 가져올 지 갯수
    @State private var leadingCount: Int = 20
    @State private var inputText: String = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil
    @State private var imageData: Data?
    @State private var imagePath: String?
    @FocusState private var isKeyboardUp: Bool
    
    var body: some View {
        VStack {
            if messageStore.messages.isEmpty {
                emptyChat
            } else {
                if messageStore.travel.chatNotice != nil {
                    chattingItem
                        .padding(.top, 40)
                        .overlay(alignment: .top) {
                            noticeBar
                        }
                } else {
                    chattingItem
                }
            }
            chattingInputBar
        }
        .onAppear {
            tabBarVisivilyStore.hideTabBar()
            messageStore.getChatRoomData(travelCalculation: travel)
            //처음에 leadingCount 수만큼 메시지 데이터 불러옴
            messageStore.fetchMessages(travelCalculation: travel, count: leadingCount)
        }
        //해당 뷰에서 나갈 경우 비워주기
        .onDisappear {
            messageStore.messages.removeAll()
            messageStore.lastDoc = nil
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
        .onTapGesture {
            isKeyboardUp = false
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
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
    
    /// 채팅방 공지 바
    private var noticeBar: some View {
        NavigationLink {
            ChattingMenuView(travel: travel)
        } label: {
            HStack {
                Image(.announcementMegaphone)
                    .resizable()
                    .renderingMode(.template)
                    .foregroundColor(.myPrimary)
                    .frame(width: 24, height: 24)
                    .padding(.leading, 12)
                if let notice = messageStore.travel.chatNotice?.last?.notice {
                    Text(notice)
                        .font(Font.body04)
                        .foregroundColor(.systemBlack)
                        .padding(.vertical)
                }
                Spacer()
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray050)
            )
            .padding(.horizontal)
        }
    }
    
    /// 채팅 메세지 버블
    private var chattingItem: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                //스크롤 상하를 뒤집어놓아 이 부분이 최하단
                //내가 메시지를 보냈을 때 자동스크롤되도록 지정해놓은 부분
                HStack { }
                    .id("last")
                LazyVStack {
                    ForEach(messageStore.messages) { message in
                        if message.senderId == AuthStore.shared.userUid {
                            HStack {
                                Spacer()
                                VStack(alignment: .trailing) {
                                    HStack {
                                        VStack {
                                            Spacer()
                                            Text(message.sendDate.toFormattedChatDate())
                                                .font(Font.caption02)
                                                .foregroundColor(.gray500)
                                        }
                                        VStack(alignment: .trailing) {
                                            if let imageMessage = message.imageString {
                                                KFImage(URL(string: imageMessage))
                                                    .placeholder{
                                                        ProgressView()
                                                            .frame(width:120, height: 120)
                                                    }
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width:120, height: 120)
                                            }
                                            if let messageExist = message.message {
                                                Text(messageExist)
                                                    .font(Font.body04)
                                                    .foregroundColor(.systemBlack)
                                                    .padding(.horizontal)
                                                    .padding(.vertical, 10)
                                                    .background(Color.lightBlue300)
                                                    .cornerRadius(12)
                                                    .contextMenu {
                                                        Button {
                                                            Task {
                                                                await messageStore.updateChatRoomNotice(travelCalculation: travel, message: message)
                                                                notificationStore.sendNotification(members: travel.members, notification: UserNotification(type: .chatting, content: "\(travel.travelTitle)에 공지가 등록되었습니다.", contentId: "\(URLSchemeBase.scheme.rawValue)://travel?travelId=\(travel.id)", addDate: Date(), isChecked: false))
                                                            }
                                                        } label: {
                                                            HStack {
                                                                Image(.announcementMegaphone)
                                                                    .resizable()
                                                                    .frame(width: 24, height: 24) 
                                                                Text("공지등록")
                                                                    .font(.body01)
                                                            }
                                                        }
                                                    }
                                            }
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                            .onAppear {
                                //현재 보여지는 메시지의 인덱스를 가져옴
                                guard let index = messageStore.messages.firstIndex(where: {$0.id == message.id}) else {
                                    return
                                }
                                //스크롤해서 맨 위의 인덱스가 마지막 인덱스 인지 확인
                                if index == messageStore.messages.count - 1 {
                                    //                                    print("페이징 실행")
                                    messageStore.fetchMessages(travelCalculation: travel, count: leadingCount)
                                }
                            }
                        } else {
                            HStack {
                                VStack {
                                    ForEach(travel.members) { member in
                                        if member.userId == message.senderId {
                                            if member.userImage != "" {
                                                KFImage(URL(string: member.userImage))
                                                    .placeholder {
                                                        ProgressView()
                                                            .frame(width: 40, height: 40)
                                                    }
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                                    .clipShape(Circle())
                                            } else {
                                                Image(.defaultUser)
                                                    .resizable()
                                                    .frame(width: 40, height: 40)
                                            }
                                        }
                                    }
                                    Spacer()
                                }
                                VStack(alignment: .leading) {
                                    Text(message.userName ?? "이름없음")
                                        .font(Font.caption02)
                                        .foregroundColor(.systemBlack)
                                    HStack {
                                        VStack(alignment: .leading) {
                                            if let imageMessage = message.imageString {
                                                KFImage(URL(string: imageMessage))
                                                    .placeholder{
                                                        ProgressView()
                                                            .frame(width:120, height: 120)
                                                    }
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width:120, height: 120)
                                            }
                                            if let messageExist = message.message {
                                                Text(messageExist)
                                                    .font(Font.body04)
                                                    .foregroundColor(.systemBlack)
                                                    .padding(.horizontal)
                                                    .padding(.vertical, 10)
                                                    .background(Color.gray050)
                                                    .cornerRadius(12)
                                                    .contextMenu {
                                                        Button {
                                                            Task {
                                                                await messageStore.updateChatRoomNotice(travelCalculation: travel, message: message)
                                                                notificationStore.sendNotification(members: travel.members, notification: UserNotification(type: .chatting, content: "\(travel.travelTitle)에 공지가 등록되었습니다.", contentId: "\(URLSchemeBase.scheme.rawValue)://travel?travelId=\(travel.id)", addDate: Date(), isChecked: false))
                                                            }
                                                        } label: {
                                                            HStack {
                                                                Image(.announcementMegaphone)
                                                                    .resizable()
                                                                    .frame(width: 24, height: 24)
                                                                Text("공지등록")
                                                                    .font(.body01)
                                                            }
                                                        }
                                                    }
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
                            .onAppear {
                                //현재 보여지는 메시지의 인덱스를 가져옴
                                guard let index = messageStore.messages.firstIndex(where: {$0.id == message.id}) else {
                                    return
                                }
                                
                                //스크롤해서 맨 위의 인덱스가 마지막 인덱스 인지 확인
                                if index == messageStore.messages.count - 1 {
                                    messageStore.fetchMessages(travelCalculation: travel, count: leadingCount)
                                }
                            }
                        }
                    }
                    //메시지 위 아래를 바꿈 ( 상하반전 )
                    .rotationEffect(Angle(degrees: 180))
                    .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
                }
            }
            //스크롤 위 아래를 바꿈 ( 상하반전 )
            .rotationEffect(Angle(degrees: 180))
            .scaleEffect(x: -1.0, y: 1.0, anchor: .center)
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
                        .focused($isKeyboardUp)
                        .padding()
                }
                PhotosPicker(selection: $selectedPhoto, matching: .images) {
                    Image(.gallery)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray600)
                }
                Button {
                    if !inputText.isEmpty || selectedPhoto != nil {
                        sendChat()
                        PushNotificationManager.sendPushNotification(toTravel: travel, title: "\(travel.travelTitle) 채팅방", body: "읽지 않은 메세지를 확인해보세요.", senderToken: "senderToken")
//                        notificationStore.sendNotification(members: travel.members, notification: UserNotification(type: .chatting, content: "읽지 않은 메세지를 확인해보세요.", contentId: "\(URLSchemeBase.scheme.rawValue)://travel?travelId=\(travel.id)", addDate: Date(), isChecked: false))
                        selectedPhoto = nil
                        imageData?.removeAll()
                        inputText.removeAll()
                    }
                } label: {
                    if !inputText.isEmpty || selectedPhoto != nil {
                        Image(.sendMessage)
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.myPrimary)
                            .frame(width: 24, height: 24)
                    } else {
                        Image(.sendMessage)
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
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
                    imageString: imagePath,
                    sendDate: Date().timeIntervalSince1970,
                    isRead: false
                )
                messageStore.sendMessage(travelCalculation: travel, message: newMessage)
                await messageStore.updateChatRoomImages(travelCalculation: travel, message: newMessage)
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
