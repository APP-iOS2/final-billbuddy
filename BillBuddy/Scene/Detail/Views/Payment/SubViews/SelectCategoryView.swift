//
//  SelectCategorySheet.swift
//  BillBuddy
//
//  Created by 김유진 on 10/12/23.
//

import SwiftUI

struct SelectCategoryView: View {
    
    enum Mode {
        case category // 전체 x
        case sheet    // 전체 o
    }
    
    
    @State var mode: Mode
    
    @Binding var selectedCategory: Payment.PaymentType?
    
    var body: some View {
        HStack(spacing: 36) {
            if mode == .sheet {
                Button(action: {
                    selectedCategory = nil
                }, label: {
                    if selectedCategory == nil {
                        Text("전체")
                            .font(.custom("Pretendard-Medium", size: 12))
                            .foregroundStyle(Color.primary)
                    }
                    else {
                        Text("전체")
                            .font(.custom("Pretendard-Medium", size: 12))
                            .foregroundStyle(Color.black)
                    }
                })
                .buttonStyle(.plain)
            }
                
            ForEach(Payment.PaymentType.allCases, id:\.self) { type in
                Button(action: {
                        selectedCategory = type
                }, label: {
                    VStack {
                        if let selected = selectedCategory {
                            if selected == type {
                                Image(type.getImageString(type: .thin))
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color.primary)
                                Text(type.rawValue)
                                    .font(.custom("Pretendard-Medium", size: 12))
                                    .foregroundStyle(Color.primary)
                                    
                            }
                            else {
                                Image(type.getImageString(type: .thin))
                                    .resizable()
                                    .frame(width: 24, height: 24)
                                Text(type.rawValue)
                                    .font(.custom("Pretendard-Medium", size: 12))
                                    .foregroundStyle(Color(hex: "A9ABB8"))
                                
                            }
                        }
                        else {
                            Image(type.getImageString(type: .thin))
                                .resizable()
                                .frame(width: 24, height: 24)
                            Text(type.rawValue)
                                .font(.custom("Pretendard-Medium", size: 12))
                                .foregroundStyle(Color(hex: "A9ABB8"))
                            
                        }
                        
                        
                    }
                })
                .buttonStyle(.plain)
            }
        }
    }
}
