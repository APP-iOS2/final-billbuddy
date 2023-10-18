//
//  AddTravelButtonView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelButtonView: View {
    @ObservedObject var userTravelStore: UserTravelStore
    @Binding var isDimmedBackground: Bool
    @State private var backgroundColor: Color = .gray700
    @State private var showMenuItem1 = false
    @State private var showMenuItem2 = false
    @State private var buttonImage = "openButton"
    @State private var travelCalculation = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                if showMenuItem1 {
                    NavigationLink {
                        PaymentManageView(mode: .mainAdd, travelCalculation: $travelCalculation)
                            .navigationBarBackButtonHidden()
                            .environmentObject(userTravelStore)
                            .onDisappear {
                                closeMenu()
                            }
                    } label: {
                        
                        Text("지출 추가하기")
                            .padding(.trailing, 16)
                            .font(Font.body01)
                            .foregroundColor(.white)
                        MenuItem(icon: "wallet")
                            .padding(.trailing, 12)
                    }
                    .onAppear {
                        if let travel = userTravelStore.userTravels.first {
                            // TODO: userTravel로 travelCalculation 찾아오기 !
                            // member 때문에 필요함
                            travelCalculation = userTravelStore.findTravelCalculation(userTravel: travel) ?? TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])
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
                            .onDisappear {
                                closeMenu()
                            }
                    } label: {
                        
                        Text("여행 추가하기")
                            .padding(.trailing, 16)
                            .font(Font.body01)
                            .foregroundColor(.white)
                        MenuItem(icon: "add_room")
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
                    Image(buttonImage)
                        .resizable()
                        .frame(width: 56, height: 56)
                        .shadow(color: Color.gray.opacity(0.2), radius: 0, y: 5)
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
            buttonImage = "openButton"
            isDimmedBackground = false
        } else {
            withAnimation(.bouncy) {
                showMenuItem1 = true
                showMenuItem2 = true
            }
            buttonImage = "closeButton"
            isDimmedBackground = true
        }
//        isDimmedBackground = false
    }
    
    func closeMenu() {
        showMenuItem1 = false
        showMenuItem2 = false
        isDimmedBackground = false
        buttonImage = "openButton"
    }
}

struct MenuItem: View {
    var icon: String
    
    var body: some View {
        ZStack {
                
            Image(icon)
                .resizable()
                .frame(width: 56, height: 56)
        }
    }
}

#Preview {
    AddTravelButtonView(userTravelStore: UserTravelStore(), isDimmedBackground: .constant(false))
}
