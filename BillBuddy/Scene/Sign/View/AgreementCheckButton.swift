//
//  AgreementCheckButton.swift
//  BillBuddy
//
//  Created by 박지현 on 10/17/23.
//

import SwiftUI
import WebKit

struct AgreementCheckButton: View {
    @Binding var agreement: Bool
    @State var text: String
    
    @State var isShowingSafari: Bool = false
    var termsWebView = "https://cut-hospital-213.notion.site/5e186613d1024010ad528f6ade1f09ae?pvs=4"

    var body: some View {
        HStack {
            Button(action: {
                agreement.toggle()
            }, label: {
                HStack {
                    Image(agreement ? "selected" : "enabled")
                        .resizable()
                        .foregroundColor(.gray300)
                        .frame(width: 24, height: 24)
                    Text(text)
                }
            }).buttonStyle(.plain)
                .font(.body04)
                .frame(height: 24)
            Spacer()
            Button {
                isShowingSafari = true
            } label: {
                Image("chevron_right_gray")
                    .frame(width: 24, height: 24)
            }
        }
        .sheet(isPresented: $isShowingSafari, content: {
            WebView(url: termsWebView)
        })
    }
}

struct WebView: UIViewRepresentable {
    var url: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: url) else {
            return WKWebView()
        }
        let webView = WKWebView()

        webView.load(URLRequest(url: url))

        return webView
    }

    func updateUIView(_ webView: WKWebView, context: UIViewRepresentableContext<WebView>) {
        guard let url = URL(string: url) else { return }

        webView.load(URLRequest(url: url))
    }
}


#Preview {
    AgreementCheckButton(agreement: .constant(true), text: "동의합니다")
}
