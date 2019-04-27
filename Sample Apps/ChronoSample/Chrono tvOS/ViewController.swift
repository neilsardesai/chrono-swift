//
//  ViewController.swift
//  Chrono tvOS
//
//  Created by Neil Sardesai on 2016-11-17.
//  Copyright © 2016 Neil Sardesai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet weak var discoveredDateLabel: UILabel!
    @IBOutlet weak var inputField: UITextField!
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        discoveredDateLabel.text = ""
        inputField.addTarget(self, action: #selector(updateDiscoveredDateLabel), for: .editingChanged)
    }
    
    @objc func updateDiscoveredDateLabel() {
        let chrono = Chrono.shared
        let date = chrono.dateFrom(naturalLanguageString: inputField.text!)
        
        // Make the date pretty
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
        guard let discoveredDate = date else {
            discoveredDateLabel.text = ""
            return
        }
        
        discoveredDateLabel.text = dateFormatter.string(from: discoveredDate)
    }
 
    
}

