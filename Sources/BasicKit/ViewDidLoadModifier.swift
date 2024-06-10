//
//  File.swift
//  
//
//  Created by Chandan on 10/06/24.
//

import SwiftUI

struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)
    
    init(action: (@escaping () -> Void)) {
        self.action = action
    }
    
    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad {
                didLoad = true
                action()
            }
        }
    }
}

public extension View {
    func onViewDidLoad(perform action: @escaping (()->Void)) -> some View {
        modifier(ViewDidLoadModifier(action: action))
    }
}
