//
//  EditTravelSheetView.swift
//  BillBuddy
//
//  Created by Ari on 10/16/23.
//

import SwiftUI

struct EditTravelSheetView: View {
    var body: some View {
        VStack{
            HStack {
                Image(.calendarCheck1)
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("날짜 관리")
                
                Spacer()
            }
            .padding([.bottom, .leading], 30)
            
            HStack {
                Image(.userSingleNeutralMale4)
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("인원 관리")
                
                Spacer()
            }
            .padding([.bottom, .leading], 30)
            
            HStack {
                Image(.script218)
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("결산 하기")
                
                Spacer()
            }
            .padding([.bottom, .leading], 30)
            
        } //MARK: VSTACK
        .font(.body04)
        
    } //MARK: BODY
    
}

#Preview {
    EditTravelSheetView()
}
