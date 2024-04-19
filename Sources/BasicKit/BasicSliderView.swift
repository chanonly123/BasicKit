//
//  SwiftUIView.swift
//
//
//  Created by Chandan on 04/04/24.
//

import SwiftUI

public struct BasicSliderView: View {
    @Binding private var value: Double
    @State private var lastValue: Double?
    
    private var backColor = Color.gray
    private var fillColor = Color.green
    private let axis: Axis.Set
    private var horizontal: Bool { axis == .horizontal }
    private var middle = false
    let onEditingChanged: ((Bool)->Void)?
    
    public init(_ value: Binding<Double>, axis: Axis.Set = .horizontal, onEditingChanged: ((Bool)->Void)? = nil) {
        self.onEditingChanged = onEditingChanged
        self.axis = axis
        self._value = value
        self.lastValue = lastValue
    }
    
    public var body: some View {
        GeometryReader { gr in
            ZStack {
                Rectangle()
                    .foregroundColor(backColor)
                if horizontal {
                    if middle {
                        HStack {
                            Rectangle()
                                .foregroundColor(fillColor)
                                .frame(width: max(5, abs(value*gr.size.width/2)))
                                .offset(x: value*gr.size.width/4)
                        }
                    } else {
                        HStack {
                            Rectangle()
                                .foregroundColor(fillColor)
                                .frame(width: value * gr.size.width, height: gr.size.height)
                            Spacer()
                        }
                    }
                } else {
                    if middle {
                        HStack {
                            Rectangle()
                                .foregroundColor(fillColor)
                                .frame(height: max(5, abs(value*gr.size.height/2)))
                                .offset(y: -value*gr.size.height/4)
                        }
                    } else {
                        VStack{
                            Rectangle()
                                .foregroundColor(fillColor)
                                .frame(width: gr.size.width, height: value * gr.size.height)
                        }
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                }
            }
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { v in
                        if let lastValue {
                            let move = horizontal ? v.translation.width / gr.size.width : v.translation.height / -gr.size.height
                            
                            withAnimation(.easeInOut(duration: 0.1)) {
                                let value = lastValue + move
                                self.value = max(middle ? -1 : 0, min(1, value))
                            }
                        } else {
                            onEditingChanged?(true)
                            lastValue = value
                        }
                    }
                    .onEnded({ v in
                        lastValue = nil
                        onEditingChanged?(false)
                    })
            )
        }
    }
    
    public func backColor(_ color: Color) -> Self {
        var view = self
        view.backColor = color
        return view
    }
    
    public func fillColor(_ color: Color) -> Self {
        var view = self
        view.fillColor = color
        return view
    }
    
    public func middle(_ val: Bool) -> Self {
        var view = self
        view.middle = val
        return view
    }
}

fileprivate struct SliderViewPreview: View {
    @State var progress: Double = 0.5
    var body: some View {
        
        HStack {
            ZStack {
                BasicSliderView($progress, axis: .vertical, onEditingChanged: { editing in
                    print("editing", editing)
                })
                    .backColor(.gray)
                    .fillColor(.red)
                    .frame(width: 50, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text("\(Int(progress * 100))")
                    .foregroundColor(.white)
            }
            
            ZStack {
                BasicSliderView($progress, axis: .vertical)
                    .backColor(.gray)
                    .fillColor(.red)
                    .middle(true)
                    .frame(width: 50, height: 300)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                
                Text("\(Int(progress * 100))")
                    .foregroundColor(.white)
            }
        }
        
        ZStack {
            BasicSliderView($progress, axis: .horizontal)
                .backColor(.gray)
                .fillColor(.orange)
                .frame(width: 300, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text("\(progress)")
                .foregroundColor(.white)
        }
        
        ZStack {
            BasicSliderView($progress, axis: .horizontal)
                .backColor(.gray)
                .fillColor(.orange)
                .middle(true)
                .frame(width: 300, height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            
            Text("\(progress)")
                .foregroundColor(.white)
        }
    }
}

#Preview {
    SliderViewPreview()
}
