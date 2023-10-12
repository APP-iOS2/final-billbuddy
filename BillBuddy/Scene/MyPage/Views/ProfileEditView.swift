//
//  ProfileEditView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/12/23.
//

import SwiftUI

struct ProfileEditView: View {
    
    @ObservedObject var myPageStore: MyPageStore

    var body: some View {
        ZStack {
            
            Spacer().background(Color.gray050).edgesIgnoringSafeArea(.all)
            
            VStack {
                
            }
        }
        .navigationTitle("프로필 수정")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProfileEditView(myPageStore: MyPageStore())
    }
}
