//
//  ChronoParsedResult.swift
//  chrono-swift
//
//  Created by Neil Sardesai on 2016-11-16.
//  Copyright © 2016 Neil Sardesai. All rights reserved.
//

import Foundation

/// A struct that contains details about a parsed result from a call to `Chrono`'s `parsedResultsFrom(naturalLanguageString:referenceDate:)` method. You should not create instances of `ChronoParsedResult` yourself.
struct ChronoParsedResult {
    
    /// The input natural language phrase
    private(set) var inputString: String?
    /// If the input natural language phrase were converted to an `Array` of `Character`s, this would be the index of the first `Character` of the discovered time phrase
    private(set) var indexOfStartingCharacterOfTimePhrase: Int?
    /// The discovered time phrase in the input natural language phrase
    private(set) var timePhrase: String?
    /// Text that was not part of the time phrase and was ignored
    private(set) var ignoredText: String?
    /// The reference date used for calculating `startDate`
    private(set) var referenceDate: Date?
    /// The date discovered in the input natural language phrase. If the time phrase in the natural language phrase describes an interval between two `Date`s, this is the start date of that interval
    private(set) var startDate: Date?
    /// If the time phrase in the input natural language phrase describes an interval between two `Date`s, this is the end date of that interval
    private(set) var endDate: Date?
    /// If the time phrase in the input natural language phrase describes an interval between two `Date`s, this is that `DateInterval`
    private(set) var dateInterval: DateInterval?
    
    init(inputString: String?, indexOfStartingCharacterOfTimePhrase: Int?, timePhrase: String?, ignoredText: String?, referenceDate: Date?, startDate: Date?, endDate: Date?, dateInterval: DateInterval?) {
        self.inputString = inputString
        self.indexOfStartingCharacterOfTimePhrase = indexOfStartingCharacterOfTimePhrase
        self.timePhrase = timePhrase
        self.ignoredText = ignoredText
        self.referenceDate = referenceDate
        self.startDate = startDate
        self.endDate = endDate
        self.dateInterval = dateInterval
    }
    
    
}

// Overriding output of `print(ChronoParsedResult)` to make it more useful
extension ChronoParsedResult: CustomStringConvertible {
    
    var description: String {
        let inputStringDescription = self.inputString?.description ?? "nil"
        let indexOfStartingCharacterOfTimePhraseDescription = self.indexOfStartingCharacterOfTimePhrase?.description ?? "nil"
        let timePhraseDescription = self.timePhrase?.description ?? "nil"
        let ignoredTextDescription = self.ignoredText?.description ?? "nil"
        
        // Make the dates pretty
        let locale = Locale(identifier: "en_US")
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        dateFormatter.locale = locale
        
        var referenceDateDescription = "nil"
        if let referenceDate = self.referenceDate {
            referenceDateDescription = dateFormatter.string(from: referenceDate)
        }
        
        var startDateDescription = "nil"
        if let startDate = self.startDate {
            startDateDescription = dateFormatter.string(from: startDate)
        }
        
        var endDateDescription = "nil"
        if let endDate = self.endDate {
            endDateDescription = dateFormatter.string(from: endDate)
        }
        
        var dateIntervalDescription = "nil"
        if let dateInterval = self.dateInterval {
            let dateIntervalFormatter = DateIntervalFormatter()
            dateIntervalFormatter.dateStyle = .long
            dateIntervalFormatter.timeStyle = .long
            dateIntervalDescription = dateIntervalFormatter.string(from: dateInterval)!
        }        
        
        return "inputString: \(inputStringDescription)\nindexOfStartingCharacterOfTimePhrase: \(indexOfStartingCharacterOfTimePhraseDescription)\ntimePhrase: \(timePhraseDescription)\nignoredText: \(ignoredTextDescription)\nreferenceDate: \(referenceDateDescription)\nstartDate: \(startDateDescription)\nendDate: \(endDateDescription)\ndateInterval: \(dateIntervalDescription)"
    }
    
    
}
