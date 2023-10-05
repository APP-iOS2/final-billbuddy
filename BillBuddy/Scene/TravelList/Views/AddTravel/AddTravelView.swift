//
//  AddTravelView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelView: View {
    @Binding var travelData: TravelCalculation
    @EnvironmentObject var userTravelStore: UserTravelStore
    @State private var newTravel = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date().timeIntervalSince1970, endDate: Date().timeIntervalSince1970, updateContentDate: Date(), members: [])
    @State private var selectedMember = 0
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("여행 제목")
                TextField("여행 제목을 입력해주세요.", text: $travelData.travelTitle)
                
                DatePicker("시작 일", selection: $startDate, displayedComponents: [.date])
                    .datePickerStyle(.automatic)
                    .padding(.bottom, 10)
                
                DatePicker("종료 일", selection: $endDate, displayedComponents: [.date])
                    .datePickerStyle(.automatic)
            }
            .padding([.leading, .trailing], 12)
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        HStack {
            Text("여행 참여 인원을 선택해주세요.")
                .padding(12)
            
            Spacer()
            
            Picker("참여 인원", selection: $selectedMember) {
                ForEach(0..<$travelData.members.count, id: \.self) { index in
                    Text("\(index)")
                }
            }
            .pickerStyle(.automatic)
        }
        
        Spacer()
        
        Button {
            
            userTravelStore.addTravel(newTravel)
            
        } label: {
            Text("여행추기")
        }
    }
}

#Preview {
    AddTravelView(travelData: .constant(TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date().timeIntervalSince1970, endDate: Date().timeIntervalSince1970, updateContentDate: Date(), members: [])))
           .environmentObject(UserTravelStore())
}
