//
//  SelectTripSheet.swift
//  BillBuddy
//
//  Created by 김유진 on 10/11/23.
//

import SwiftUI

struct SelectTripSheet: View {
    
    @ObservedObject var userTravelStore: UserTravelStore
    @Binding var travelCalculation: TravelCalculation
    var body: some View {
        VStack {
            ForEach(userTravelStore.travels) { travel in
                Button(action: {
                    travelCalculation = travel
                }, label: {
                    Text(travel.travelTitle)
                })
            }
            
        }
    }
}
