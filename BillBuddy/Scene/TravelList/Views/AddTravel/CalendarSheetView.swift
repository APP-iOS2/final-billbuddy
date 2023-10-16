//
//  CalendarSheetView.swift
//  BillBuddy
//
//  Created by Ari on 10/14/23.
//

import SwiftUI

struct CalendarSheetView: View {
    @StateObject var calendarStore = CalendarStore()
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: {
                    calendarStore.selectBackMonth()
                }) {
                    Image("arrow_back")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }
                
                Text("\(calendarStore.titleForYear())   \(calendarStore.titleForMonth())")
                    .font(.system(size: 16, weight: .semibold))
                
                Button(action: {
                    calendarStore.selectForwardMonth()
                }) {
                    Image("arrow_forward_ios")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 16, height: 16)
                }
            }
            
            VStack(spacing: 3) {
                HStack(spacing: 0) {
                    ForEach(calendarStore.days, id: \.self) { day in
                        Text(day)
                            .frame(height: 36)
                            .frame(maxWidth: .infinity)
                    }
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
                                            .contentShape(Rectangle())
                                        }
                                        .background(calendarStore.isDateInRange(day: day) ? (calendarStore.isDateSelected(day: day) ? Color.myPrimary.cornerRadius(4) : Color.clear.cornerRadius(4)) : Color.clear.cornerRadius(4))
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
                        }
                    }
                }
            }
            
            Text(calendarStore.instructionText)
                .font(.system(size: 14))
                .foregroundColor(Color.gray600)
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
                    Color.myPrimary.opacity(0.2)
                }
            } else {
                if calendarStore.isDateInRange(day: day) {
                    if index == 0 {
                        Color.myPrimary.opacity(0.2)
                    } else {
                        if calendarStore.isFirstDayOfMonth(date: day) {
                            Color.myPrimary.opacity(0.2)
                        } else {
                            Color.myPrimary.opacity(0.2)
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
                        Color.myPrimary.opacity(0.2)
                    }
                }
            } else {
                if calendarStore.isDateInRange(day: day) {
                    if index == week.count - 1 {
                        Color.myPrimary.opacity(0.2)
                    } else {
                        if calendarStore.isLastDayOfMonth(date: day) {
                            Color.myPrimary.opacity(0.2)
                        } else {
                            Color.myPrimary.opacity(0.2)
                        }
                    }
                } else {
                    Color.clear
                }
            }
        }
    }
}

#Preview {
    CalendarSheetView()
}
