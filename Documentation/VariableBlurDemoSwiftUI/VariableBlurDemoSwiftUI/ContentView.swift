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
        ScrollView {
            VStack(alignment: .leading) {
                
                Text("VariableBlurImage View")
                    .bold()
                
                VStack {
                    #if canImport(UIKit)
                    let image = UIImage(resource: .testAlpha)
                    let gradientImage = UIImage(resource: .gradient)
                    #elseif canImport(AppKit)
                    let image = NSImage(resource: .testAlpha)
                    let gradientImage = NSImage(resource: .gradient)
                    #endif
                    
                    HStack {
                        VStack {
                            VerticalVariableBlurImage(image: image, startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
                            Text("Vertical")
                        }
                        VStack {
                            HorizontalVariableBlurImage(image: image, startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
                            Text("Horizontal")
                        }
                    }
                    HStack {
                        VStack {
                            VariableBlurImage(image: image, startPoint: CGPoint(x: 50, y: 50), endPoint: CGPoint(x: 150, y: 150), startRadius: 7, endRadius: 0)
                            Text("Between two points")
                        }
                        VStack {
                            GradientBlurImage(image: image, gradientImage: gradientImage, maxRadius: 7)
                            Text("Gradient")
                        }
                    }
                    HStack {
                        VStack {
                            MultipleBlursImage(image: image, descriptions: [
                                VariableBlurDescription(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 100), startRadius: 7, endRadius: 0),
                                VariableBlurDescription(startPoint: CGPoint(x: 0, y: 256), endPoint: CGPoint(x: 0, y: 156), startRadius: 7, endRadius: 0),
                            ])
                            Text("Multiple")
                        }
                        Spacer()
                    }
                }
                
                if #available(iOS 16.0, macOS 13.0, *) {
                    Text("Image Modifier")
                        .bold()
                    
                    VStack {
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
                        }
                        
                        HStack {
                            VStack {
                                Image(.variableBlurTest)
                                    .variableBlur(startPoint: CGPoint(x: 50, y: 50), endPoint: CGPoint(x: 150, y: 150), startRadius: 7, endRadius: 0)
                                Text("Between two points")
                            }
                            
                            VStack {
                                Image(.variableBlurTest)
                                    .gradientBlur(gradientImage: Image(.gradient), maxRadius: 7)
                                Text("Gradient")
                            }
                        }
                        
                        HStack {
                            VStack {
                                Image(.variableBlurTest)
                                    .multipleBlurs(descriptions: [
                                        VariableBlurDescription(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 100), startRadius: 7, endRadius: 0),
                                        VariableBlurDescription(startPoint: CGPoint(x: 0, y: 256), endPoint: CGPoint(x: 0, y: 156), startRadius: 7, endRadius: 0),
                                    ])
                                Text("Multiple")
                            }
                            Spacer()
                        }
                    }
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
