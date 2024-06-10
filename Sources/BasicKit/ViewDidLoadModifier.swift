//
//  File.swift
//  
//
//  Created by Chandan on 10/06/24.
//

import SwiftUI

public struct ViewDidLoadModifier: ViewModifier {
    @State private var didLoad = false
    private let action: (() -> Void)
    
    public init(action: (@escaping () -> Void)) {
        self.action = action
    }
    
    public func body(content: Content) -> some View {
        content.onAppear {
            if didLoad {
                didLoad = true
                action()
            }
        }
    }
}
