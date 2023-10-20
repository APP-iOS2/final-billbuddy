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
            Button {
                
            } label: {
                HStack {
                    Image(.calendarCheck1)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 12)
                    
                    Text("날짜 관리")
                    
                    Spacer()
                }
                .padding([.bottom, .leading], 30)
                
            } //MARK: BUTTON1
            
            Button {
                
            } label: {
                
                HStack {
                    Image(.userSingleNeutralMale4)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 12)
                    
                    Text("인원 관리")
                    
                    Spacer()
                }
                .padding([.bottom, .leading], 30)
                
            } //MARK: BUTTON2
            
            Button {
                
            } label: {
                HStack {
                    Image(.script218)
                        .resizable()
                        .frame(width: 18, height: 18)
                        .padding(.trailing, 12)
                    
                    Text("결산 하기")
                    
                    Spacer()
                }
                .padding([.bottom, .leading], 30)
                
            } //MARK: BUTTON3
            
        } //MARK: VSTACK
        .font(.body04)
        .foregroundColor(.systemBlack)
    }
    
} //MARK: BODY



#Preview {
    EditTravelSheetView()
}
