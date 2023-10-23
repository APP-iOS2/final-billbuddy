//
//  TravelDetailStroe.swift
//  BillBuddy
//
//  Created by 윤지호 on 10/17/23.
//

import SwiftUI
import Firebase
import FirebaseFirestoreSwift

final class TravelDetailStore: ObservableObject {
    @Published var travel: TravelCalculation
    @Published var isChangedTravel: Bool = false
    @Published var isFirstFetch: Bool = true

    var travelId : String = ""
    let dbRef = Firestore.firestore().collection(StoreCollection.travel.path)
    var listener: ListenerRegistration? = nil
    
    init(travel: TravelCalculation) {
        self.travel = travel
        self.travelId = travel.id
    }
    
    // 해당 여행에 updateDate 최신화
    func saveUpdateDate() {
        Task {
            try await Firestore.firestore().collection(StoreCollection.travel.path).document(self.travelId).setData(["updateContentDate":Date.now.timeIntervalSince1970], merge: true)
        }
        // TravelCaluration UpdateDate최신화
        // - save
        // - edit
        // - detele
    } 
    
    // 리스닝
    func listenTravelDate() {
        self.listener = dbRef.document(travelId).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            
            do {
                print("l => listener")
                guard let snapshot = querySnapshot else { return }
                print("2 => listener")
                let travel = try snapshot.data(as: TravelCalculation.self)
                print("3 => listener \(travel.members.count). \(travel.updateContentDate) => \(self.travel.updateContentDate)")
                // 여행 변경사항이 있을 시
                DispatchQueue.main.async {
                    if self.isFirstFetch {
                        self.travel = travel
                        return
                    }
                    if travel.updateContentDate > self.travel.updateContentDate {
                        // 30초뒤 다시 돌기시작 후 payment fetch하시겠습니까 버튼 활성화
                        self.travel = travel
                        self.isChangedTravel = true
                    } else {
                        self.isChangedTravel = false
                    }
                }
            } catch {
                print("decoding false")
            }
        }
    }
    
    func stoplistening() {
        listener?.remove()
        print("stop listening")
        isChangedTravel = false
    }
}
