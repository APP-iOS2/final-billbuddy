//
//  PaymentStore.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import Foundation
import FirebaseFirestore

class TravelCalculationStore: ObservableObject {
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
                    
                    let newTC = TravelCalculation(id: id, hostId: hostId, managerId: managerId, startDate: Date(), endDate: Date(), updateContentDate: Date())
                    
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
                    
//                    let travelDate: String = docData["travelDate"] as? String ?? ""
                    
                    let newPayment = Payment(id: id, type: .transportation, content: "", payment: 10000, address: "", x: 0, y: 0, participants: [])
                    
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
    
}
