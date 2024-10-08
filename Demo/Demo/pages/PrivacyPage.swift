//
//  PrivacyPage.swift
//  Demo
//
//  Created by yaochenfeng on 2024/8/31.
//

import DFService

struct PrivacyPage: View {
    @Environment(\.application) var app
    var body: some View {
        PageLayout {
            VStack {
                Text("隐私协议")
                Button {
                    app.state.agreePrivacy = true
                    app.bootstrap(.window)
                } label: {
                    Text("同意隐私协议")
                }
                
                Button {
                    PageEnum.web.go(url: URL(string: "https://m.baidu.com") ,
                                    routeType: .present)
                } label: {
                    Text("阅读隐私协议")
                }
                
            }.padding()
        }
        
    }
}

struct PrivacyPage_Previews: PreviewProvider {
    static var previews: some View {
        PrivacyPage()
    }
}
