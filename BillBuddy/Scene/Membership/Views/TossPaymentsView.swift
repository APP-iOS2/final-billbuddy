//
//  TossPaymentsView.swift
//  BillBuddy
//
//  Created by SIKim on 10/12/23.
//

import SwiftUI
import TossPayments

struct TossPaymentsView: View {
    @EnvironmentObject private var userService: UserService
    @Environment(\.dismiss) private var dismiss
    @StateObject private var tossPayments: TossPaymentsStore = TossPaymentsStore()
    @State private var isShowingSuccessAlert: Bool = false
    @State private var isShowingFailAlert: Bool = false
    @Binding var isShowingFullScreen: Bool
    var body: some View {
        NavigationStack {
            ScrollView {
                PaymentMethodWidgetView(widget: tossPayments.widget, amount: PaymentMethodWidget.Amount(value: 1100))
                AgreementWidgetView(widget: tossPayments.widget)
            }
            VStack {
                Button {
                    tossPayments.requestPayment(info: DefaultWidgetPaymentInfo(orderId: "userId", orderName: "BillBuddy Premium"))
                } label: {
                    Text("결제하기")
                        .font(.title05)
                        .frame(maxWidth: .infinity, maxHeight: 83)
                        .background(Color.primary2)
                        .foregroundColor(.white)
                }
                .alert("결제 완료", isPresented: $isShowingSuccessAlert) {
                    Button("확인") {
                        //
                    }
                } message: {
                    Text("\(tossPayments.processSuccess?.orderId ?? "")")
                }
                .alert("결제 실패", isPresented: $isShowingFailAlert) {
                    Button("확인") {
                        userService.currentUser?.isPremium = true
                        userService.currentUser?.premiumDueDate = Date() + 86400 * 30
                        Task {
                            try await userService.updateUserPremium()
                        }
                        dismiss()
                    }
                } message: {
                    Text("\(tossPayments.processFail?.errorMessage ?? "")")
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction, content: {
                    Button("닫기") {
                        isShowingFullScreen = false
                    }
                })
            }
            .onReceive(tossPayments.$processSuccess.compactMap { $0 }, perform: { _ in
                isShowingSuccessAlert = true
            })
            .onReceive(tossPayments.$processFail.compactMap { $0 }, perform: { _ in
                isShowingFailAlert = true
            })
        }
    }
}

#Preview {
    NavigationStack {
        TossPaymentsView(isShowingFullScreen: .constant(true))
    }
}
