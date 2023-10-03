//
//  TravelCalculationStore.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class TravelCalculationStore: ObservableObject {
    @Published var travelCalculations: [TravelCalculation] = []
    private let db = Firestore.firestore()
    
    func fetchTravelCalculation() {
        db.collection("TravelCalculation").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                if let error = error { print(error)}
                return
            }
            
            var fetchData = [TravelCalculation] ()
            for document in documents {
                do {
                    let temp = try document.data(as: TravelCalculation.self)
                    fetchData.append(temp)
                } catch {
                    print("Error fetching documents: \(error)")
                }
            }
            self.travelCalculations = fetchData
        }
    }
    
//    func addTravelCalulation(_ travel: TravelCalculation) {
//        do {
//            _ = try db.collection("TravelCalculation").addDocument(from: travel)
//        } catch {
//            print("Error adding travel: \(error)")
//        }
//    }
}
