//
//  SwiftUIView.swift
//  
//
//  Created by yaochenfeng on 2024/9/26.
//

import SwiftUI

public struct PageBar: View {
    @Environment(\.router) var router
    @Environment(\.routeRequest) var request
    
    private var titleView: AnyView
    private var backgroundView: AnyView
    private var leadingView: AnyView
    private var trailingView: AnyView
    private var showBack: Bool = true
    
    
    public var body: some View {
        ZStack {
            backgroundView
                .ignoresSafeArea(edges:.top)
            
            HStack {
                HStack {
                    if showBack, router.canPop() {
                        Button {
                            router.pop()
                        } label: {
                            Image(systemName: backName)
                        }

                    }
                    leadingView
                    Spacer()
                }
                
                HStack {
                    titleView
                }
                
                HStack {
                    Spacer()
                    trailingView
                }
            }.padding(.horizontal)
        }
        .frame(height: 44)
        .frame(maxWidth: .infinity)
            
    }
    
    public init(
        showBack: Bool,
        @ViewBuilder titleView: () -> some View,
         @ViewBuilder backgroundView: () -> some View,
         @ViewBuilder leadingView: () -> some View,
         @ViewBuilder trailingView: () -> some View) {
            self.titleView = AnyView(titleView())
            self.backgroundView = AnyView(backgroundView())
            self.leadingView = AnyView(leadingView())
            self.trailingView = AnyView(trailingView())
            self.showBack = showBack
    }
    
    
    private var backName: String {
        request.routeType == .present ? "xmark.circle.fill" : "chevron.left"
    }
}

public extension PageBar {
    init(_ title: String,
         backgroundColor: Color = .white, showBack: Bool = true) {
        self.init (showBack: showBack){
            Text(title)
                .font(.title3)
                .lineLimit(1)
        } backgroundView: {
            backgroundColor
        } leadingView: {
            
        } trailingView: {
            
        }
    }
    
    
    func pageBarTitle(@ViewBuilder builder: () -> some View) -> Self {
        var clone = self
        clone.titleView = AnyView(builder())
        return clone
    }
    
    func pageBarLeading(@ViewBuilder builder: () -> some View) -> Self {
        var clone = self
        clone.leadingView = AnyView(builder())
        return clone
    }
    
    func pageBarTrailing(@ViewBuilder  builder: () -> some View) -> Self {
        var clone = self
        clone.trailingView = AnyView(builder())
        return clone
    }
    
    func pageBarBackgroud(@ViewBuilder builder: () -> some View) -> Self {
        var clone = self
        clone.backgroundView = AnyView(builder())
        return clone
    }
    func pageBar(showBack: Bool) -> Self {
        var clone = self
        clone.showBack = showBack
        return clone
    }
}

struct PageBar_Previews: PreviewProvider {
    static var previews: some View {
        PageBar("adsfas地方的")
            .pageBarLeading {
                Text("返回")
                Text("走吧")
            }
    }
}
