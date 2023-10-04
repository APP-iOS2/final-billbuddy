//
//  UserTravelStore.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserTravelStore: ObservableObject {
    @Published var userTravels: [UserTravel] = []
    private let db = Firestore.firestore()
    
    func fetchUserTravel() {
        db.collection("User").document("id").collection("UserTravel").getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                if let error = error { print(error)}
                return
            }
            
            var fetchData = [UserTravel] ()
            for document in documents {
                do {
                    let temp = try document.data(as: UserTravel.self)
                    fetchData.append(temp)
                } catch {
                    print("Error fetching documents: \(error)")
                }
            }
            self.userTravels = fetchData
        }
    }
    
    func addTravel(_ travel: TravelCalculation) {
        
        do {
            _ = try db.collection("TravelCalculation").addDocument(from: travel)
            
            _ = try db.collection("User").document("id").collection("UserTravel").addDocument(from: travel)
            
            _ = TravelCalculation(
                hostId: travel.hostId,
                travelTitle: travel.travelTitle,
                managerId: travel.managerId,
                startDate: travel.startDate,
                endDate: travel.endDate,
                updateContentDate: Date(),
                members: []
            )
            
            
//            travelCalculation.userTravelId = userTravelRef.documentID
            
            
        } catch {
            print("Error adding travel: \(error)")
        }
    }
}

