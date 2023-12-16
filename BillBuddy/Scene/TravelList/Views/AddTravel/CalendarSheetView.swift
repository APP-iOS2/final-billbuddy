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
        VStack(spacing: 0) {
            Spacer()
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
            } //MARK: HSTACK
            .padding(.top, 27)
            .padding(.bottom, 34)
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(calendarStore.days, id: \.self) { day in
                        Text(day)
                            .font(.body04)
                            .foregroundColor(.gray500)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                    }
                    
                }
                .padding(.bottom, 12)
                
                VStack {
                    ForEach(calendarStore.weeks, id: \.self) { week in
                        ZStack {
                            HStack(spacing: 0) {
                                ForEach(week, id: \.self) { day in
                                    let isCurrentMonth = calendarStore.calendar.isDate(day, equalTo: calendarStore.date, toGranularity: .month)
                                    ZStack {
                                        fillRange(day: day, week: week, index: week.firstIndex(of: day)!)
                                        Button(action: {
                                            calendarStore.selectDay(day)
                                        }) {
                                            ZStack {
                                                Text("\(calendarStore.calendar.component(.day, from: day))")
                                                    .foregroundColor(isCurrentMonth ? (calendarStore.isDateSelected(day: day) ? Color.white : Color.black) : Color.gray500)
                                                    .foregroundColor(calendarStore.isDateSelected(day: day) ? Color.white : Color.black)
                                                
                                                Circle()
                                                    .frame(width: 4, height: 4)
                                                    .foregroundColor(calendarStore.isToday(day: day) ? (calendarStore.isDateSelected(day: day) ? Color.white : Color.myPrimary) : Color.clear)
                                                    .offset(y: 11.5)
                                            }
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                        }
                                        .background(calendarStore.isDateInRange(day: day) ? (calendarStore.isDateSelected(day: day) ? Color.myPrimary.cornerRadius(30) : Color.clear.cornerRadius(30)) : Color.clear.cornerRadius(30))
                                    }
                                    .frame(height: 36)
                                    .frame(maxWidth: .infinity)
                                }
                                .font(.caption02)
                            }
                        }
                    }
                }
                Spacer()
                
                Button(action: {
                    saveSelectedDate()
                }) {
                    Text(calendarStore.instructionText)
                        .foregroundColor(calendarStore.buttonFontColor)
                        .font(Font.body02)
                    
                }
                .disabled(calendarStore.instructionText != "여행 일정 선택 완료")
                .frame(width: 335, height: 52)
                .background(calendarStore.buttonBackgroundColor.cornerRadius(8))
                .foregroundColor(.white)
                .padding(.bottom, 52)
                
                
            } //MARK: VSTACK
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            
        } //MARK: BODY
    }
    
    func fillRange(day: Date, week: [Date], index: Int) -> some View {
        HStack(spacing: 0) {
            
            let rangeFrame = Rectangle()
                .fill(Color.lightBlue200)
                .frame(height: 30)
            
            if calendarStore.isDateSelected(day: day) {
                if day == calendarStore.firstDate {
                    Color.clear
                } else {
                    rangeFrame
                }
            } else {
                if calendarStore.isDateInRange(day: day) {
                    if index == 0 {
                        rangeFrame
                    } else {
                        if calendarStore.isFirstDayOfMonth(date: day) {
                            rangeFrame
                        } else {
                            rangeFrame
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
                        rangeFrame
                    }
                }
            } else {
                if calendarStore.isDateInRange(day: day) {
                    if index == week.count - 1 {
                        rangeFrame
                    } else {
                        if calendarStore.isLastDayOfMonth(date: day) {
                            rangeFrame
                        } else {
                            rangeFrame
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
        
        //        let adjustedFirstDate = calendarStore.calendar.date(byAdding: .hour, value: 9, to: firstDate)!
        //        let adjustedSecondDate = calendarStore.calendar.date(byAdding: .hour, value: 9, to: secondDate)!
        
        startDate = firstDate
        endDate = secondDate
        //        startDate = adjustedFirstDate
        //        endDate = adjustedSecondDate
        
        isShowingCalendarView = false
        print("시작일: \(firstDate)")
        print("종료일: \(secondDate)")
        
    }
}


#Preview {
    CalendarSheetView(startDate: .constant(Date()), endDate: .constant(Date()), isShowingCalendarView: .constant(false))
    
}
