//
//  ViewController.swift
//  Chrono macOS
//
//  Created by Neil Sardesai on 2016-11-17.
//  Copyright © 2016 Neil Sardesai. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var discoveredDateLabel: NSTextField!
    @IBOutlet weak var inputField: NSTextField!
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        discoveredDateLabel.stringValue = ""
        inputField.delegate = self
    }

    func updateDiscoveredDateLabel() {
        let chrono = Chrono.shared
        let date = chrono.dateFrom(naturalLanguageString: inputField.stringValue)
        
        // Make the date pretty
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        guard let discoveredDate = date else {
            discoveredDateLabel.stringValue = ""
            return
        }
        
        discoveredDateLabel.stringValue = dateFormatter.string(from: discoveredDate)
    }


}

extension ViewController: NSTextFieldDelegate {
    
    override func controlTextDidChange(_ obj: Notification) {
        updateDiscoveredDateLabel()
    }
    
    
}

