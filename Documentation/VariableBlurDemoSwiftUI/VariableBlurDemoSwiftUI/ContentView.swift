//
//  ContentView.swift
//  VariableBlurDemoSwiftUI
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import SwiftUI
import VariableBlurImageView

struct ContentView: View {
    var body: some View {
        VStack(alignment: .leading) {
            
            Text("VariableBlurImage View")
                .bold()
            
            HStack {
                #if canImport(UIKit)
                let image = UIImage(resource: .testAlpha)
                #elseif canImport(AppKit)
                let image = NSImage(resource: .testAlpha)
                #endif
                
                VStack {
                    VerticalVariableBlurImage(image: image, startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
                    Text("Vertical")
                }
                VStack {
                    HorizontalVariableBlurImage(image: image, startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
                    Text("Horizontal")
                }
                VStack {
                    VariableBlurImage(image: image, startPoint: CGPoint(x: 50, y: 50), endPoint: CGPoint(x: 150, y: 150), startRadius: 7, endRadius: 0)
                    Text("Between two points")
                }
            }
            
            if #available(iOS 16.0, macOS 13.0, *) {
                Text("Image Modifier")
                .bold()
            
                HStack {
                    VStack {
                        Image(.variableBlurTest)
                            .verticalVariableBlur(startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
                        Text("Vertical")
                    }
                    
                    VStack {
                        Image(.variableBlurTest)
                            .horizontalVariableBlur(startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
                        Text("Horizontal")
                    }
                    
                    VStack {
                        Image(.variableBlurTest)
                            .variableBlur(startPoint: CGPoint(x: 50, y: 50), endPoint: CGPoint(x: 150, y: 150), startRadius: 7, endRadius: 0)
                        Text("Between two points")
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
