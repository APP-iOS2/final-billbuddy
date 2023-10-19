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
    
    @EnvironmentObject private var tabBarVisivilyStore: TabBarVisivilyStore
    @EnvironmentObject var userTravelStore: UserTravelStore
    @State private var travelTitle: String = ""
    @State private var selectedMember = 0
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var isShowingCalendarView = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            Color.gray1000
            VStack {
                // 리스트간 간격이 너무 넓음, 그림자 효과 맞게 넣은건가?
                ScrollView {
                    HStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .overlay(
                                TextField("여행 이름을 입력해주세요.", text: $travelTitle)
                                    .padding(12)
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    .shadow(color: Color.gray.opacity(0.3), radius: 8)
                    //                    .padding([.top, .horizontal], 12)
                    
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.3), radius: 8)
                            .overlay(
                                HStack {
                                    Text("일정")
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        isShowingCalendarView.toggle()
                                    }) {
                                        
                                        if startDate != nil && endDate != nil {
                                            Text("\(startDate.toFormattedMonthandDay()) - \(endDate.toFormattedMonthandDay())")
                                                .font(.body04)
                                                .frame(width: 110, height: 30)
                                                .shadow(color: Color.clear, radius: 0)
                                            
                                                .foregroundColor(Color.myPrimary)
                                                .background(Color.lightBlue100)
                                                .cornerRadius(8)
                                        } else {
                                            Image("calendar-add-4")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                            
                                        }
                                    }
                                    .shadow(color: Color.gray, radius: 0)
                                    .sheet(isPresented: $isShowingCalendarView) {
                                        CalendarSheetView(startDate: $startDate, endDate: $endDate, isShowingCalendarView: $isShowingCalendarView)
                                            .presentationDetents([.height(500)])
                                    }
                                    
                                }
                                    .padding(12)
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    //                    .padding([.top, .horizontal], 12)
                    
                    HStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.white)
                            .shadow(color: Color.gray.opacity(0.3), radius: 8)
                            .overlay(
                                HStack {
                                    Text("인원")
                                    Spacer()
                                    
                                    Button(action: {
                                        selectedMember = max(0, selectedMember - 1)
                                    }) {
                                        Image("Group 1171275315")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    Text("\(selectedMember)")
                                        .font(.body01)
                                    
                                    Button(action: {
                                        selectedMember += 1
                                    }) {
                                        Image("Group 1171275314")
                                            .resizable()
                                            .frame(width: 24, height: 24)
                                    }
                                    .buttonStyle(.plain)
                                }
                                    .padding(12)
                            )
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .padding(.horizontal, 12)
                    .padding(.top, 24)
                    //                    .padding([.top, .horizontal], 12)
                    
                } //MARK: SCROLLVIEW
                .font(.body04)
                
                Spacer()
                
                Button {
                    userTravelStore.addTravel(travelTitle, memberCount: selectedMember, startDate: startDate, endDate: endDate)
                    dismiss()
                } label: {
                    Text("개설하기")
                        .font(.title05)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(Color.myPrimary)
                .foregroundColor(.white)
                
            } //MARK: VSTACK
            
        } //MARK: ZSTACK
        .overlay(
            Rectangle()
                .fill(Color.systemBlack.opacity(isShowingCalendarView ? 0.5 : 0)).edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    isShowingCalendarView = false
                }
        )
        .navigationBarTitle("여행 추가하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar(tabBarVisivilyStore.visivility, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(.arrowBack)
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                
            }
        }
        .onAppear {
            tabBarVisivilyStore.hideTabBar()
        }
    } //MARK: BODY
    
}



extension Date {
    func toFormattedMonthandDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM.dd"
        dateFormatter.timeZone = TimeZone(abbreviation: "KST")
        return dateFormatter.string(from: self)
    }
}

#Preview {
    NavigationStack {
        AddTravelView()
            .environmentObject(TabBarVisivilyStore())
            .environmentObject(UserTravelStore())
    }
}
