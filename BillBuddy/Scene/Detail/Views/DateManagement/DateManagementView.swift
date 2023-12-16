//
//  DateManagementView.swift
//  BillBuddy
//
//  Created by 윤지호 on 12/16/23.
//

import SwiftUI

struct DateManagementView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @State private var isPresentedSheet: Bool = false
    @State var travel: TravelCalculation
    var paymentDates: [Date] = []
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Divider()
                Rectangle()
                    .foregroundStyle(Color.gray100)
            }
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.gray200, lineWidth: 1)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay {
                    HStack(spacing: 0) {
                        Text("날짜")
                            .font(.body02)
                        Spacer()
                        Button("\(travel.startDate.toFormattedMonthAndDate()) - \(travel.endDate.toFormattedMonthAndDate())") {
                            isPresentedSheet = true
                        }
                        .frame(width: 100, height: 30)
                        .background(Color.myPrimaryLight)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .font(Font.caption02)
                        .foregroundStyle(Color.myPrimary)
                        .font(.body04)
                    }
                    .padding(.horizontal, 16)
                }
                .frame(width: 361, height: 52)
                .padding(.top, 16)

        }
        .modifier(
            DateManagementModifier(
                isPresented: $isPresentedSheet,
                startDate: $travel.startDate,
                endDate: $travel.endDate,
                travelId: travel.id,
                paymentDates: paymentDates,
                saveAction: { startDate, endDate in
                    userTravelStore.setTravelDate(travelId: travel.id, startDate: startDate, endDate: endDate)
                }
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
            ToolbarItem(placement: .principal) {
                Text("날짜 관리")
                    .font(.title05)
            }
        }
    }
}

#Preview {
    NavigationStack {
        DateManagementView(travel: TravelCalculation.sampletravel)
    }
    .environmentObject(UserTravelStore())
}
