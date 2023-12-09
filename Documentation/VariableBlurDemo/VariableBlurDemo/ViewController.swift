//
//  ViewController.swift
//  VariableBlurDemo
//
//  Created by Eskil Gjerde Sviggum on 08/12/2023.
//

import UIKit
import VariableBlurImageView

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "VariableBlur Demo"
        
        let image = UIImage(resource: .variableBlurTest)
        
        let verticalBlurView = VariableBlurImageView()
        verticalBlurView.contentMode = .scaleAspectFit
        verticalBlurView.verticalVariableBlur(image: image, startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
        
        let horizontalBlurView = VariableBlurImageView()
        horizontalBlurView.contentMode = .scaleAspectFit
        horizontalBlurView.horizontalVariableBlur(image: image, startPoint: 0, endPoint: 200, startRadius: 7, endRadius: 0)
        
        let variableBlurView = VariableBlurImageView()
        variableBlurView.contentMode = .scaleAspectFit
        variableBlurView.variableBlur(image: image, startPoint: CGPoint(x: 50, y: 50), endPoint: CGPoint(x: 150, y: 150), startRadius: 7, endRadius: 0)
        
        
        let horizontalStack = UIStackView(arrangedSubviews: [
            makeVerticalStack(withTitle: "Vertical", view: verticalBlurView),
            makeVerticalStack(withTitle: "Horizontal", view: horizontalBlurView),
            makeVerticalStack(withTitle: "Between two points", view: variableBlurView),
        ])
        
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
    
    func makeVerticalStack(withTitle title: String, view: UIView) -> UIView {
        let label = UILabel()
        label.text = title
        
        let stackView = UIStackView(arrangedSubviews: [
            view,
            label
        ])
        stackView.axis = .vertical
        stackView.spacing = 8
        
        return stackView
    }


}

