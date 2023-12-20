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
    @Published var isFetchedFirst: Bool = false
    @Published var isFetching: Bool = false
        
    private let service = Firestore.firestore()
    
    var travelCount: Int {
        travels.isEmpty ? 2 : travels.count
    }
    
    init() {
        Task { await fetchFirstInit() }
    }
    
    @MainActor
    func fetchFirstInit() {
        if AuthStore.shared.userUid.isEmpty == false && isFetchedFirst == false {
            fetchTravelCalculation()
        }
    }
    
    @MainActor
    func fetchTravelCalculation() {
        let userId = AuthStore.shared.userUid
        
        Task {
            self.isFetching = true
            userTravels.removeAll()
            do {
                let snapshot = try await
                self.service.collection("User").document (userId).collection("UserTravel").getDocuments()
                var travelIds: Set<String> = []
                for document in snapshot.documents {
                    do {
                        let snapshot = try document.data(as: UserTravel.self)
                        userTravels.append(snapshot)
                        travelIds.insert(snapshot.travelId)
                    } catch {
                        print(error)
                    }
                }
                
                var newTravels: [TravelCalculation] = []
                for travelId in travelIds {
                    do {
                        let snapshotData = try await self.service.collection("TravelCalculation").document(travelId).getDocument()
                        let travel = try snapshotData.data(as: TravelCalculation.self)
                        newTravels.append(travel)
                    } catch {
                        print(error)
                    }
                }
                travels.removeAll()
                
                self.travels = newTravels
                self.isFetching = false
                self.isFetchedFirst = true
            } catch {
                print ("Failed fetch travel list: \(error)")
            }
        }
    }
    
    func getTravel(id: String) -> TravelCalculation {
        guard let travelIndex = travels.firstIndex(where: { $0.id == id }) else { return TravelCalculation.sampletravel }
        return travels[travelIndex]
    }
    
    func addTravel(_ title: String, memberCount: Int, startDate: Date, endDate: Date) {
        var tempMembers: [TravelCalculation.Member] = []
        if memberCount > 0 {
            for index in 1...memberCount {
                if index == 1 {
                    guard let user = UserService.shared.currentUser else { return }
                    let member = TravelCalculation.Member(userId: user.id, name: user.name, isExcluded: false, isInvited: true, advancePayment: 0, payment: 0, userImage: user.userImage ?? "",bankName: user.bankName, bankAccountNum: user.bankAccountNum, reciverToken: user.reciverToken)
                    tempMembers.append(member)
                } else {
                    let member = TravelCalculation.Member(name: "인원\(index)", advancePayment: 0, payment: 0)
                    tempMembers.append(member)
                }
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
            travelId: tempTravel.id
        )
        
        do {
            try service.collection("TravelCalculation").document(tempTravel.id).setData(from: tempTravel)
            try service.collection("User").document(userId).collection("UserTravel").addDocument(from: userTravel)
            Task { await fetchTravelCalculation() }
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
    
    func setTravelDate(travelId: String, startDate: Date, endDate: Date) {
        guard let index = travels.firstIndex(where: { $0.id == travelId }) else { return }
        travels[index].startDate = startDate.timeIntervalSince1970
        travels[index].endDate = endDate.timeIntervalSince1970

    }
    
    func setTravelMember(travelId: String, members: [TravelCalculation.Member]) {
        guard let index = travels.firstIndex(where: { $0.id == travelId }) else { return }
        travels[index].members = members
    }
    
    @MainActor
    func leaveTravel(travel: TravelCalculation) {
        let userId = AuthStore.shared.userUid
        let travelId = travel.id
        guard let userTravelArrayIndex = userTravels.firstIndex(where: { $0.travelId == travelId }) else { return }
        let userTravel = userTravels[userTravelArrayIndex]
        
        var members = travel.members
        guard let memberIndex = members.firstIndex(where: { $0.userId == userId }) else { return }
        members[memberIndex].isExcluded = true
        members[memberIndex].userId = nil
        
        Task {
            do {
                try await Firestore.firestore()
                    .collection("User").document(userId)
                    .collection("UserTravel").document(userTravel.id ?? "").delete()
                
                if members.filter({ $0.userId != nil }).isEmpty {
                    try await Firestore.firestore().collection(StoreCollection.travel.path).document(travelId).delete()
                } else {
                    var updatedTravel = travel
                    updatedTravel.members = members
                    try Firestore.firestore().collection(StoreCollection.travel.path).document(travelId)
                        .setData(from: updatedTravel.self, merge: true)
                }
                self.fetchTravelCalculation()
            } catch {
                print(error)
            }
        }
    }
    
    @MainActor
    func resetStore() {
        for travel in travels {
            leaveTravel(travel: travel)
            print("resetStore 진입")
        }
//        userTravels = []
//        travels = []
        isFetchedFirst = false
    }
}
