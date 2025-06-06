//
//  ContentView.swift
//  Example
//
//  Created by yaochenfeng on 2025/6/7.
//

import DFBase
import DFService
import SwiftUI

struct ContentView: View {
    @Environment(\.appStore) var store
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
            Text("Hello, world!")
            Button("change Root") {
                store(.setRoot(AnyView(PageDemo())))
                print("Button clicked")
            }
            .padding()
        }
        .padding()
    }
}

struct PageDemo: View {
    @Environment(\.appStore) var store
    var body: some View {

        VStack {
            Text("Hello, world!")
                .padding()
            Button("Click Me") {
                store(.setRoot(AnyView(PageMe())))
                print("Button clicked")
            }
            .padding()
        }
    }
}

struct PageMe: View {

    var body: some View {

        VStack {
            Text("PageMe!")
                .padding()
            Button("Click Me") {

                print("Button clicked")
            }
            .padding()
        }
    }
}

#Preview {
    PagePrviewView{
        ContentView()
    }
}
