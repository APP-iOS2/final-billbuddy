//
//  EditDateCalender.swift
//  BillBuddy
//
//  Created by 윤지호 on 12/17/23.
//
import SwiftUI

enum SeletedState {
    case none
    case first
    case second
    
    var labelText: String {
        switch self {
        case .none:
            return "시작일을 선택해주세요"
        case .first:
            return "종료일을 선택해주세요"
        case .second:
            return "여행 일정 수정 완료"
        }
    }
}

final class EditDateCalenderStore: ObservableObject {
    
    var calendar = Calendar.current
    
    @Published var date: Date = Date()
    @Published var firstDate: Date?
    @Published var secondDate: Date?
    @Published var seletedState: SeletedState = .none
    
    var isSelectedAll: Bool {
        seletedState == .second
    }
    
    func setDate(_ startDate: Date,_ endDate: Date) {
        selectDay(startDate)
        selectDay(endDate)
        seletedState = .none
    }
    
    var weeks: [[Date]] {
        calendar.firstWeekday = -5
        var weeks = [[Date]]()

        let components = calendar.dateComponents([.year, .month], from: date)
        if let firstDayOfMonth = calendar.date(from: components) {
            let firstWeekdayOfMonth = calendar.component(.weekday, from: firstDayOfMonth)
            var offsetComponent = DateComponents()
            offsetComponent.day = -firstWeekdayOfMonth + calendar.firstWeekday
            if let startOfMonth = calendar.date(byAdding: offsetComponent, to: firstDayOfMonth) {
                for week in 0..<6 {
                    var weekDays = [Date]()
                    for day in 0..<7 {
                        let date = calendar.date(byAdding: .day, value: day + week * 7, to: startOfMonth)!
                            weekDays.append(date)
                        
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
        switch seletedState {
        case .none:
            secondDate = nil
            firstDate = day
            
            seletedState = .first
        case .first:
            if let first = firstDate {
                if first > day {
                    secondDate = first
                    firstDate = day
                } else {
                    secondDate = day
                }
            }
            seletedState = .second
        case .second:
            firstDate = day
            secondDate = nil
            seletedState = .first
        }

    }
    
    // 오늘 날짜인지 확인
    func isToday(day: Date) -> Bool {
        return calendar.isDateInToday(day)
    }
    
    func isDatesInRange(days: [Date]) -> Bool {
        for day in days {
            if isDateInRange(day: day) == false {
                return false
            }
        }
        return true
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
