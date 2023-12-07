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
    @Published var travel: TravelCalculation = TravelCalculation.sampletravel {
        didSet {
            print("=> travel1")
        }
    }
    @Published var isChangedTravel: Bool = false {
        didSet {
            print("=> travel2")
        }
    }
    @Published var isFetchedFirst: Bool = false {
        didSet {
            print("=> travel3")
        }
    }

    var travelId: String = ""
    let dbRef = Firestore.firestore().collection(StoreCollection.travel.path)
    var listener: ListenerRegistration? = nil
    
    @MainActor
    func setTravel(_ travel: TravelCalculation) {
        self.travel = travel
        self.travelId = travel.id
        checkAndResaveToken()
        isFetchedFirst = true
        listenTravelDate()
    }
    
    private func checkAndResaveToken() {
        guard let index = travel.members.firstIndex(where: { $0.userId == AuthStore.shared.userUid }) else { return }
        if travel.members[index].reciverToken != UserService.shared.reciverToken {
            travel.members[index].reciverToken = UserService.shared.reciverToken
            travel.updateContentDate = Date.now.timeIntervalSince1970
            do {
                try Firestore.firestore().collection(StoreCollection.travel.path).document(self.travelId).setData(from: travel.self)
            } catch {
                print("resave token false")
            }
        }
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
                guard let snapshot = querySnapshot else { return }
                let travel = try snapshot.data(as: TravelCalculation.self)
                // 여행 변경사항이 있을 시
                DispatchQueue.main.async {
                    if self.isFetchedFirst == false {
                        self.travel = travel
                        return
                    }
                    // 맴버가 바뀌었을시엔 바로 바꿔줌
                    if travel.members != self.travel.members {
                        self.travel = travel
                        
                        // updateContentDate가 변경됐을 시엔
                    } else if travel.updateContentDate > self.travel.updateContentDate {
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
        isFetchedFirst = false
    }
}
