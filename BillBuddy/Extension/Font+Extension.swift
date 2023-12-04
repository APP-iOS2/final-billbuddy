//
//  Font+Extension.swift
//  BillBuddy
//
//  Created by 윤지호 on 2023/09/25.
//

import Foundation
import SwiftUI

extension Font {
    
    /// Bold / 40
    static var headline1: Font {
        return Font.custom("Pretendard-Bold", size: 40)
    }
    /// Bold / 38
    static var title01: Font {
        return Font.custom("Pretendard-Bold", size: 38)
    }
    /// Bold / 36
    static var title02: Font {
        return Font.custom("Pretendard-Bold", size: 36)
    }
    /// Bold / 32
    static var title03: Font {
        return Font.custom("Pretendard-Bold", size: 32)
    }
    /// Bold / 26
    static var title04: Font {
        return Font.custom("Pretendard-Bold", size: 26)
    }
    /// Bold / 18
    static var title05: Font {
        return Font.custom("Pretendard-Bold", size: 18)
    }
    /// SemiBold / 16
    static var body01: Font {
        return Font.custom("Pretendard-SemiBold", size: 16)
    }
    /// Bold / 14
    static var body02: Font {
        return Font.custom("Pretendard-Bold", size: 14)
    }
    /// SemiBold / 14
    static var body03: Font {
        return Font.custom("Pretendard-SemiBold", size: 14)
    }
    /// Medium / 14
    static var body04: Font {
        return Font.custom("Pretendard-Medium", size: 14)
    }
    /// Bold / 12
    static var caption01: Font {
        return Font.custom("Pretendard-Bold", size: 12)
    }
    /// Medium / 12
    static var caption02: Font {
        return Font.custom("Pretendard-Medium", size: 12)
    }
    /// Bold / 10
    static var caption03: Font {
        return Font.custom("Pretendard-Bold", size: 10)
    }
    /// SFPro / 20
    static var semibold01: Font {
        return Font.custom("SF-Pro-Display-Semibold", size: 20)
    }
    /// SFPro / 20
    static var semibold02: Font {
        return Font.custom("SF-Pro-Rounded-Semibold", size: 20)
    }
    /// SFPro / 20
    static var semibold03: Font {
        return Font.custom("SF-Pro-Text-Semibold", size: 20)
    }
}
