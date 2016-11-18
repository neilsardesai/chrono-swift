//
//  Chrono.swift
//  chrono-swift
//
//  Created by Neil Sardesai on 2016-11-16.
//  Copyright © 2016 Neil Sardesai. All rights reserved.
//

import Foundation
import JavaScriptCore

class Chrono {
    
    static let shared = Chrono()
    private var context: JSContext
    
    private init() {
        // Create JavaScript environment
        context = JSContext()
        
        // Load chrono.min.js
        let path = Bundle.main.path(forResource: "chrono.min", ofType: "js")
        let url = URL(fileURLWithPath: path!)
        var chronoJSSource = try! String(contentsOf: url, encoding: .utf8)
        
        // Won't work without this
        chronoJSSource = "var window = this;\n \(chronoJSSource)"
        
        // Evaluate chrono.min.js
        context.evaluateScript(chronoJSSource)
    }
    
    // MARK: Convenience Methods
    
    func dateFrom(naturalLanguageString: String) -> Date? {
        let results = parsedResultsFrom(naturalLanguageString: naturalLanguageString)
        guard let date = results.startDate else { return nil }
        return date
    }
    
    func dateIntervalFrom(naturalLanguageString: String) -> DateInterval? {
        let results = parsedResultsFrom(naturalLanguageString: naturalLanguageString)
        guard let startDate = results.startDate, let endDate = results.endDate else { return nil }
        return DateInterval(start: startDate, end: endDate)
    }
    
    // MARK: Detailed Parsed Results
    
    func parsedResultsFrom(naturalLanguageString: String) -> ChronoParsedResult {
        context.evaluateScript("var naturalLanguageString = '\(naturalLanguageString)'")
        context.evaluateScript("var results = chrono.parse(naturalLanguageString)")
        
        // Position in natural language string where time phrase starts
        let index = context.evaluateScript("results[0].index")
        var indexOfStartingCharacterOfTimePhrase: Int? = nil
        if index!.description != "undefined" {
            indexOfStartingCharacterOfTimePhrase = Int(index!.toInt32())
        }
        
        // Separate time phrase from rest of input string
        let text = context.evaluateScript("results[0].text")
        var timePhrase: String? = nil
        var ignoredText: String? = nil
        if text!.description != "undefined" {
            timePhrase = text!.toString()
            ignoredText = naturalLanguageString.replacingOccurrences(of: timePhrase!, with: "")
        }
        
        // Reference date is current system date
        let ref = context.evaluateScript("results[0].ref")
        var referenceDate: Date? = nil
        if ref!.description != "undefined" {
            referenceDate = ref!.toDate()
        }
        
        // Date discovered in time phrase. In the case of a date range, this is the start date.
        let start = context.evaluateScript("results[0].start.date()")
        var startDate: Date? = nil
        if start!.description != "undefined" {
            startDate = start!.toDate()
        }
        
        // In the case of a date range, this is the end date.
        let end = context.evaluateScript("results[0].end.date()")
        var endDate: Date? = nil
        if end!.description != "undefined" {
            endDate = end!.toDate()
        }
        
        // Create date interval in the case of a date range
        var dateInterval: DateInterval? = nil
        if let startDate = startDate, let endDate = endDate {
            dateInterval = DateInterval(start: startDate, end: endDate)
        }
        
        return ChronoParsedResult(inputString: naturalLanguageString, indexOfStartingCharacterOfTimePhrase: indexOfStartingCharacterOfTimePhrase, timePhrase: timePhrase, ignoredText: ignoredText, referenceDate: referenceDate, startDate: startDate, endDate: endDate, dateInterval: dateInterval)
    }
    
    
}
