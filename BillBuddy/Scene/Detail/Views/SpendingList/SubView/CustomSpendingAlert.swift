//
//  CustomSpendingAlert.swift
//  BillBuddy
//
//  Created by 윤지호 on 12/16/23.
//

import SwiftUI

extension View {
    func spendingAlert(
        isPresented: Binding<Bool>,
        name: String,
        spendingList: [Payment]
    ) -> some View {
        return Text("")
    }
}

struct SpendingModifier: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var name: String
    @Binding var spendingList: [Payment]
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Rectangle()
                    .fill(.black.opacity(0.7))
                    .ignoresSafeArea()
                    .onTapGesture {
                        self.isPresented = false
                    }
                
                SpendingAlert(
                    isPresented: self.$isPresented,
                    name: self.$name,
                    spendingList: self.$spendingList
                )
                .transition(.opacity)
            }
        }
        .animation(
            isPresented ? .spring(response: 0.25) : .none,
            value: isPresented
        )
    }
}

struct SpendingAlert: View {
    @Binding var isPresented: Bool
    @Binding var name: String
    @Binding var spendingList: [Payment]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .frame(width: 361, height: 494)
            .foregroundStyle(Color.gray200)
            .overlay(alignment: .top) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: 0) {
                        Spacer()
                        Button {
                            isPresented = false
                        } label: {
                            Image(.close)
                                .resizable()
                        }
                        .frame(width: 24, height: 24)
                        .padding([.top, .trailing], 20)
                    }
                    VStack(alignment: .leading ,spacing: 0) {
                        Text(name)
                            .font(.title05)
                            .padding(.bottom, 12)
                        Divider()
                            .padding(.bottom, 16)
                        ScrollView {
                            VStack(spacing: 0) {
                                ForEach(spendingList) { item in
                                    HStack(spacing: 0) {
                                        Text(item.content)
                                        Spacer()
                                        Text(item.payment.wonAndDecimal)
                                    }
                                    .font(.body01)
                                    .frame(height: 23)
                                    .padding(.bottom, 5)
                                    
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .padding(.vertical, 22)
                }
            }
    }
}

#Preview {
    Text("Spending Alert")
        .modifier(
            SpendingModifier(
                isPresented: .constant(true),
                name: .constant("전체 총 지출"),
                spendingList: .constant([
                    Payment(type: .food, content: "hi", payment: 100, address: .init(address: "", latitude: 9, longitude: 9), participants: [], paymentDate: 0.0),
                    Payment(type: .food, content: "hi2", payment: 100, address: .init(address: "", latitude: 9, longitude: 9), participants: [], paymentDate: 0.0),
                    Payment(type: .food, content: "hi3", payment: 100, address: .init(address: "", latitude: 9, longitude: 9), participants: [], paymentDate: 0.0)]))
        )
}

