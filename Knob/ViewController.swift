//
//  ViewController.swift
//  Knob
//
//  Created by Christopher Frank on 10.11.17.
//  Copyright © 2017 krisdigital. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet weak var knob: Knob!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = NSImage.init(named: "fender_knob.png") {
            knob.knobImage = image
            knob.value = 1
        }
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func didChange(_ sender: Knob) {
        NSLog("%f", sender.value)
    }
}

