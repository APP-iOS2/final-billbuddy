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
    @Published var travel: TravelCalculation = TravelCalculation.sampletravel
    @Published var isChangedTravel: Bool = false
    @Published var isFirstFetch: Bool = true
    
    var travelTump: TravelCalculation
    var travelId: String
    let dbRef = Firestore.firestore().collection(StoreCollection.travel.path)
    var listener: ListenerRegistration? = nil
    
    init(travel: TravelCalculation) {
        self.travelTump = travel
        self.travelId = travel.id
    }
    
    @MainActor
    func setTravel() {
        self.travel = travelTump
    }
    
    @MainActor
    func setTravel(travel: TravelCalculation) {
        self.travelTump = travel
        self.travel = travel
        self.travelId = travel.id
    }
    
    @MainActor
    func setTravelDates(_ startDate: Date, _ endDate: Date) {
        if travel.isPaymentSettled == true { return }
        self.travel.startDate = startDate.timeIntervalSince1970
        self.travel.endDate = endDate.timeIntervalSince1970
    }
    
    func fetchTravel() {
        if travel.isPaymentSettled == true { return }
        Task {
            do {
                let snapshot = try await dbRef.document(travelId).getDocument()
                let travel = try snapshot.data(as: TravelCalculation.self)
                DispatchQueue.main.async {
                    self.travel = travel
                }
            } catch {
                print("false fetch travel - \(error)")
            }
        }
    }
    
    func checkAndResaveToken() {
        guard let index = travelTump.members.firstIndex(where: { $0.userId == AuthStore.shared.userUid }) else { return }
        if travelTump.members[index].reciverToken != UserService.shared.reciverToken {
            travelTump.members[index].reciverToken = UserService.shared.reciverToken
            travelTump.updateContentDate = Date.now.timeIntervalSince1970
            do {
                try Firestore.firestore().collection(StoreCollection.travel.path).document(self.travelId).setData(from: travel.self)
            } catch {
                print("resave token false")
            }
        }
    }
    
    // 해당 여행에 updateDate 최신화
    func saveUpdateDate() {
        if travel.isPaymentSettled == true { return }
        Task {
            try await Firestore.firestore().collection(StoreCollection.travel.path).document(self.travelId).setData(["updateContentDate":Date.now.timeIntervalSince1970], merge: true)
        }
        // TravelCaluration UpdateDate최신화
        // - save
        // - edit
        // - detele
    }
    
    /// DetailView 리스닝
    func listenTravelDate() {
        if travel.isPaymentSettled == true { return }
        self.listener = dbRef.document(travelId).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            print("listenTravelDate1")
            do {
                guard let snapshot = querySnapshot else { return }
                let travel = try snapshot.data(as: TravelCalculation.self)
                // 여행 변경사항이 있을 시
                DispatchQueue.main.async {
                    if self.isFirstFetch {
                        self.travel = travel
                        return
                    }
                    // 맴버가 바뀌었을시엔 바로 바꿔줌
                    if travel.members != self.travel.members {
                        self.travel = travel
                    }
                    // updateContentDate가 변경됐을 시엔
                    if travel.updateContentDate > self.travel.updateContentDate {
                        self.travel = travel
                        self.isChangedTravel = true
                    } else {
                        self.isChangedTravel = false
                    }
                    
                }
            } catch {
                print("travel Detail - decoding false")
            }
        }
    }
    
    func setIsPaymentSettled(isSettle: Bool) {
        dbRef.document(travelId).setData(
            [
                "isPaymentSettled": isSettle
            ], merge: true)
        DispatchQueue.main.async {
            self.travel.isPaymentSettled = isSettle
        }
    }

    
    /// 인원관리뷰 리스닝
    func listenTravelDate(callback: @escaping (TravelCalculation) -> Void) {
        if travel.isPaymentSettled == true { return }
        self.listener = dbRef.document(travelId).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error retreiving collection: \(error)")
            }
            print("listenTravelDate2")
            do {
                guard let snapshot = querySnapshot else { return }
                let travel = try snapshot.data(as: TravelCalculation.self)
                // 여행 변경사항이 있을 시
                DispatchQueue.main.async {
                    if self.isFirstFetch {
                        self.travel = travel
                    }
                    // 맴버가 바뀌었을시엔 바로 바꿔줌
                    if travel.members != self.travel.members {
                        self.travel = travel
                        callback(travel)
                    }
                    // updateContentDate가 변경됐을 시엔
                    if travel.updateContentDate > self.travel.updateContentDate {
                        self.travel = travel
                        callback(travel)
                        self.isChangedTravel = true
                    } else {
                        self.isChangedTravel = false
                    }
                    
                }
            } catch {
                print("travel Detail - decoding false")
            }
        }
    }
    
    func stoplistening() {
        listener?.remove()
        print("stop listening")
        isChangedTravel = false
    }
}
