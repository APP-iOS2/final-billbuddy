//
//  PaymentStore.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/25.
//

import Foundation
import FirebaseFirestore

final class PaymentStore: ObservableObject {
    @Published var payments: [Payment] = []
    @Published var filteredPayments: [Payment] = []
    
    var members: [TravelCalculation.Member]
    var travelCalculationId: String
    var dbRef: CollectionReference
    
    var sumAllPayment: Int = 0
    
    init(travel: TravelCalculation) {
        self.travelCalculationId = travel.id
        self.members = travel.members
        self.dbRef = Firestore.firestore().collection("TravelCalculation").document(travelCalculationId).collection("Payment")
    }
    
    @MainActor
    func fetchAll() async {
        payments.removeAll()
        sumAllPayment = 0
        
        do {
            var tempPayment: [Payment] = []
            let snapshot = try await dbRef.order(by: "paymentDate").getDocuments()
            for document in snapshot.documents {
                let newPayment = try document.data(as: Payment.self)
                tempPayment.append(newPayment)
            }
            
            self.payments = tempPayment
            self.filteredPayments = tempPayment
            
        } catch {
            print("payment fetch false \(error)")
        }
    }
    
    func resetFilter() {
        filteredPayments = payments
    }
    
    func filterDate(date: Double) {
        filteredPayments = payments.filter({ (payment: Payment) in
            return payment.paymentDate.todayRange() == date.todayRange()
        })
    }
    
    func filterDateCategory(date: Double, category: Payment.PaymentType) {
        filteredPayments = payments.filter({ (payment: Payment) in
            return payment.paymentDate.todayRange() == date.todayRange() && payment.type == category
        })
    }
    
    func filterCategory(category: Payment.PaymentType) {
    
        filteredPayments = payments.filter({ (payment: Payment) in
            return payment.type == category
        })
    }
    
    func addPayment(newPayment: Payment) {
        try! dbRef.addDocument(from: newPayment.self)
        Task {
            await fetchAll()
        }
    }
    
    func editPayment(payment: Payment) {
        if let id = payment.id {
            try? dbRef.document(id).setData(from: payment)
            
            Task {
                //FIXME: fetchAll -> fetch 안하도록 ..
                await fetchAll()
            }
            
//            if let index = payments.firstIndex(where: { $0.id == payment.id }) {
//                payments[index] = payment
//            }
        }
    }
    
    func deletePayment(payment: Payment) {
        if let id = payment.id {
            dbRef.document(id).delete()
            
            if let index = payments.firstIndex(where: { $0.id == payment.id }) {
                payments.remove(at: index)
            }
            
            Task {
                //FIXME: fetchAll -> fetch 안하도록 .. 삭제가 안되는 문제 o
                await fetchAll()
            }
        }
    }
}
