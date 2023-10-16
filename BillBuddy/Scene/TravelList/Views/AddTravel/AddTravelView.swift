//
//  AddTravelView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelView: View {
    //    @Binding var travelData: TravelCalculation
    //    @StateObject private var tempMemberStore: TempMemberStore = TempMemberStore()
    //    @State private var newTravel = TravelCalculation(hostId: "", travelTitle: "", managerId: "", startDate: Date().timeIntervalSince1970, endDate: Date().timeIntervalSince1970, updateContentDate: Date(), members: [])
    
    @EnvironmentObject var userTravelStore: UserTravelStore
    @State private var travelTitle: String = ""
    @State private var selectedMember = 0
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isShowingCalendarView = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        // 전체적인 디자인 수정 예정
        VStack {
            List {
                Section {
                    TextField("여행 이름을 입력해주세요.", text: $travelTitle)
                }
                //                .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Section {
                    HStack {
                        Text("일정")
                        
                        Spacer()
                        
                        Button {
                            isShowingCalendarView.toggle()
                        } label: {
                            Image("calendar-add-4")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        .sheet(isPresented: $isShowingCalendarView) {
                            CalendarSheetView(startDate: $startDate, endDate: $endDate, isShowingCalendarView: $isShowingCalendarView)
                                .presentationDetents([.height(500)])
                                .presentationDragIndicator(.visible)
                        }
                        
                    }
                }
                
                Section {
                    HStack {
                        Text("인원")
                        
                        Spacer()
                        
                        Button {
                            selectedMember = max(0, selectedMember - 1)
                        } label: {
                            Image("Group 1171275315")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        Text("\(selectedMember)")
                        
                        Button {
                            selectedMember += 1
                        } label: {
                            Image("Group 1171275314")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                    }
                }
            }
            .font(.body04)
            .listStyle(.insetGrouped)
            
            Spacer()
            
            Button {
                userTravelStore.addTravel(travelTitle, memberCount: selectedMember, startDate: startDate, endDate: endDate)
                
                presentationMode.wrappedValue.dismiss()
            } label: {
                Text("개설하기")
                    .font(.title05)
            }
            .frame(width: 500, height: 60)
            .background(Color.myPrimary)
            //            .edgesIgnoringSafeArea(.bottom)
            .foregroundColor(.white)
        }
        .navigationBarTitle("여행 추가하기")
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

#Preview {
    AddTravelView()
        .environmentObject(UserTravelStore())
}
