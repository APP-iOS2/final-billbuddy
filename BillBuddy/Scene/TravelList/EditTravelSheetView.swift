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
                Image("calendar-check-1")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("날짜 관리")
                    .font(.body04)
                    .foregroundColor(Color.black)
                
                Spacer()
            }
            .padding([.bottom, .leading], 30)
            
            HStack {
                Image("user-single-neutral-male-4")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("인원 관리")
                    .font(.body04)
                    .foregroundColor(Color.black)
                
                Spacer()
            }
            .padding([.bottom, .leading], 30)
            
            HStack {
                Image("script-2-18")
                    .resizable()
                    .frame(width: 18, height: 18)
                Text("결산 하기")
                    .font(.body04)
                    .foregroundColor(Color.black)
                
                Spacer()
            }
            .padding([.bottom, .leading], 30)
            
//            HStack {
//                Image("recycle-bin-2-10")
//                    .resizable()
//                    .frame(width: 18, height: 18)
//                Text("여행 삭제")
//                    .font(.body04)
//                    .foregroundColor(Color.black)
//                
//                Spacer()
//            }
//            .padding(.leading, 30)
        }
    }
}

#Preview {
    EditTravelSheetView()
}
