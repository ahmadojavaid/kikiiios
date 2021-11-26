//
//  PageControll.swift
//  HireSecurity
//
//  Created by abbas on 2/3/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit

class PageControl: UIPageControl {
    private struct Constants {
        static let activeColor: UIColor = #colorLiteral(red: 0.9819075465, green: 0.4551108479, blue: 0, alpha: 1)
        static let inactiveColor: UIColor = #colorLiteral(red: 0.9819075465, green: 0.4551108479, blue: 0, alpha: 1)
        static let currentImage: UIImage = UIImage(named: "circule_filed")!
        static let otherImage: UIImage = UIImage(named: "circule")!
    }
    //UIPageControl(frame: CGRect(x: 0,y: UIScreen.main.bounds.maxY - Theme.adjustRatio(50.0),width: Theme.screenWidth(),height: Theme.adjustRatio(50.0)))
    // Update dots when currentPage changes
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.pageIndicatorTintColor = .clear
        self.currentPageIndicatorTintColor = .clear
        self.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override var currentPage: Int {
        didSet {
            updateDots()
        }
    }

    func updateDots() {
        for (index, view) in self.subviews.enumerated() {
            // Layers will be redrawn, remove old.
            view.layer.sublayers?.removeAll()
            if index == self.currentPage {
                //drawImage(view: view)
                drawImage(view: view, image: Constants.currentImage)
            } else {
                drawImage(view: view, image: Constants.otherImage)
            }
        }
    }

    private func drawDot(index: Int, view: UIView) {
        let dotLayer = CAShapeLayer()
        dotLayer.path = UIBezierPath(ovalIn: view.bounds).cgPath
        dotLayer.fillColor = getColor(index: index)

        view.layer.addSublayer(dotLayer)
    }

    private func drawImage(view: UIView, image:UIImage) {
        let height = view.bounds.height * 1.2
        let width = view.bounds.width * 1.2
        let topMargin: CGFloat = -3.5

        let maskLayer = CALayer()
        maskLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)
        maskLayer.contents = image.cgImage
        maskLayer.contentsGravity = .resizeAspect

        let imageLayer = CALayer()
        imageLayer.frame = CGRect(x:0, y: topMargin, width: width, height: height)
        imageLayer.mask = maskLayer
        imageLayer.backgroundColor = getColor()

        view.backgroundColor = .clear // Otherwise black background
        view.layer.addSublayer(imageLayer)
    }

    private func getColor(index: Int? = 0) -> CGColor {
        return currentPage == index ? Constants.activeColor.cgColor : Constants.inactiveColor.cgColor
    }
}
