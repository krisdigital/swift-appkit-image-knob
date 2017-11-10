//
//  Knob.swift
//  Knob
//
//  Created by Christopher Frank on 10.11.17.
//  Copyright © 2017 krisdigital. All rights reserved.
//

import AppKit

open class Knob: NSControl {
    fileprivate var _value: Float = 0.0
    fileprivate var backgroundImageView: NSImageView = NSImageView()
    fileprivate var knobImageView: NSImageView = NSImageView()
    fileprivate var backingKnobImagePath: String?
    fileprivate var _backgroundImagePath: String?
    
    open var value: Float {
        get { return _value }
        set { setValue(newValue, animated: false) }
    }
    
    open var startAngle: Float = -150
    open var endAngle: Float = 140
    open var minimumValue: Float = 0.0
    open var maximumValue: Float = 1.0
    open var turnSpeed: Float = 3000.0
    
    open var knobImagePath: String {
        get { return backingKnobImagePath! }
        set {
            self.knobImageView.image = NSImage.init(named: newValue)
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
        self.addSubview(self.backgroundImageView)
        self.addSubview(self.knobImageView)
        
        self.backgroundImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        self.knobImageView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        addGestureRecognizer(NSPanGestureRecognizer(target: self, action: #selector(handleGesture(gestureRecognizer:))))
        setValue(maximumValue, animated: false)
    }
    
    func handleGesture(gestureRecognizer: NSPanGestureRecognizer) {
        let y: Float = Float(gestureRecognizer.velocity(in: self).y)
        setValue(value + y/turnSpeed, animated: false)
    }
    
    open func setValue(_ value: Float, animated: Bool) {
        if(value != self.value) {
            _value = min(self.maximumValue, max(self.minimumValue, value))
            
            let angleRange = endAngle - startAngle
            let valueRange = maximumValue - minimumValue
            let angle = min(endAngle, max(startAngle, (value - minimumValue) / valueRange * angleRange + startAngle))
            if let action = self.action {
             NSApp.sendAction(action, to: self.target, from: self)
            }
            self.knobImageView.frameCenterRotation = CGFloat(-angle)
        }
    }
    
}
