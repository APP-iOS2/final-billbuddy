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
                    
                    let newTC = TravelCalculation(id: id, hostId: hostId, travelTitle: travelTitle, managerId: managerId, startDate: startDate, endDate: endDate, updateContentDate: Date(), members: [])
                    
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
        payments.removeAll()
        
        dbRef.getDocuments { snapshot, error in
            if let snapshot {
                var tempPayment: [Payment] = []
                
                for doc in snapshot.documents {
                    /// 아래의 코드는 struct가 확정이 나면 쓸것!
//                    guard let newPayment = try? Firestore.Decoder().decode(Payment.self, from: doc.data()) else { continue }
//                    tempPayment.append(newPayment)
                    
                    let id: String = doc.documentID
                    let docData = doc.data()
                    
                    let typeString: String = docData["type"] as? String ?? ""
                    var type: Payment.PaymentType = Payment.PaymentType.fromRawString(typeString)
                    
                    let content: String = docData["content"] as? String ?? ""
                    let price: Int = docData["payment"] as? Int ?? 0
                    let paymentDate: Double = docData["paymentDate"] as? Double ?? 0
                    
                    let participants: [Payment.Participant] = docData["participants"] as? [Payment.Participant] ?? []
                    print(participants)
                    
                    let newPayment = Payment(id: id, type: type, content: content, payment: price, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: participants, paymentDate: paymentDate)
                    
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
    
    func deletePayment(idx: IndexSet) {
        for i in idx {
            if let id = payments[i].id {
                dbRef.document(id).delete()
            }
        }
        /// fetchAll 해주니까 순간적으로 사라졌다가 다 다시 불러오는게 로딩이 느려서
        /// payments 자체에서 삭제하도록 해줌
        payments.remove(atOffsets: idx)
    }
    
}
