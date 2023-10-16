//
//  MyPageDetailView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/12/23.
//

import SwiftUI

struct MyPageDetailView: View {
    
    @EnvironmentObject var userService: UserService
    
    var body: some View {
        VStack {
            HStack {
                Image(userService.currentUser?.userImage ?? "white")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(50)
                VStack(alignment: .leading) {
                    NavigationLink(destination: ProfileView()) {
                        HStack {
                            Text(userService.currentUser?.name ?? "")
                                .font(.body01)
                                .foregroundColor(.systemBlack)
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                    
                    HStack {
                        if let bankName = userService.currentUser?.bankName, !bankName.isEmpty {
                            Text(bankName)
                                .font(.caption02)
                                .foregroundColor(.gray600)
                        } else {
                            Text("등록 계좌 없음")
                                .font(.caption02)
                                .foregroundColor(.gray600)
                        }
                        Text(userService.currentUser?.bankAccountNum ?? "")
                            .font(.caption02)
                            .foregroundColor(.gray600)
                        Button(action: {
                            let bankName = userService.currentUser?.bankName ?? ""
                            let bankAccountNum = userService.currentUser?.bankAccountNum ?? ""
                            let combinedString = bankName + " " + bankAccountNum
                            UIPasteboard.general.string = combinedString
                        }, label: {
                            Image("multiple-file-1-5")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.gray600)
                                .frame(width: 18, height: 18)
                        })
                    }
                    .padding(12)
                    .frame(width: 240, height: 32, alignment: .leading)
                    .background(Color.gray050)
                    .cornerRadius(12)
                }
                .padding(16)
            }
            .padding(24)
            
            Rectangle()
                .fill(Color.gray050)
                .frame(width: 393, height: 8)
        }
    }
}

#Preview {
    NavigationStack {
        MyPageDetailView()
            .environmentObject(UserService.shared)
    }
}