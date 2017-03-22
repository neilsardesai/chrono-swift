//
//  Chrono.swift
//  chrono-swift
//
//  Created by Neil Sardesai on 2016-11-16.
//  Copyright © 2016 Neil Sardesai. All rights reserved.
//

import Foundation
import JavaScriptCore

/// A singleton that contains methods for extracting date information from natural language phrases. Subclassing is not allowed.
final class Chrono {
    
    /// Use this property to get the shared singleton instance of `Chrono`
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
    
    /**
     Attempts to extract a date from a given natural language phrase. The reference date is assumed to be the current system date. 
     
     Example: If the current system date is November 20th, 2016 9:41 AM CST, and the natural language phrase is "2 days ago", the return `Date` will be November 18th, 2016 9:41 AM CST
     
     - Parameter naturalLanguageString: The input natural language phrase
     
     - Returns: A `Date` extracted from the input `naturalLanguageString`. If a `Date` could not be found, returns `nil`.
     */
    func dateFrom(naturalLanguageString: String) -> Date? {
        let results = parsedResultsFrom(naturalLanguageString: naturalLanguageString, referenceDate: nil)
        guard let date = results.startDate else { return nil }
        return date
    }
    
    /**
     Attempts to extract a date interval from a given natural language phrase. The reference date is assumed to be the current system date.
     
     Example: If the current system date is November 20th, 2016 9:41 AM CST, and the natural language phrase is "tomorrow from 3-4 PM", the return `DateInterval` will be November 21th, 2016 3:00 PM CST - November 21th, 2016 4:00 PM CST
     
     - Parameter naturalLanguageString: The input natural language phrase
     
     - Returns: A `DateInterval` extracted from the input `naturalLanguageString`. If a `DateInterval` could not be found, returns `nil`.
     */
    func dateIntervalFrom(naturalLanguageString: String) -> DateInterval? {
        let results = parsedResultsFrom(naturalLanguageString: naturalLanguageString, referenceDate: nil)
        guard let startDate = results.startDate, let endDate = results.endDate else { return nil }
        return DateInterval(start: startDate, end: endDate)
    }
    
    /**
     Attempts to extract a date from a given natural language phrase. A reference date is required. If you want to use the current system date as the reference date, use `dateFrom(naturalLanguageString:)` instead.
     
     Example: If the reference date is October 18th, 2016 9:41 AM CST, and the natural language phrase is "2 days ago", the return `Date` will be October 16th, 2016 9:41 AM CST
     
     - Parameter naturalLanguageString: The input natural language phrase
     - Parameter referenceDate: The reference date used to calculate the return `Date`
     
     - Returns: A `Date` extracted from the input `naturalLanguageString` and calculated based on the `referenceDate`. If a `Date` could not be found, returns `nil`.
     */
    func dateFrom(naturalLanguageString: String, referenceDate: Date) -> Date? {
        let results = parsedResultsFrom(naturalLanguageString: naturalLanguageString, referenceDate: referenceDate)
        guard let date = results.startDate else { return nil }
        return date
    }
    
    /**
     Attempts to extract a date interval from a given natural language phrase. A reference date is required. If you want to use the current system date as the reference date, use `dateIntervalFrom(naturalLanguageString:)` instead.
     
     Example: If the reference date is October 18th, 2016 9:41 AM CST, and the natural language phrase is "tomorrow from 3-4 PM", the return `DateInterval` will be October 19th, 2016 3:00 PM - October 19th, 2016 4:00 PM.
     
     - Parameter naturalLanguageString: The input natural language phrase
     - Parameter referenceDate: The reference date used to calculate the return `DateInterval`
     
     - Returns: A `DateInterval` extracted from the input `naturalLanguageString` and calculated based on the `referenceDate`. If a `DateInterval` could not be found, returns `nil`.
     */
    func dateIntervalFrom(naturalLanguageString: String, referenceDate: Date) -> DateInterval? {
        let results = parsedResultsFrom(naturalLanguageString: naturalLanguageString, referenceDate: referenceDate)
        guard let startDate = results.startDate, let endDate = results.endDate else { return nil }
        return DateInterval(start: startDate, end: endDate)
    }
    
