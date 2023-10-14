//
//  TossPaymentsStore.swift
//  BillBuddy
//
//  Created by SIKim on 10/12/23.
//

import Foundation
import TossPayments

final class TossPaymentsStore: ObservableObject, TossPaymentsDelegate {
    @Published var processSuccess: TossPaymentsResult.Success? = nil
    @Published var processFail: TossPaymentsResult.Fail? = nil
    
    let widget: PaymentWidget = PaymentWidget(clientKey: "test_ck_BX7zk2yd8yPvKB2dpzBrx9POLqKQ", customerKey: UUID().uuidString)
    
    init() {
        widget.delegate = self
    }
    func requestPayment(info: WidgetPaymentInfo) {
        widget.requestPayment(info: info)
    }
    
    
    func handleSuccessResult(_ success: TossPaymentsResult.Success) {
        processSuccess = success
    }
    
    func handleFailResult(_ fail: TossPaymentsResult.Fail) {
        processFail = fail
    }
}
