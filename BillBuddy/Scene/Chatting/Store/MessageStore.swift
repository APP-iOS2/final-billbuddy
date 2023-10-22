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
    @Published var messages: [Message] = []
    @Published var isAddedNewMessage: Bool = false
    
    /// 채팅 메세지 보내기
    func sendMessage(travelCalculation: TravelCalculation, message: Message) {
        do {
            try db.document(travelCalculation.id)
                .collection("Message").addDocument(from: message.self)
            updateLastMessage(travelCalculation: travelCalculation, message: message)
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
    func fetchMessages(travelCalculation: TravelCalculation) {
        // firestore message에 해당하는 여행 id 채팅 데이터 시간 순으로 불러오기
        db.document(travelCalculation.id)
            .collection("Message").order(by: "sendDate")
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Failed fetching messages: \(error)")
                    return
                }
                guard let querySnapshot = snapshot else {
                    print("No messages available")
                    return
                }
                // 실시간으로 추가되는 데이터가 있다면 isAddedNewMessage 변수 토글해서 scroll down
                querySnapshot.documentChanges.forEach { change in
                    if change.type == .added {
                        self.isAddedNewMessage.toggle()
                    }
                }
                //저장된 메세지 배열에 추가 - 출력
                var newMessage: [Message] = []
                for document in querySnapshot.documents {
                    do {
                        let item = try document.data(as: Message.self)
                        newMessage.append(item)
                    } catch {
                        print("Failed to fetch chat message: \(error)")
                    }
                }
                self.messages = newMessage
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

