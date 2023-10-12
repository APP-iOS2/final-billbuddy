//
//  DetailMainView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/9/23.
//

import SwiftUI

struct DetailMainView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
   
    @State var travelCalculation: TravelCalculation
    
    @State var selection: Int = 0
    
    var body: some View {
        VStack {
            SliderView(items: ["내역", "지도"], selection: $selection, defaultXSpace: 12)
            
            if selection == 0 {
                PaymentMainView(travelCalculation: $travelCalculation, paymentStore: PaymentStore(travelCalculationId: travelCalculation.id))
            }
            else if selection == 1 {
                VStack{
                    Text("지도 뷰")
                    Spacer()
                }
            }
            
        }
        .navigationBarBackButtonHidden()
        .navigationTitle(travelCalculation.travelTitle)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image("arrow_back")
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
            
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    MoreView()
                        .navigationTitle("더보기")
                } label: {
                    Image("steps-1 3")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
            }
            
        })
    }
}

//#Preview {
//    NavigationStack {
//        DetailMainView(paymentStore: PaymentStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), memberStore: MemberStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"), userTravel: UserTravel(travelId: "4eB3HvBvH6jXYDLu9irl", travelName: "신나는 유럽여행", startDate: 1675186400, endDate: 1681094400))
//    }
//}
