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
    private let service = Firestore.firestore()
    
    @MainActor
    func fetchTravelCalculation() {
        userTravels.removeAll()
        travels.removeAll()
        
        let userId = AuthStore.shared.userUid
        
        Task {
            do {
                let snapshot = try await
                self.service.collection("User").document (userId).collection("UserTravel").getDocuments()
                var newTravels: [TravelCalculation] = []
                for document in snapshot.documents {
                    do {
                        let snapshot = try document.data(as: UserTravel.self)
                        self.userTravels.append(snapshot)
                        
                        let snapshotData = try await self.service.collection("TravelCalculation").document(snapshot.travelId).getDocument()
                        let travel = try snapshotData.data(as: TravelCalculation.self)
                        newTravels.append(travel)
                    } catch {
                        print(error)
                    }
                }
                self.travels = newTravels
            } catch {
                print ("Failed fetch travel list: \(error)")
            }
        }
    }
    
    func addTravel(_ title: String, memberCount: Int, startDate: Date, endDate: Date) {
        var tempMembers: [TravelCalculation.Member] = []
        if memberCount > 0 {
            for index in 1...memberCount {
                let member = TravelCalculation.Member(name: "인원\(index)", advancePayment: 0, payment: 0)
                tempMembers.append(member)
                
            }
        }
        let userId = AuthStore.shared.userUid
        
        let tempTravel = TravelCalculation(
            hostId: userId,
            travelTitle: title,
            managerId: userId,
            startDate: startDate.timeIntervalSince1970.timeTo00_00_00(),
            endDate: endDate.timeIntervalSince1970.timeTo11_59_59(),
            updateContentDate: 0,
            isPaymentSettled: false,
            members: tempMembers
        )
        
        let userTravel = UserTravel(
            travelId: tempTravel.id,
            travelName: title,
            startDate: startDate.timeIntervalSince1970.timeTo00_00_00(),
            endDate: endDate.timeIntervalSince1970.timeTo11_59_59()
        )
        
        do {
            try service.collection("TravelCalculation").document(tempTravel.id).setData(from: tempTravel)
            
            _ = try service.collection("User").document(userId).collection("UserTravel").addDocument(from: userTravel)
            
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
    
    
    
    func addPayment(travelCalculation: TravelCalculation, payment: Payment) {
        try! service.collection("TravelCalculation").document(travelCalculation.id).collection("Payment").addDocument(from: payment.self)
    }
    
    func findTravelCalculation(userTravel: UserTravel) -> TravelCalculation? {
        
        return travels.first { travel in
            userTravel.travelId == travel.id
        }
    }
}

