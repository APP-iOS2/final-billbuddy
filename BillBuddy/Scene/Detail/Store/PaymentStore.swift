//
//  PaymentStore.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import Foundation
import FirebaseFirestore

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
                    let type: Payment.PaymentType = Payment.PaymentType.fromRawString(typeString)
                    
                    let content: String = docData["content"] as? String ?? ""
                    let price: Int = docData["payment"] as? Int ?? 0
                    let paymentDate: Double = docData["paymentDate"] as? Double ?? 0
                    
                    let addressDict = docData["address"] as? [String: Any] ?? ["address": "", "latitude": 0, "longitude": 0]
                    let address: Payment.Address = Payment.Address(address: addressDict["address"] as? String ?? "", latitude: addressDict["latitude"] as? Double ?? 0, longitude: addressDict["longitude"] as? Double ?? 0)
                    
                    let participantsDict = docData["participants"] as? [[String: Any]] ?? []
                    var participants: [Payment.Participant] = []
                    for p in participantsDict {
                        let memberId = p["memberId"] as? String ?? ""
                        let payment = p["payment"] as? Int ?? 0
                        
                        participants.append(Payment.Participant(memberId: memberId, payment: payment))
                    }
                    
                    let newPayment = Payment(id: id, type: type, content: content, payment: price, address: address, participants: participants, paymentDate: paymentDate)
                    
                    tempPayment.append(newPayment)
                }
                
                DispatchQueue.main.async {
                    self.payments = tempPayment
                }
                
            }
        }
    }
    
    func fetchDate(date: Double) {
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
                    
                    let paymentDate: Double = docData["paymentDate"] as? Double ?? 0
                    
                    if (date.todayRange() ~= paymentDate) {
                        
                        let typeString: String = docData["type"] as? String ?? ""
                        let type: Payment.PaymentType = Payment.PaymentType.fromRawString(typeString)
                        
                        let content: String = docData["content"] as? String ?? ""
                        let price: Int = docData["payment"] as? Int ?? 0
                        
                        let addressDict = docData["address"] as? [String: Any] ?? ["address": "", "latitude": 0, "longitude": 0]
                        let address: Payment.Address = Payment.Address(address: addressDict["address"] as? String ?? "", latitude: addressDict["latitude"] as? Double ?? 0, longitude: addressDict["longitude"] as? Double ?? 0)
                        
                        let participantsDict = docData["participants"] as? [[String: Any]] ?? []
                        var participants: [Payment.Participant] = []
                        for p in participantsDict {
                            let memberId = p["memberId"] as? String ?? ""
                            let payment = p["payment"] as? Int ?? 0
                            
                            participants.append(Payment.Participant(memberId: memberId, payment: payment))
                        }
                        
                        let newPayment = Payment(id: id, type: type, content: content, payment: price, address: address, participants: participants, paymentDate: paymentDate)
                        
                        tempPayment.append(newPayment)
                    }
                }
                
                DispatchQueue.main.async {
                    self.payments = tempPayment
                }
                
            }
        }
    }
    
    func fetchDateCategory(date: Double, category: Payment.PaymentType) {
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
                    
                    let paymentDate: Double = docData["paymentDate"] as? Double ?? 0
                    let typeString: String = docData["type"] as? String ?? ""
                    let type: Payment.PaymentType = Payment.PaymentType.fromRawString(typeString)

                    if type == category && (date.todayRange() ~= paymentDate) {
                        
                        let typeString: String = docData["type"] as? String ?? ""
                        let type: Payment.PaymentType = Payment.PaymentType.fromRawString(typeString)
                        
                        let content: String = docData["content"] as? String ?? ""
                        let price: Int = docData["payment"] as? Int ?? 0
                        
                        let addressDict = docData["address"] as? [String: Any] ?? ["address": "", "latitude": 0, "longitude": 0]
                        let address: Payment.Address = Payment.Address(address: addressDict["address"] as? String ?? "", latitude: addressDict["latitude"] as? Double ?? 0, longitude: addressDict["longitude"] as? Double ?? 0)
                        
                        let participantsDict = docData["participants"] as? [[String: Any]] ?? []
                        var participants: [Payment.Participant] = []
                        for p in participantsDict {
                            let memberId = p["memberId"] as? String ?? ""
                            let payment = p["payment"] as? Int ?? 0
                            
                            participants.append(Payment.Participant(memberId: memberId, payment: payment))
                        }
                        
                        let newPayment = Payment(id: id, type: type, content: content, payment: price, address: address, participants: participants, paymentDate: paymentDate)
                        
                        tempPayment.append(newPayment)
                    }
                }
                
                DispatchQueue.main.async {
                    self.payments = tempPayment
                }
                
            }
        }
    }
    
    func fetchCategory(category: Payment.PaymentType) {
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
                    let type: Payment.PaymentType = Payment.PaymentType.fromRawString(typeString)
                    
                    if type == category {
                        let paymentDate: Double = docData["paymentDate"] as? Double ?? 0
                        
                        let typeString: String = docData["type"] as? String ?? ""
                        let type: Payment.PaymentType = Payment.PaymentType.fromRawString(typeString)
                        
                        let content: String = docData["content"] as? String ?? ""
                        let price: Int = docData["payment"] as? Int ?? 0
                        
                        let addressDict = docData["address"] as? [String: Any] ?? ["address": "", "latitude": 0, "longitude": 0]
                        let address: Payment.Address = Payment.Address(address: addressDict["address"] as? String ?? "", latitude: addressDict["latitude"] as? Double ?? 0, longitude: addressDict["longitude"] as? Double ?? 0)
                        
                        let participantsDict = docData["participants"] as? [[String: Any]] ?? []
                        var participants: [Payment.Participant] = []
                        for p in participantsDict {
                            let memberId = p["memberId"] as? String ?? ""
                            let payment = p["payment"] as? Int ?? 0
                            
                            participants.append(Payment.Participant(memberId: memberId, payment: payment))
                        }
                        
                        let newPayment = Payment(id: id, type: type, content: content, payment: price, address: address, participants: participants, paymentDate: paymentDate)
                        
                        tempPayment.append(newPayment)
                    }
                }
                
                DispatchQueue.main.async {
                    self.payments = tempPayment
                }
                
            }
        }
    }
    
    func fetchAPayment(payment: Payment) {
//        payments.firstIndex(of: payment)
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
    
    func deletePayment(payment: Payment) {
        if let id = payment.id {
            dbRef.document(id).delete()
            
            /// fetchAll 해주니까 순간적으로 사라졌다가 다 다시 불러오는게 로딩이 느려서
            /// payments 자체에서 삭제하도록 해줌
            if let index = payments.firstIndex(where: { $0.id == payment.id }) {
                payments.remove(at: index)
            }

            
        }
        
    }
}
