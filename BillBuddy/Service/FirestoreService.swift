//
//  FirestoreService.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/3/23.
//

import Foundation
import FirebaseFirestore

final class FirestoreService {
    
    static let shared: FirestoreService = FirestoreService()
    
    private init() { }
    
    private let dbRef = Firestore.firestore()
    
    func fetchDocument<T: Codable>(collection: StoreCollection, documentId: String, data: T) async throws -> T {
        do {
            let snapshot = try await dbRef.collection(collection.rawValue).document(documentId).getDocument()
            let data = try snapshot.data(as: T.self)
            return data
        } catch {
            print("false fetchDocument \(collection.rawValue)")
            throw error
        }
    }
    
    func saveDocument<T: Codable>(collection: StoreCollection, documentId: String, data: T) async throws {
        do {
            try dbRef.collection(collection.rawValue).document(documentId).setData(from: data.self)
        } catch {
            print("false saveDocument \(collection), \(error)")
            throw error
        }
    }
}
