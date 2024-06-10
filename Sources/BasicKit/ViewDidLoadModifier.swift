//
//  File.swift
//  
//
//  Created by Chandan on 10/06/24.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @Binding private var didLoad: Bool
    private let action: (() -> Void)
    
    init(didLoad: Binding<Bool>, action: (@escaping () -> Void)) {
        self._didLoad = didLoad
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if !didLoad {
                didLoad = true
                action()
            }
        }
    }
}

public extension View {
    func onViewDidLoad(didLoad: Binding<Bool>, perform action: @escaping (()->Void)) -> some View {
        modifier(ViewDidLoadModifier(didLoad: didLoad, action: action))
    }
}
