//
//  SpendingListView.swift
//  BillBuddy
//
//  Created by 김유진 on 2023/09/27.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct SpendingListView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var settlementExpensesStore: SettlementExpensesStore
    
    @State private var isPresentedCustomAlert: Bool = false
    @State private var selectedType: String = ""
    @State private var paymentsOfType: [Payment] = []
    let entryViewtype: EntryViewType
    let travelId: String?
    
    private let allCase = SpendingType.allCases
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Divider()
                Rectangle()
                    .foregroundStyle(Color.gray100)
            }
            VStack(spacing: 0) {
                ForEach(allCase, id: \.self) { spendingType in
                    spendingButton(type: spendingType)
                        .padding(.bottom, 16)
                }
            }
            .padding(.top, 24)
        }
        .modifier(
            SpendingModifier(
                isPresented: $isPresentedCustomAlert,
                name: $selectedType,
                spendingList: $paymentsOfType
            )
        )
        .ignoresSafeArea(.all, edges: .bottom)
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(.arrowBack)
                        .resizable()
                        .frame(width: 24, height: 24)
                })
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    NotificationListView()
                } label: {
                    Image("ringing-bell-notification-3")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("자세히보기")
                    .font(.title05)
            }
        }
    }
    
    func spendingButton(type: SpendingType) -> some View {
        Button {
            self.selectedType = type.string
            self.paymentsOfType = settlementExpensesStore.getPaymentsOfType(type: type)
            isPresentedCustomAlert = true
        } label: {
            HStack(spacing: 0) {
                Text(type.string)
                    .padding()
                Spacer()
            }
            .frame(width: 361, height: 52)
            .foregroundStyle(Color.systemBlack)
            .font(.body03)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray100, lineWidth: 1)
                .background(Color.white)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    func fetchPayments() {
        if entryViewtype == .list {
            Task {
                do {
                    guard let travelId else { return }
                    let snapshot = try await Firestore.firestore()
                        .collection(StoreCollection.travel.path).document(travelId)
                        .collection(StoreCollection.payment.path).getDocuments()
                    
                    let result = try snapshot.documents.map { try $0.data(as: Payment.self) }
                    self.paymentsOfType = result
                    
                } catch {
                    print("false fetch payments - \(error)")
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SpendingListView(entryViewtype: .more, travelId: nil)
            .environmentObject(SettlementExpensesStore())
    }
}
