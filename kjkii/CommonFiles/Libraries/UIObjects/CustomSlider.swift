//
//  CustomSlider.swift
//  Polse
//
//  Created by abbas on 2/19/20.
//  Copyright © 2020 abbas. All rights reserved.
//

import UIKit
//protocol CustomSliderDelegate:class {
//    func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
//}
class CustomSlider: UISlider
{
    //weak var delegate:CustomSliderDelegate?
    
    @IBInspectable open var trackWidth:CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    /*
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        delegate?.touchesEnded(touches, with: event)
    } */
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
    
}