    // MARK: Detailed Parsed Results
    
    /**
     Attempts to extract date information from a given natural language phrase and returns a `ChronoParsedResult` with detailed results about the extracted date information. You can optionally pass in a reference date for date calculations. If no reference date is passed in, the reference date is assumed to be the current system date.
     
     - Parameter naturalLanguageString: The input natural language phrase
     - Parameter referenceDate: The reference date used to calculate date information. If you specify `nil` for this parameter, `referenceDate` is assumed to be the current system date.
     
     - Returns: A `ChronoParsedResult` with details about extracted date information
     */
    func parsedResultsFrom(naturalLanguageString: String, referenceDate: Date?) -> ChronoParsedResult {
        context.setObject(naturalLanguageString, forKeyedSubscript: "naturalLanguageString" as NSString)        
        
        if let referenceDate = referenceDate {
            // Get year, month, day from referenceDate
            context.setObject(referenceDate, forKeyedSubscript: "referenceDate" as NSString)
            context.evaluateScript("var results = chrono.parse(naturalLanguageString, referenceDate);")
        }
        else {
            // Reference date is automatically current date if referenceDate is nil
            context.evaluateScript("var results = chrono.parse(naturalLanguageString);")
        }
        
        // Position in natural language string where time phrase starts
        let index = context.evaluateScript("results[0].index;")
        var indexOfStartingCharacterOfTimePhrase: Int?
        if index!.description != "undefined" {
            indexOfStartingCharacterOfTimePhrase = Int(index!.toInt32())
        }
        
        // Separate time phrase from rest of input string
        let text = context.evaluateScript("results[0].text;")
        var timePhrase: String?
        var ignoredText: String?
        if text!.description != "undefined" {
            timePhrase = text!.toString()
            
            // Filter out (on/in) + (the) + timePhrase            
            let timePhrasePattern = "(?>\\s*)*(\\bon|\\bin)*(?>\\s*)*(\\bthe)*(?>\\s*)*\(timePhrase!)(?>\\s*[[:punct:]]*\\s*)*"
            let timePhraseRegex = try! NSRegularExpression(pattern: timePhrasePattern, options: .caseInsensitive)
            ignoredText = timePhraseRegex.stringByReplacingMatches(in: naturalLanguageString, options: [], range: NSRange(0..<naturalLanguageString.utf16.count), withTemplate: " ")
                                    
            ignoredText = ignoredText?.trimmingCharacters(in: .whitespacesAndNewlines)
        }                
        
        // Reference date used by Chrono
        let ref = context.evaluateScript("results[0].ref;")
        var referenceDateFromContext: Date?
        if ref!.description != "undefined" {
            referenceDateFromContext = ref!.toDate()
        }
        
        // Date discovered in time phrase. In the case of a date range, this is the start date.
        let start = context.evaluateScript("results[0].start.date();")
        var startDate: Date?
        if start!.description != "undefined" {
            startDate = start!.toDate()
        }
        
        // In the case of a date range, this is the end date.
        let end = context.evaluateScript("results[0].end.date();")
        var endDate: Date?
        if end!.description != "undefined" {
            endDate = end!.toDate()
        }
        
        // Create date interval in the case of a date range
        var dateInterval: DateInterval?
        if let startDate = startDate, let endDate = endDate {
            dateInterval = DateInterval(start: startDate, end: endDate)
        }
        
        return ChronoParsedResult(inputString: naturalLanguageString, indexOfStartingCharacterOfTimePhrase: indexOfStartingCharacterOfTimePhrase, timePhrase: timePhrase, ignoredText: ignoredText, referenceDate: referenceDateFromContext, startDate: startDate, endDate: endDate, dateInterval: dateInterval)
    }
    
    
}
