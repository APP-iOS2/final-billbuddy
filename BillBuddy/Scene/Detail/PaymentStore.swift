//
//  PaymentStore.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import Foundation
import FirebaseFirestore

class tempTravelCalculationStore: ObservableObject {
    @Published var travelCalculations: [TravelCalculation] = []
    
    let dbRef = Firestore.firestore().collection("TravelCalculation")
    
    func fetchAll() {
        dbRef.getDocuments { snapshot, error in
            if let snapshot {
                
                var tempTravelCalculations: [TravelCalculation] = []
                
                for doc in snapshot.documents {
                    
                    let id: String = doc.documentID
                    let docData = doc.data()
                    
                    let hostId: String = docData["hostId"] as? String ?? ""
                    let managerId: String = docData["managerId"] as? String ?? ""
                    let travelTitle: String = docData["travelTitle"] as? String ?? ""
                    
                    let startDate: Double = docData["startDate"] as? Double ?? 0
                    let endDate: Double = docData["endDate"] as? Double ?? 0
                    
                    let newTC = TravelCalculation(id: id, hostId: hostId, travelTitle: "신나는 유럽여행", managerId: managerId, startDate: startDate, endDate: endDate, updateContentDate: Date(), members: [])
                    
                    tempTravelCalculations.append(newTC)
                }
                
                DispatchQueue.main.async {
                    self.travelCalculations = tempTravelCalculations
                }
            }
        }
    }
}

class PaymentStore: ObservableObject {
    @Published var payments: [Payment] = []
    
    var travelCalculationId: String
    var dbRef: CollectionReference
    
    init(travelCalculationId: String) {
        self.travelCalculationId = travelCalculationId
        self.dbRef = Firestore.firestore().collection("TravelCalculation").document(travelCalculationId).collection("Payment")
    }
    
    func fetchAll() {
        dbRef.getDocuments { snapshot, error in
            if let snapshot {
                var tempPayment: [Payment] = []
                
                for doc in snapshot.documents {
//                    guard let newPayment = try? Firestore.Decoder().decode(Payment.self, from: doc.data()) else { continue }
//                    tempPayment.append(newPayment)
                    
                    let id: String = doc.documentID
                    let docData = doc.data()
                    
                    let typeString: String = docData["type"] as? String ?? ""
                    var type: Payment.PaymentType = .etc
                    
                    switch(typeString) {
                    case "교통":
                        type = .transportation
                    case "숙박":
                        type = .accommodation
                    case "관광":
                        type = .tourism
                    case "식비":
                        type = .food
                    default:
                        type = .etc
                    }
                    
                    let content: String = docData["content"] as? String ?? ""
                    let price: Int = docData["payment"] as? Int ?? 0
                    let paymentDate: Double = docData["paymentDate"] as? Double ?? 0
                    
                    let newPayment = Payment(id: id, type: type, content: content, payment: price, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: [], paymentDate: paymentDate)
                    
                    tempPayment.append(newPayment)
                }
                
                DispatchQueue.main.async {
                    self.payments = tempPayment
                }
                
            }
        }
    }
    
    func addPayment(newPayment: Payment) {
        try! dbRef.addDocument(from: newPayment.self)
        fetchAll()
    }
    
    func editPayment(payment: Payment) {
        if let id = payment.id {
            try? dbRef.document(id).setData(from: payment)
            fetchAll()
        }
    }
    
}
