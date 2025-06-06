//
//  ContentView.swift
//  Example
//
//  Created by yaochenfeng on 2025/6/7.
//

import SwiftUI
import DFService

struct SplashPageView: View {
    @Environment(\.appStore) var store

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Splash Page")

            Button("Go to Login Page") {
                store.dispatch(.setRoot(AnyView(LoginPageView())))
            }

            Button("send event") {
                // Example of sending an event
                let event = ServiceEvent(name: "exampleEvent", payload: "Hello, World!")
                ServiceManager.shared.sendEvent(event)
            }
        }
        .padding()
    }
}

struct LoginPageView: View {
    @Environment(\.appStore) var store

    var body: some View {
        VStack {
            Image(systemName: "lock")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Login Page")

            Button("Main") {
                // Perform login action
                store.dispatch(.setRoot(AnyView(MainPageView())))
            }
        }
        .padding()
    }
}

struct MainPageView: View {
    @Environment(\.appStore) var store

    var body: some View {
        VStack {
            Image(systemName: "house")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Main Page")

            Button("Go to Splash Page") {
                store.dispatch(.setRoot(AnyView(SplashPageView())))
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SplashPageView()
    }
}
