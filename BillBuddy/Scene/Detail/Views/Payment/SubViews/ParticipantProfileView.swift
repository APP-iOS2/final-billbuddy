//
//  ParticipantProfileView.swift
//  BillBuddy
//
//  Created by 김유진 on 10/5/23.
//

import SwiftUI

struct ProfileImageView: View {
    @State var uiImage: UIImage
    var body: some View {
        Image(uiImage: uiImage)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(100)
            .frame(width: 30)
    }
}

struct ParticipantProfileView: View {
    @State var payment: Payment
    @ObservedObject var memberStore: MemberStore
    let defaultImageName: String = "glass"
    let imageSize: CGFloat = 30
    
    var body: some View {
        VStack {
//            ForEach(<memberStore.findMembersByParticipants(participants: payment.participants)) { participant in
//                ProfileImageView(uiImage: UIImage(named: defaultImageName) ?? UIImage())
//            }
            
            Image(uiImage: combineCircleImages(images: circleImages(images: Array(repeating: UIImage(named: "glass"), count: payment.participants.count))) ?? UIImage())
                .resizable()
                .aspectRatio(contentMode: .fit)
        }
    }
    
    func circleImages(images: [UIImage?]) -> [UIImage?] {
        var resultImages: [UIImage?] = []
        
        for image in images {
            guard let image else {
                continue
            }
            
            let size = CGSize(width: imageSize, height: imageSize)
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            
            let rect = CGRect(x: 0, y: 0, width: imageSize, height: imageSize)
            let circlePath = UIBezierPath(ovalIn: rect)
            circlePath.addClip()
            
            image.draw(in: rect)
            
            let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            resultImages.append(combinedImage)
        }
        
        return resultImages
    }
    
    func combineCircleImages(images: [UIImage?])-> UIImage? {
        let betweenSize: CGFloat = 10
        let size = CGSize(width: imageSize + CGFloat(images.count - 1) * betweenSize, height: imageSize)
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        
        let path = UIBezierPath()
        
        for (idx, image) in images.enumerated() {
            guard let image = image else {
                continue
            }
            let rect = CGRect(x: CGFloat(idx) * betweenSize, y: 0, width: imageSize, height: imageSize)
            let rectPath = UIBezierPath(ovalIn: rect)
            
            path.append(rectPath)
            
            image.draw(in: rect)
        }
        path.addClip()
        
        let combinedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return combinedImage
    }
}

#Preview {
    ParticipantProfileView(payment: Payment(type: .accommodation, content: "", payment: 0, address: Payment.Address(address: "", latitude: 0, longitude: 0), participants: [Payment.Participant(memberId: "", payment: 0), Payment.Participant(memberId: "", payment: 0), Payment.Participant(memberId: "", payment: 0)
                                                                                                                                                                           ], paymentDate: 0), memberStore: MemberStore(travelCalculationId: "4eB3HvBvH6jXYDLu9irl"))
}
