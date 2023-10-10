//
//  AddTravelView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelView: View {
    @StateObject private var tempMemberStore: TempMemberStore = TempMemberStore()
    @EnvironmentObject var userTravelStore: UserTravelStore
    @State private var selectedMember = 0
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var travelTitle: String = ""
    
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                TextField("여행 제목을 입력해주세요.", text: $travelTitle)
                    .padding(.bottom, 15)
                
                HStack {
                    Text("일정")
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "calendar")
                    }
                    
                }
//                DatePicker("시작 일", selection: $startDate, displayedComponents: [.date])
//                    .datePickerStyle(.automatic)
//                    .padding(.bottom, 15)
//
//
//                DatePicker("종료 일", selection: $endDate, displayedComponents: [.date])
//                    .datePickerStyle(.automatic)
//                    .padding(.bottom, 15)
            }
            .padding([.leading, .trailing], 12)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            
            
            HStack {
                Text("인원")
                
                Spacer()
                
                Button {
                    tempMemberStore.removeMember()
                    selectedMember = max(0, selectedMember - 1)
                } label: {
                    Image(systemName: "minus.circle")
                }
                
                Text("\(selectedMember)")
                
                Button {
                    tempMemberStore.addMember()
                    selectedMember += 1
                } label: {
                    Image(systemName: "plus.circle")
                }
                
            }
            .padding([.leading, .trailing], 12)
            
            
            
            Spacer()
            
            Button {
                let newTravel = TravelCalculation(hostId: "", travelTitle: travelTitle, managerId: "", startDate: Date().timeIntervalSince1970, endDate: Date().timeIntervalSince1970, updateContentDate: 0, members: [])
                userTravelStore.addTravel(newTravel)
                
            } label: {
                Text("여행추가")
            }
        }
    }
}

#Preview {
    AddTravelView()
        .environmentObject(UserTravelStore())
}
