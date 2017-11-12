//
//  Knob.swift
//  Knob
//
//  Created by Christopher Frank on 10.11.17.
//  Copyright © 2017 krisdigital. All rights reserved.
//

import AppKit
import QuartzCore

func degreesToRad(deg: Float) -> Float {
    return deg / 180 * .pi;
}

@IBDesignable open class Knob: NSControl {
    fileprivate var _value: Float = -1.0
    fileprivate var knobImageView: NSImageView = NSImageView()
    fileprivate var _knobImage: NSImage?
    
    open var value: Float {
        get { return _value }
        set { setValue(newValue, animated: false) }
    }
    
    open var startAngle: Float = degreesToRad(deg: -150)
    open var endAngle: Float = degreesToRad(deg: 140)
    open var minimumValue: Float = 0.0
    open var maximumValue: Float = 1.0
    open var turnSpeed: Float = 3000.0
    
    @IBInspectable open var knobImage: NSImage {
        get { return _knobImage! }
        set {
            _knobImage = newValue
            self.knobImageView.image = _knobImage!
        }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setup()
    }
    
    func setup() {
        self.wantsLayer = true
        self.knobImageView.imageScaling = NSImageScaling.scaleProportionallyUpOrDown
        self.addSubview(self.knobImageView)
        self.knobImageView.translatesAutoresizingMaskIntoConstraints = false
        self.knobImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        self.knobImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        self.knobImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        self.knobImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        addGestureRecognizer(NSPanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:))))
    }
    
    
    func handleGesture(gestureRecognizer: NSPanGestureRecognizer) {
        let y: Float = Float(gestureRecognizer.velocity(in: self).y)
        setValue(value + y/turnSpeed, animated: false)
    }
    
    open func setValue(_ value: Float, animated: Bool) {
        if(value != self.value) {
            _value = min(self.maximumValue, max(self.minimumValue, value))
            
            if let action = self.action {
                NSApp.sendAction(action, to: self.target, from: self)
            }
            
            DispatchQueue.main.async {
                self.updateKnob()
            }
        }
    }
    
    func updateKnob() -> Void {
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angle = min(endAngle, max(startAngle, (value - minimumValue) / valueRange * angleRange + startAngle))
        
        
        self.knobImageView.layer?.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.knobImageView.layer?.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.knobImageView.layer?.transform = CATransform3DMakeRotation(CGFloat(-angle), 0, 0, 1)
    }
    
}
