//
//  LicenseView.swift
//  BillBuddy
//
//  Created by 박지현 on 10/24/23.
//

import SwiftUI

struct LicenseView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var licenseStore: LicenseStore = .init()
    @State private var isPresentedSheet: Bool = false
    @State private var seletedLicense: PakageLicense = .init(name: "", contend: "")
    var body: some View {
        ZStack{
            Color.gray050
            VStack {
                Spacer().frame(height: 8)
                Group {
                    HStack {
                        Text("버전")
                            .font(.body02)
                        Spacer()
                        Text("ver 1.0.0")
                            .multilineTextAlignment(.trailing)
                            .font(.body04)
                            .foregroundColor(Color.gray600)
                    }
                    .padding(16)
                    .frame(width: 361, height: 52)
                    
                    
                    List {
                        ForEach(licenseStore.licenses) { license in
                            Button(license.name) {
                                seletedLicense = license
                                isPresentedSheet = true
                            }
                            .font(.body04)
                            .foregroundColor(Color.gray600)
                        }
                    }
                    .background(Color.gray050)
                    .scrollContentBackground(.hidden)
                }
                .background(.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray100, lineWidth: 1)
                )
                .padding(.top, 16)
                Spacer()
            }
        }
        .sheet(isPresented: $isPresentedSheet) {
            VStack(alignment: .leading) {
                Group {
                    Text(seletedLicense.name)
                        .padding(16)
                        .font(.title06)
                }
                
                Group {
                    Section {
                        Text(seletedLicense.contend)
                            .font(.body04)
                    }
                }
                .padding(25)
                
            }
            
        }
        .navigationTitle("오픈소스 라이센스")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image("arrow_back")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.systemBlack)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        LicenseView()
    }
}
