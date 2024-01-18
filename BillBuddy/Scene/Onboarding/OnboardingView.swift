//
//  OnBoardingView.swift
//  BillBuddy
//
//  Created by 윤지호 on 12/20/23.
//

import SwiftUI

enum OnboardingType: String, Hashable,  CaseIterable {
    case firstTab
    case secondTab
    case thirdTab
    case fourthTab
}

struct OnboardingView: View {
    let allcase = OnboardingType.allCases
    @State private var nowState: OnboardingType = .firstTab
    @Binding var isFirstEntry: Bool
    
    func setTabView() {
        UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.myPrimary)
        UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.gray200)
    }

    var body: some View {
        VStack(spacing: 0) {
            Text(nowState.firstTitle)
                .font(.title06)
                .padding(.top, 63)
                .padding(.bottom, 10)

            Text(nowState.secondTitle)
                .font(.title06)
                .padding(.bottom, 10)

            Text(nowState.description)
                .font(.body04)
                .padding(.bottom, 27)

            TabView(selection: $nowState) {
                ForEach(allcase, id: \.self) { state in
                    Image(state.imageName)
                        .resizable()
                    
                }
                .frame(width: 195.84, height: 404)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .padding(.bottom, 20)

            TabView(selection: $nowState) {
                ForEach(allcase, id: \.self) { state in
                    Text("")
                }
                
            }
            .frame(height: 24)
            .tabViewStyle(.page(indexDisplayMode: .always))
            .padding(.bottom, 26)
            
            Button {
                switch nowState {
                case .firstTab:
                    nowState = .secondTab
                case .secondTab:
                    nowState = .thirdTab
                case .thirdTab:
                    nowState = .fourthTab
                case .fourthTab:
                    isFirstEntry = false
                    AuthStore.shared.isFirstEntry = false
                }
            } label: {
                Text("빌버디 시작하기")
                    .font(Font.body02)
            }
            .frame(width: 332, height: 52)
            .background(Color.myPrimary)
            .cornerRadius(12)
            .foregroundColor(.white)
            .padding(.bottom, 92)
        }
        .ignoresSafeArea(.all, edges: .bottom)
        .onAppear {
            setTabView()
        }
    }
}



extension OnboardingType {
    var imageName: String {
        switch self {
        case .firstTab:
            return "onboarding1"
        case .secondTab:
            return "onboarding2"
        case .thirdTab:
            return "onboarding3"
        case .fourthTab:
            return "onboarding4"
        }
    }
    
    var firstTitle: String {
        switch self {
        case .firstTab:
            return "함께하는 여행"
        case .secondTab:
            return "동선 보며"
        case .thirdTab:
            return "카테고리별"
        case .fourthTab:
            return "일행들과 채팅방에서"
        }
    }
    var secondTitle: String {
        switch self {
        case .firstTab:
            return "지출내역을 1/N로 관리해요"
        case .secondTab:
            return "지출 및 일정 확인해요"
        case .thirdTab:
            return "자세한 지출 확인해요"
        case .fourthTab:
            return "자유롭게 소통해요"
        }
    }
    var description: String {
        switch self {
        case .firstTab:
            return "일행별 지출내역을 입력하고 관리할 수 있어요"
        case .secondTab:
            return "어디에서 얼마를 썼는지 동선을 보며 확인해요"
        case .thirdTab:
            return "전체 지출은 물론, 카테고리 별 지출을 확인할 수 있어요"
        case .fourthTab:
            return "채팅방에서 공유한 사진을 모아볼 수 있어요"
        }
    }
}

#Preview {
    OnboardingView(isFirstEntry: .constant(true))
}
