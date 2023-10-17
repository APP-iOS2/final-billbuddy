//
//  AddTravelButtonView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelButtonView: View {
    @ObservedObject var userTravelStore: UserTravelStore
    
    @State private var backgroundColor: Color = .gray700
    @State private var showMenuItem1 = false
    @State private var showMenuItem2 = false
    @State private var buttonImage = "plus.circle.fill"
    @State private var travelCalculation = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if showMenuItem1 {
                    NavigationLink {
                        PaymentManageView(mode: .mainAdd, travelCalculation: $travelCalculation)
                            .navigationBarBackButtonHidden()
                            .environmentObject(userTravelStore)
                    } label: {
                        
                        Text("지출 추가하기")
                            .foregroundColor(Color.black)
                        MenuItem(icon: "wallet")
                            .padding(.trailing, 12)
                    }
                    .onAppear {
                        if let travel = userTravelStore.userTravels.first {
                            // TODO: userTravel로 travelCalculation 찾아오기 !
                            // member 때문에 필요함
                            travelCalculation = userTravelStore.findTravelCalculation(userTravel: travel) ?? TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])
//                            travelCalculation.travelTitle = travel.travelName
//                            travelCalculation.startDate = travel.startDate
//                            travelCalculation.endDate = travel.endDate
                        }
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            HStack {
                Spacer()
                if showMenuItem2 {
                    NavigationLink {
                        AddTravelView()
                    } label: {
                        
                        Text("여행 추가하기")
                            .foregroundColor(Color.black)
                        MenuItem(icon: "add")
                            .padding(.trailing, 12)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            
            HStack{
                Spacer()
                Button(action: {
                    showMenu()
                }) {
                    Image(systemName: buttonImage)
                        .font(.system(size: 50))
                        .frame(width: 60, height: 60)
                        .animation(nil, value: UUID())
                    
                }
                .padding(.trailing, 12)
            }
        }
    }
    
    func showMenu() {
        if showMenuItem1 || showMenuItem2 {
            showMenuItem1 = false
            showMenuItem2 = false
            buttonImage = "plus.circle.fill"
        } else {
            withAnimation(.bouncy) {
                showMenuItem1 = true
                showMenuItem2 = true
            }
            buttonImage = "xmark.circle.fill"
        }
    }
    
//    func showMenu() {
//        showMenuItem1 = true
//        showMenuItem2 = true
//        // 다은님이 주신 심볼로는 버튼을 하얀색으로 만들지 못함
//        
//        buttonImage = showMenuItem1 || showMenuItem2 ? "xmark.circle.fill" : "plus.circle.fill"
//    }

}

struct MenuItem: View {
    var icon: String
    
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(Color.gray300)
                .frame(width: 60, height: 60)
            Image(icon)
        }
    }
}

#Preview {
    AddTravelButtonView(userTravelStore: UserTravelStore())
}
