//
//  MyPageDetailView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/12/23.
//

import SwiftUI

struct MyPageDetailView: View {
    
    @ObservedObject var myPageStore: MyPageStore
    
    var body: some View {
        VStack {
            HStack {
                Image(myPageStore.myPageData.userImage)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(50)
                VStack(alignment: .leading) {
                    NavigationLink(destination: ProfileView(myPageStore: MyPageStore())) {
                        HStack {
                            Text(myPageStore.myPageData.name)
                                .font(.body01)
                                .foregroundColor(.systemBlack)
                            Image("chevron_right")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                    }
                
                    HStack {
                        Text(myPageStore.myPageData.bankName)
                            .font(.caption02)
                            .foregroundColor(.gray600)
                        Text(myPageStore.myPageData.bankAccountNum)
                            .font(.caption02)
                            .foregroundColor(.gray600)
                        Button(action: {
                            UIPasteboard.general.string = myPageStore.myPageData.bankName + " " + myPageStore.myPageData.bankAccountNum
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
        MyPageDetailView(myPageStore: MyPageStore())
    }
}
