//
//  MessageStore.swift
//  BillBuddy
//
//  Created by yuri rho on 2023/10/12.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import _PhotosUI_SwiftUI

final class MessageStore: ObservableObject {
    private let db = Firestore.firestore().collection("TravelCalculation")
    private let storage = Storage.storage().reference()
    ///불러온 메시지 쿼리 중 마지막 쿼리스냅샷
    var lastDoc: QueryDocumentSnapshot?
    @Published var messages: [Message] = []
    @Published var isAddedNewMessage: Bool = false
    
    /// 채팅 메세지 보내기
    func sendMessage(travelCalculation: TravelCalculation, message: Message) {
        do {
            try db.document(travelCalculation.id)
                .collection("Message").addDocument(from: message.self)
            updateLastMessage(travelCalculation: travelCalculation, message: message)
            //내가 메시지 보냈을때만 토글되도록 함 ( 자동 스크롤 )
            self.isAddedNewMessage.toggle()
        } catch {
            print("Failed send message: \(error)")
        }
    }
    
    /// firebase storage에 이미지 업로드 -> url 반환
    func getImagePath(item: PhotosPickerItem, travelCalculation: TravelCalculation) async -> String {
        
        let path = "chat/\(travelCalculation.id)/\(UUID().uuidString).jpeg"
        var urlString: String = ""
        
        if let data = try? await item.loadTransferable(type: Data.self) {
            do {
                try await storage.child(path).putDataAsync(data, metadata: nil)
                let imageURL = try await storage.child(path).downloadURL()
                urlString = imageURL.absoluteString
            } catch {
                print("Failed to upload image: \(error)")
            }
        }
        return urlString
    }
    
    /// 실시간 채팅 메세지 불러오기
    func fetchMessages(travelCalculation: TravelCalculation, count: Int) {
        //마지막 메시지 쿼리스냅샷이 있는지에 따라 나뉨 ( 없으면 최근 count만큼, 있으면 마지막 메시지가 보일때 count만큼 불러오는 상황 )
        if let lastDoc {
            // firestore message에 해당하는 여행 id 채팅 데이터 시간 순으로 불러오기
            db.document(travelCalculation.id)
            //descending: true -> 내림차순
                .collection("Message").order(by: "sendDate", descending: true)
                .limit(to: count)
                .start(afterDocument: lastDoc)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("Failed fetching messages: \(error)")
                        return
                    }
                    guard let querySnapshot = snapshot else {
                        print("No messages available")
                        return
                    }
                    //일단 주석처리해둠
                    // 실시간으로 추가되는 데이터가 있다면 isAddedNewMessage 변수 토글해서 scroll down
//                    querySnapshot.documentChanges.forEach { change in
//                        if change.type == .added {
//                            self.isAddedNewMessage.toggle()
//                        }
//                    }
                    //저장된 메세지 배열에 추가 - 출력
                    var newMessage: [Message] = []
                    for document in querySnapshot.documents {
                        do {
                            var item = try document.data(as: Message.self)
                            // sender id로 travelCalculation 멤버 정보 찾기
                            if let member = travelCalculation.members.first(where: { $0.userId == item.senderId }) {
                                item.userImage = member.userImage
                                item.userName = member.name
                            }
                            print(item)
                            newMessage.append(item)
                        } catch {
                            print("Failed to fetch chat message: \(error)")
                        }
                    }
                    //불러온 마지막 메시지 쿼리 스냅샷 저장
                    self.lastDoc = snapshot?.documents.last
                    self.messages.append(contentsOf: newMessage)
                }
        } else {
            // firestore message에 해당하는 여행 id 채팅 데이터 시간 순으로 불러오기
            db.document(travelCalculation.id)
            //descending: true -> 내림차순
                .collection("Message").order(by: "sendDate", descending: true)
                .limit(to: count)
                .addSnapshotListener { snapshot, error in
                    if let error = error {
                        print("Failed fetching messages: \(error)")
                        return
                    }
                    guard let querySnapshot = snapshot else {
                        print("No messages available")
                        return
                    }
                    //일단 주석처리해둠
                    // 실시간으로 추가되는 데이터가 있다면 isAddedNewMessage 변수 토글해서 scroll down
//                    querySnapshot.documentChanges.forEach { change in
//                        if change.type == .added {
//                            self.isAddedNewMessage.toggle()
//                        }
//                    }
                    //저장된 메세지 배열에 추가 - 출력
                    var newMessage: [Message] = []
                    for document in querySnapshot.documents {
                        do {
                            var item = try document.data(as: Message.self)
                            // sender id로 travelCalculation 멤버 정보 찾기
                            if let member = travelCalculation.members.first(where: { $0.userId == item.senderId }) {
                                item.userImage = member.userImage
                                item.userName = member.name
                            }
                            print(item)
                            newMessage.append(item)
                        } catch {
                            print("Failed to fetch chat message: \(error)")
                        }
                    }
                    //불러온 마지막 메시지 쿼리 스냅샷 저장
                    self.lastDoc = snapshot?.documents.last
                    self.messages = newMessage
                }
        }
        
    }
    
    /// 마지막 채팅 메세지 travelCalculation 에 업데이트
    private func updateLastMessage(travelCalculation: TravelCalculation, message: Message) {
        let data = [
            "lastMessage" : message.message,
            "lastMessageDate" : message.sendDate
        ] as [String : Any]
        Task {
            try await db.document(travelCalculation.id)
                .setData(data, merge: true)
        }
    }
    
    /// 채팅방별 이미지 불러오기
    func getChatRoomImages(travelCalculation: TravelCalculation) -> [String] {
        
        var images: [String] = []
        let path = "chat/\(travelCalculation.id)"
        
        storage.child(path).listAll { result, error in
            if let resultItem = result {
                for item in resultItem.items {
                    // 폴더 안 이미지 이름 담기
                    let storageLocation = String(describing: item)
                    
                    // url 가져오기
                    Storage.storage().reference(forURL: storageLocation).downloadURL { url, error in
                        if let error = error {
                            print("Failed to get url \(error)")
                        } else {
                            if let urlString = url?.absoluteString {
                                images.append(urlString)
                            }
                        }
                    }
                }
            } else {
                print("Failed to get images: \(String(describing: error))")
            }
        }
        return images
    }
}

