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
        self.view.backgroundColor = .systemGroupedBackground
        
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
        
        let gradientBlurView = VariableBlurImageView()
        gradientBlurView.contentMode = .scaleAspectFit
        gradientBlurView.gradientBlur(image: image, gradientImage: UIImage(resource: .gradient), maxRadius: 7)
        
        let multipleBlursView = VariableBlurImageView()
        multipleBlursView.contentMode = .scaleAspectFit
        multipleBlursView.multipleBlurs(image: image, descriptions: [
            VariableBlurDescription(startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 0, y: 100), startRadius: 7, endRadius: 0),
            VariableBlurDescription(startPoint: CGPoint(x: 0, y: 256), endPoint: CGPoint(x: 0, y: 156), startRadius: 7, endRadius: 0),
        ])
        
        
        let stack = UIStackView(arrangedSubviews: [
            makeHorizontalStack([
                makeVerticalStack(withTitle: "Vertical", view: verticalBlurView),
                makeVerticalStack(withTitle: "Horizontal", view: horizontalBlurView),
            ]),
            makeHorizontalStack([
                makeVerticalStack(withTitle: "Between two points", view: variableBlurView),
                makeVerticalStack(withTitle: "Gradient", view: gradientBlurView),
            ]),
            makeHorizontalStack([
                makeVerticalStack(withTitle: "Multiple", view: multipleBlursView),
                UIView()
            ]),
        ])
        stack.axis = .vertical
        stack.spacing = 16
        stack.backgroundColor = .systemGroupedBackground
        
        let scrollView = UIScrollView()
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            stack.leadingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: scrollView.frameLayoutGuide.trailingAnchor, constant: -16),
            stack.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -16),
            
            verticalBlurView.widthAnchor.constraint(equalTo: verticalBlurView.heightAnchor),
            horizontalBlurView.widthAnchor.constraint(equalTo: horizontalBlurView.heightAnchor),
            variableBlurView.widthAnchor.constraint(equalTo: variableBlurView.heightAnchor),
            gradientBlurView.widthAnchor.constraint(equalTo: gradientBlurView.heightAnchor),
            multipleBlursView.widthAnchor.constraint(equalTo: multipleBlursView.heightAnchor),
        ])
        
    }
    
    func makeHorizontalStack(_ views: [UIView]) -> UIStackView {
        let horizontalStack = UIStackView(arrangedSubviews: views)
        horizontalStack.distribution = .fillEqually
        horizontalStack.spacing = 16
        return horizontalStack
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

