//
//  AddTravelButtonView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelButtonView: View {
    @EnvironmentObject private var userTravelStore: UserTravelStore
    @ObservedObject var floatingButtonMenuStore: FloatingButtonMenuStore
    @State private var backgroundColor: Color = .gray700
    @State private var travelCalculation = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: 0, endDate: 0, updateContentDate: 0, members: [])
    @State private var isShowingNoTravelAlert: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                if floatingButtonMenuStore.showMenuItem1 {
                    NavigationLink {
                        PaymentManageView(mode: .mainAdd, travelCalculation: travelCalculation)
                            .navigationBarBackButtonHidden()
                            .environmentObject(userTravelStore)
                            .onAppear {
                                if userTravelStore.travels.first == nil {
                                    isShowingNoTravelAlert = true
                                }
                            }
                            .onDisappear {
                                floatingButtonMenuStore.closeMenu()
                            }
                    } label: {
                        Text("지출 추가하기")
                            .padding(.trailing, 16)
                            .font(Font.body01)
                            .foregroundColor(.white)
                        MenuItem(icon: "wallet")
                            .padding(.trailing, 12)
                    }
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            HStack {
                Spacer()
                if floatingButtonMenuStore.showMenuItem2 {
                    NavigationLink {
                        AddTravelView()
                            .onDisappear {
                                floatingButtonMenuStore.closeMenu()
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
                    floatingButtonMenuStore.showMenu()
                    print(floatingButtonMenuStore.isDimmedBackground.description)
                        
                }) {
                    Image(floatingButtonMenuStore.buttonImage)
                        .resizable()
                        .frame(width: 60, height: 60)
                        .shadow(color: Color.gray.opacity(0.2), radius: 0, y: 5)
                        .animation(nil, value: UUID())
                    
                }
                .padding(.trailing, 12)
                .padding(.bottom, 15)
                
            } //MARK: HSTACK
            
        } //MARK: VSTACK
        
    } //MARK: BODY
    
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
    AddTravelButtonView(floatingButtonMenuStore: FloatingButtonMenuStore())
}
