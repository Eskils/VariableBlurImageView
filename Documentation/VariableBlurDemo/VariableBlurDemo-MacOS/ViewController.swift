//
//  ViewController.swift
//  VariableBlurDemo-MacOS
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import Cocoa
import VariableBlurImageView

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VariableBlur Demo"

        let image = NSImage(resource: .variableBlurTest)
        
        let verticalBlurView = VariableBlurImageView()
        verticalBlurView.imageScaling = .scaleProportionallyUpOrDown
        verticalBlurView.verticalVariableBlur(image: image, startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
        
        let horizontalBlurView = VariableBlurImageView()
        horizontalBlurView.imageScaling = .scaleProportionallyUpOrDown
        horizontalBlurView.horizontalVariableBlur(image: image, startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
        
        let variableBlurView = VariableBlurImageView()
        variableBlurView.imageScaling = .scaleProportionallyUpOrDown
        variableBlurView.variableBlur(image: image, startPoint: CGPoint(x: 50, y: 50), endPoint: CGPoint(x: 150, y: 150), startRadius: 7, endRadius: 0)
        
        let horizontalStack = NSStackView(views: [
            makeVerticalStack(withTitle: "Vertical", view: verticalBlurView),
            makeVerticalStack(withTitle: "Horizontal", view: horizontalBlurView),
            makeVerticalStack(withTitle: "Between two points", view: variableBlurView),
        ])
        
        horizontalStack.orientation = .horizontal
        horizontalStack.distribution = .fillEqually
        horizontalStack.spacing = 16
        
        self.view.addSubview(horizontalStack)
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
            horizontalStack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            horizontalStack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            verticalBlurView.widthAnchor.constraint(equalTo: verticalBlurView.heightAnchor),
            horizontalBlurView.widthAnchor.constraint(equalTo: horizontalBlurView.heightAnchor),
            variableBlurView.widthAnchor.constraint(equalTo: variableBlurView.heightAnchor),
        ])
    }
    
    func makeVerticalStack(withTitle title: String, view: NSView) -> NSView {
        let label = NSTextField(labelWithString: title)
        
        let stackView = NSStackView(views: [
            view,
            label
        ])
        stackView.orientation = .vertical
        stackView.spacing = 8
        
        return stackView
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

