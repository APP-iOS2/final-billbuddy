//
//  AddTravelView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelView: View {
    @StateObject var travelCalculationStore = TravelCalculationStore()
    @EnvironmentObject var userTravelStore: UserTravelStore
    @State var newTravel = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date(), endDate: Date(), updateContentDate: Date(), members: [])
    @State private var selectedMember = 0
    
    var body: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text("여행 제목")
                TextField("여행 제목을 입력해주세요.", text: $travelCalculationStore.travelCalculations[selectedMember].travelTitle)
                
                DatePicker("시작 일", selection: $travelCalculationStore.travelCalculations[selectedMember].startDate, displayedComponents: [.date])
                    .datePickerStyle(.automatic)
                    .padding(.bottom, 10)
                
                DatePicker("종료 일", selection: $travelCalculationStore.travelCalculations[selectedMember].endDate, displayedComponents: [.date])
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
                ForEach(0..<travelCalculationStore.travelCalculations[selectedMember].members.count, id: \.self) { index in
                    Text(travelCalculationStore.travelCalculations[selectedMember].members[index].name)
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
    AddTravelView()
}
