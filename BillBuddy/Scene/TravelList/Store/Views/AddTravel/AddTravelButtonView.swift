//
//  AddTravelButtonView.swift
//  BillBuddy
//
//  Created by Ari on 2023/10/03.
//

import SwiftUI

struct AddTravelButtonView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 50))
                    .foregroundColor(Color.primary)
                    .frame(width: 60, height: 60)
                    .offset(x: -25, y: -30)
            }
        }
    }
}


#Preview {
    AddTravelButtonView()
}
