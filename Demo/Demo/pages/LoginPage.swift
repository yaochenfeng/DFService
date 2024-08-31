//
//  LoginPage.swift
//  Demo
//
//  Created by yaochenfeng on 2024/8/31.
//

import SwiftUI

struct LoginPage: View {
    @Environment(\.application) var app
    var body: some View {
        VStack {
            Text("登录")
            Button {
                app.state.isLogin = true
                app.bootstrap(.window)
            } label: {
                Text("确定")
            }

        }.padding()
        
    }
}

struct LoginPage_Previews: PreviewProvider {
    static var previews: some View {
        LoginPage()
    }
}
