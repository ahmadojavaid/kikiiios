//
//  APSwitch.swift
//  TheICERegister
//
//  Created by abbas on 5/21/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
class APSwitch: UIControl {
    public var padding: CGFloat = 1 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var onTintColor = UIColor(red: 144/255, green: 202/255, blue: 119/255, alpha: 1) {
        didSet {
            self.setupUI()
        }
    }
    public var offTintColor = UIColor.lightGray {
        didSet {
            self.setupUI()
        }
    }
    public var cornerRadiuss: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var thumbTintColor = UIColor.white {
        didSet {
            self.thumbView.backgroundColor = self.thumbTintColor
        }
    }
    public var thumbCornerRadius: CGFloat = 0.5 {
        didSet {
            self.layoutSubviews()
        }
    }
    public var thumbSize = CGSize.zero {
        didSet {
            self.layoutSubviews()
        }
    }
    
    //override var bounds: CGRect {
    //    didSet{
    //        thumbSize = self.frame.size
    //    }
    //}
    
    public var isOn = true
    public var animationDuration: Double = 0.5
    
    fileprivate var thumbView = UIView(frame: CGRect.zero)
    fileprivate var onPoint = CGPoint.zero
    fileprivate var offPoint = CGPoint.zero
    fileprivate var isAnimating = false
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isAnimating {
            self.layer.cornerRadius = self.bounds.size.height * self.cornerRadiuss
            self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
            
            // thumb managment
            let thumbSize = self.thumbSize != CGSize.zero ? self.thumbSize : CGSize(width:
                self.bounds.size.height - 2, height: self.bounds.height - 2)
            let yPostition = (self.bounds.size.height - thumbSize.height) / 2
            
            self.onPoint = CGPoint(x: self.bounds.size.width - thumbSize.width - self.padding, y: yPostition)
            self.offPoint = CGPoint(x: self.padding, y: yPostition)
            
            self.thumbView.frame = CGRect(origin: self.isOn ? self.onPoint : self.offPoint, size: thumbSize)
            
            self.thumbView.layer.cornerRadius = thumbSize.height * self.thumbCornerRadius
        }
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        super.beginTracking(touch, with: event)
        self.animate()
        return true
    }
    
    func setupUI() {
        self.clear()
        self.clipsToBounds = false
        self.thumbView.backgroundColor = self.thumbTintColor
        self.thumbView.isUserInteractionEnabled = false
        self.thumbView.layer.shadowColor = UIColor.black.cgColor
        self.thumbView.layer.shadowRadius = 1.5
        self.thumbView.layer.shadowOpacity = 0.4
        self.thumbView.layer.shadowOffset = CGSize(width: 0.75, height: 2)
        self.addSubview(self.thumbView)
        
    }
    
    private func animate() {
        self.isOn = !self.isOn
        self.isAnimating = true
        UIView.animate(withDuration: self.animationDuration, delay: 0, usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0.5, options: [UIView.AnimationOptions.curveEaseOut,
                                                             UIView.AnimationOptions.beginFromCurrentState], animations: {
                                                                self.thumbView.frame.origin.x = self.isOn ? self.onPoint.x : self.offPoint.x
                                                                self.backgroundColor = self.isOn ? self.onTintColor : self.offTintColor
        }, completion: { _ in
            self.isAnimating = false
            self.sendActions(for: UIControl.Event.valueChanged)
        })
    }
    
    private func clear() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
    }
    
}

class SwitchTests {
    func testSwitch() {
        //let myCustomSwitch = APSwitch(frame: CGRect(x: 50, y: 50, width: 50, height: 30))
        //self.view.addSubview(myCustomSwitch)
    }
}
