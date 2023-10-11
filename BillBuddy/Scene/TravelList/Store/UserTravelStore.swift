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
    @Published var travels: [TravelCalculation] = []
//    private let db = Firestore.firestore()
    private let service = Firestore.firestore()

//    func fetchUserTravel() {
//        db.collection("User").document("id").collection("UserTravel").getDocuments { snapshot, error in
//            guard let documents = snapshot?.documents, error == nil else {
//                if let error = error { print(error)}
//                return
//            }
//            
//            var fetchData = [UserTravel] ()
//            for document in documents {
//                do {
//                    let temp = try document.data(as: UserTravel.self)
//                    fetchData.append(temp)
//                } catch {
//                    print("Error fetching documents: \(error)")
//                }
//            }
//            self.userTravels = fetchData
//        }
//    }
    
    func fetchTravelCalculation() {
        userTravels.removeAll()
        travels.removeAll()
        
        let userId = AuthStore.shared.userUid
        
        self.service.collection("User").document(userId).collection("UserTravel").getDocuments(completion: { snapshot, error in
            if let snapshot {
                for document in snapshot.documents {
                    //                       let docData: [String: Any] = document.data()
                    //                       let travelId: String = docData["travelId"] as? String ?? ""
                    do {
                        let snapshot = try document.data(as: UserTravel.self)
                        self.userTravels.append(snapshot)
                        Task {
                            let snapshot = try await self.service.collection("TravelCalculation").document(snapshot.travelId).getDocument()
                            let travel = try snapshot.data(as: TravelCalculation.self)
                            self.travels.append(travel)
                        }
                    } catch {
                        print(error)
                    }
                    
                    
                }
            }
            
        })
        
        
    }
    
    func addTravel(_ title: String, memberCount: Int, startDate: Date, endDate: Date) {
        var tempMembers: [TravelCalculation.Member] = []
        for index in 1...memberCount {
            let member = TravelCalculation.Member(name: "인원\(index)", advancePayment: 0, payment: 0)
            tempMembers.append(member)
        }
        let userId = AuthStore.shared.userUid
        
        let tempTravel = TravelCalculation(
            hostId: userId,
            travelTitle: title,
            managerId: userId,
            startDate: startDate.timeIntervalSince1970,
            endDate: endDate.timeIntervalSince1970,
            updateContentDate: 0,
            members: tempMembers
        )
        
        let userTravel = UserTravel(
            travelId: tempTravel.id ?? "",
            travelName: title,
            startDate: startDate.timeIntervalSince1970,
            endDate: endDate.timeIntervalSince1970
        )
        
        do {
            _ = try service.collection("TravelCalculation").addDocument(from: tempTravel.self)
            
            _ = try service.collection("User").document(userId).collection("UserTravel").addDocument(from: tempTravel)

//            _ = TravelCalculation(
//                hostId: travel.hostId,
//                travelTitle: travel.travelTitle,
//                managerId: travel.managerId,
//                startDate: travel.startDate,
//                endDate: travel.endDate,
//                updateContentDate: Date(),
//                members: []
//            )
            // travelCalculation.userTravelId = userTravelRef.documentID
        } catch {
            print("Error adding travel: \(error)")
        }
    }
}

