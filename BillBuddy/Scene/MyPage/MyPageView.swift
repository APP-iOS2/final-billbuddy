//
//  MyPage.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//

import SwiftUI

struct MyPageView: View {
    
    var user : User
    
    var body: some View {
        Form {
            Section("내정보") {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text(user.name)
                }
                .font(.largeTitle)
                Text(user.bankName)
                Text(user.bankAccountNum)
            }
            
            Section("설정") {
                Text("알림 설정")
                Text("위치 설정")
            }
            Section("정보") {
                Text("개인정보 이용 동의")
                Text("문의하기")
                Text("오픈소스 라이센스")
            }
            Section {
                Text("로그아웃")
                Text("계정탈퇴")
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    
    MyPageView(user: User(email: "이메일", name: "이름", phoneNum: "휴대폰 번호", bankName: "은행", bankAccountNum: "계좌 번호", isPremium: false, premiumDueDate: 0))
    
}
