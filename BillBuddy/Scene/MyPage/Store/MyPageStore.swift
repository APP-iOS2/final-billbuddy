//
//  MyPageStore.swift
//  BillBuddy
//
//  Created by 박지현 on 10/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import _PhotosUI_SwiftUI


final class MyPageStore: ObservableObject {
    
    private let storage = Storage.storage().reference()
    static let shared = MyPageStore()
    
    
    func isValidBankName(_ bankName: String) -> Bool {
        return (bankName.count >= 2) || (bankName == "")
    }
    
    func isValidAccountNumber(_ accountNumber: String) -> Bool {
        return (accountNumber.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil) || (accountNumber == "")
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = try! NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
        return (emailRegex.firstMatch(in: email, options: [], range: NSRange(location: 0, length: email.count)) != nil) || (email == "")
    }
    
    func saveImage(data: Data) async throws -> (path: String, name: String) {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "user/\(UUID().uuidString).jpeg"
        let returnedMetaData = try await storage.child(path).putDataAsync(data, metadata: meta)

        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        return (returnedPath, returnedName)
    }
    
    func saveProfileImage(item: PhotosPickerItem) {
        Task {
            var urlString: String = ""
            
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
    
            let (path, name) = try await MyPageStore.shared.saveImage(data: data)
            let imageURL = try await storage.child(path).downloadURL()
            urlString = imageURL.absoluteString
            
            print("Success!")
            print (path)
            print (name)
            try await UserService.shared.profileUpdate(name: urlString)
        }
    }
    
    func getData(name: String) async throws -> Data {
        try await storage.child("user").data(maxSize: 3 * 1024 * 1024)
    }
}
