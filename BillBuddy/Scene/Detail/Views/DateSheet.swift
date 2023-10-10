//
//  DateSheet.swift
//  BillBuddy
//
//  Created by 김유진 on 10/9/23.
//

import SwiftUI

struct DateSheet: View {
    
    struct dateNumber: Hashable {
        var date: Date
        var dateNum: String
    }
    
    var userTravel: UserTravel
    @State var dates: [dateNumber] = []
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(dates, id:\.self) { date in
                    HStack {
                        
                        Button(action: {
                            
                        }, label: {
                            Text(date.date.dateWeek)
                            Text(date.dateNum)
                        })
                        
                        Spacer()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            dates = startDateToEndDate(startDate: userTravel.startDate, endDate: userTravel.endDate)
        }
    }
    
    func startDateToEndDate(startDate: Double, endDate: Double)->[dateNumber] {
        var start = startDate
        var dates: [dateNumber] = []
        var day = 1
        
        while(start <= endDate) {
            dates.append(dateNumber(date: start.toDate(), dateNum: "\(day)일차"))
            start += 86400.0 // 하루치를 더해줌
            day += 1
        }
        
        return dates
    }
}

#Preview {
    DateSheet(userTravel: UserTravel(travelId: "", travelName: "", startDate: 1675186400, endDate: 1681094400))
}
