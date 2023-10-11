//
//  AddTravelButtonView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelButtonView: View {
    
    @State private var showMenuItem1 = false
    @State private var showMenuItem2 = false
    @State private var buttonImage = "plus.circle.fill"
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if showMenuItem1 {
                    Text("지출 추가하기")
                        .foregroundColor(Color.black)
                    MenuItem(icon: "wallet")
                        .padding(.trailing, 12)
                }
            }
            
            HStack {
                Spacer()
                NavigationLink {
                    AddTravelView()
                } label: {
                    if showMenuItem2 {
                        Text("여행 추가하기")
                            .foregroundColor(Color.black)
                        MenuItem(icon: "add")
                            .padding(.trailing, 12)
                    }
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
                        
                }
                .padding(.trailing, 12)
            }
        }
    }
    
    func showMenu() {
        showMenuItem1.toggle()
        showMenuItem2.toggle()
        // 다은님이 주신 심볼로는 버튼을 하얀색으로 만들지 못함
        buttonImage = showMenuItem1 || showMenuItem2 ? "xmark.circle.fill" : "plus.circle.fill"
    }
}

struct MenuItem: View {
    var icon: String
    
    var body: some View {
        ZStack {
            Circle()
//                .foregroundColor(Color.systemGray03)
                .frame(width: 60, height: 60)
            Image(icon)
        }
    }
}

#Preview {
    AddTravelButtonView()
}
