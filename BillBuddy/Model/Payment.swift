//
//  Payment.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/22.
//  2023/09/27. 13:40

import Foundation
import FirebaseFirestoreSwift
/// 결제 - 추가, 또는 수정 시 리얼타임 베이스에 갱신일 최신화
struct Payment: Identifiable, Codable {
    @DocumentID var id: String?
    
    var type: PaymentType
    var content: String
    var payment: Int
    let address: Address
    var participants: [Participant]
    var paymentDate: Double
    
    struct Address: Codable {
        let address: String
        /// 위도
        let latitude: Double
        /// 경도
        let longitude: Double
    }
    
    struct Participant: Codable, Hashable {
        var memberId: String
        var payment: Int
    }
    
    ///  case에 직접 String을 넣어주면 안된다는 멘토링을 들었던것같은데 저렇게 안하면 저장에문제가 생김
    ///    하면 안좋은 이유가 궁금함.
    enum PaymentType: String, CaseIterable, Codable {
        case transportation = "교통"
        case accommodation = "숙박"
        case tourism = "관광"
        case food = "식비"
        case etc = "기타"
        
        
        var typeString: String {
            switch self {
            case .transportation:
                return "교통"
            case .accommodation:
                return "숙박"
            case .tourism:
                return "관광"
            case .food:
                return "식비"
            case .etc:
                return "기타"
            }
        }
        
        static func fromRawString(_ rawString: String) -> PaymentType {
               switch rawString {
               case "교통":
                   return .transportation
               case "숙박":
                   return .accommodation
               case "관광":
                   return .tourism
               case "식비":
                   return .food
               default:
                   return .etc
               }
           }
        
    }
    
}
