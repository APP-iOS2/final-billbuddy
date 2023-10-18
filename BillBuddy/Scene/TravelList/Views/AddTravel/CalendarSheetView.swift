//
//  CalendarSheetView.swift
//  BillBuddy
//
//  Created by Ari on 10/14/23.
//

import SwiftUI

struct CalendarSheetView: View {
    @EnvironmentObject var userTravleStroe : UserTravelStore
    @StateObject var calendarStore = CalendarStore()
    @Binding var startDate: Date
    @Binding var endDate: Date
    @Binding var isShowingCalendarView: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    calendarStore.selectBackMonth()
                }) {
                    Image("arrow_back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .padding(.trailing, 27)
                
                Text("\(calendarStore.titleForYear())   \(calendarStore.titleForMonth())")
                    .font(.body01)
                
                Button(action: {
                    calendarStore.selectForwardMonth()
                }) {
                    Image("arrow_forward_ios")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20, height: 20)
                }
                .padding(.leading, 27)
            }
            
            VStack(spacing: 3) {
                HStack(spacing: 0) {
                    ForEach(calendarStore.days, id: \.self) { day in
                        Text(day)
                            .foregroundColor(.gray500)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 37)
                }
            }
            
            VStack(spacing: 6) {
                // TravelCalculation의 startDate와 endDate에 담아야함
                ForEach(calendarStore.weeks, id: \.self) { week in
                    ZStack {
                        HStack(spacing: 0) {
                            ForEach(Array(week.enumerated()), id: \.offset) { index, day in
                                if calendarStore.calendar.isDate(day, equalTo: calendarStore.date, toGranularity: .month) {
                                    ZStack {
                                        fillRange(day: day, week: week, index: index)
                                        Button(action: {
                                            calendarStore.selectDay(day)
                                        }) {
                                            ZStack {
                                                Text("\(calendarStore.calendar.component(.day, from: day))")
                                                    .foregroundColor(calendarStore.isDateSelected(day: day) ? Color.white : Color.black)
                                                Circle()
                                                    .frame(width: 4, height: 4)
                                                    .foregroundColor(calendarStore.isToday(day: day) ? (calendarStore.isDateSelected(day: day) ? Color.white : Color.myPrimary) : Color.clear)
                                                    .offset(y: 13)
                                            }
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                        }
                                        .background(calendarStore.isDateInRange(day: day) ? (calendarStore.isDateSelected(day: day) ? Color.myPrimary.cornerRadius(30) : Color.clear.cornerRadius(30)) : Color.clear.cornerRadius(30))
                                    }
                                    .frame(height: 36)
                                    .frame(maxWidth: .infinity)
                                } else {
                                    Rectangle()
                                        .foregroundColor(Color.clear)
                                        .frame(height: 36)
                                        .frame(maxWidth: .infinity)
                                }
                            }
                            .font(.caption02)
                        }
                    }
                }
            }
            
            Button(action: {
                saveSelectedDate()
            }) {
                Text(calendarStore.instructionText)
                    .font(Font.body02)
                
            }
            .disabled(calendarStore.instructionText != "여행 일정 선택 완료")
            .frame(width: 335, height: 52)
            .background(Color.myPrimary.cornerRadius(12))
            .foregroundColor(.white)
            .padding(.top, 30)
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 20)
    }
    
    func fillRange(day: Date, week: [Date], index: Int) -> some View {
        HStack(spacing: 0) {
            if calendarStore.isDateSelected(day: day) {
                if day == calendarStore.firstDate {
                    Color.clear
                } else {
                    Color.lightBlue200
                }
            } else {
                if calendarStore.isDateInRange(day: day) {
                    if index == 0 {
                        Color.lightBlue200
                    } else {
                        if calendarStore.isFirstDayOfMonth(date: day) {
                            Color.lightBlue200
                        } else {
                            Color.lightBlue200
                        }
                    }
                } else {
                    Color.clear
                }
            }
            
            if calendarStore.isDateSelected(day: day) {
                if day == calendarStore.secondDate {
                    Color.clear
                } else {
                    if calendarStore.secondDate == nil {
                        Color.clear
                    } else {
                        Color.lightBlue200
                    }
                }
            } else {
                if calendarStore.isDateInRange(day: day) {
                    if index == week.count - 1 {
                        Color.lightBlue200
                    } else {
                        if calendarStore.isLastDayOfMonth(date: day) {
                            Color.lightBlue200
                        } else {
                            Color.lightBlue200
                        }
                    }
                } else {
                    Color.clear
                }
            }
        }
    }
    
    func saveSelectedDate() {
        guard let firstDate = calendarStore.firstDate, let secondDate = calendarStore.secondDate else {
            return
        }
        
        startDate = firstDate
        endDate = secondDate

        isShowingCalendarView = false
        print("시작일: \(firstDate)")
        print("종료일: \(secondDate)")
        
    }
}


#Preview {
    CalendarSheetView(startDate: .constant(Date()), endDate: .constant(Date()), isShowingCalendarView: .constant(false))
    
}
