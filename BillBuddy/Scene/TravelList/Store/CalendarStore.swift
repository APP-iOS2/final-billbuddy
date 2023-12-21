//
//  CalendarStore.swift
//  BillBuddy
//
//  Created by Ari on 10/12/23.
//

import SwiftUI

final class CalendarStore: ObservableObject {
    
    var calendar = Calendar.current
    
    @Published var date: Date = Date()
    @Published var firstDate: Date?
    @Published var secondDate: Date?
    @Published var instructionText: String = "시작일을 선택해주세요"
    @Published var buttonBackgroundColor = Color.gray100
    @Published var buttonFontColor = Color.gray600
    
    var weeks: [[Date]] {
        var weeks = [[Date]]()
        
        let components = calendar.dateComponents([.year, .month], from: date)
        if let firstDayOfMonth = calendar.date(from: components) {
            let range = calendar.range(of: .weekOfMonth, in: .month, for: firstDayOfMonth)!
            let weekCount = range.count
            
            var offsetComponent = DateComponents()
            offsetComponent.day = -calendar.component(.weekday, from: firstDayOfMonth) + calendar.firstWeekday
            
            if let startOfMonth = calendar.date(byAdding: offsetComponent, to: firstDayOfMonth) {
                for week in 0..<weekCount {
                    var weekDays = [Date]()
                    
                    for day in 0..<7 {
                        if let date = calendar.date(byAdding: .day, value: day + week * 7, to: startOfMonth) {
                            weekDays.append(date)
                        } else {
                            weeks.append(weekDays)
                        }
                    }
                    weeks.append(weekDays)
                }
            }
        }
        
        return weeks
    }
    
    
    var days: [String] {
        ["월", "화", "수", "목", "금", "토", "일"]
    }
    
    // 날짜 선택
    func selectDay(_ day: Date) {
        if firstDate == nil {
            firstDate = day
            instructionText = "종료일을 선택해주세요"
        } else if secondDate == nil {
            if let first = firstDate {
                if first > day {
                    secondDate = first
                    firstDate = day
                    instructionText = "여행 일정 선택 완료"
                } else {
                    secondDate = day
                    instructionText = "여행 일정 선택 완료"
                }
            }
        } else {
            firstDate = day
            secondDate = nil
            instructionText = "시작일을 선택해주세요"
        }
        
        if instructionText == "여행 일정 선택 완료" {
            buttonBackgroundColor = Color.myPrimary
            buttonFontColor = Color.white
        } else {
            buttonBackgroundColor = Color.gray100
            buttonFontColor = Color.gray600
        }
    }
    
    // 오늘 날짜인지 확인
    func isToday(day: Date) -> Bool {
        return calendar.isDateInToday(day)
    }
    
    // 선택된 날짜가 범위에 속하는지 확인
    func isDateInRange(day: Date) -> Bool {
        if secondDate == nil {
            if let firstDate {
                return firstDate == day
            }
        } else {
            if let firstDate = firstDate, let secondDate = secondDate {
                return day >= firstDate && day <= secondDate
            }
        }
        return false
    }
    
    // 선택된 날짜인지 확인
    func isDateSelected(day: Date) -> Bool {
        if secondDate == nil {
            if let firstDate {
                return firstDate == day
            }
        } else {
            if let firstDate, let secondDate {
                return ((firstDate == day) || (secondDate == day))
            }
        }
        return false
    }
    
    // 해당 날짜가 달의 첫 번째 날인지 확인
    func isFirstDayOfMonth(date: Date) -> Bool {
        let components = calendar.dateComponents([.day], from: date)
        return components.day == 1
    }
    
    // 해당 날짜가 달의 마지막 날인지 확인
    func isLastDayOfMonth(date: Date) -> Bool {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day, .month, .year], from: date)
        let lastDayOfMonth = calendar.range(of: .day, in: .month, for: date)!.upperBound - 1
        return components.day == lastDayOfMonth
    }
    
    
    /// 몇 월 달인지 반환
    func titleForMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월"
        return dateFormatter.string(from: date)
    }
    
    /// 연도 반환
    func titleForYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "yyyy년"
        return dateFormatter.string(from: date)
    }
    
    /// 이전 달로 이동
    func selectBackMonth() {
        date = calendar.date(byAdding: .month, value: -1, to: date) ?? Date()
    }
    
    /// 다음 달로 이동
    func selectForwardMonth() {
        date = calendar.date(byAdding: .month, value: 1, to: date) ?? Date()
    }
}


