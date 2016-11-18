//
//  ChronoParsedResult.swift
//  chrono-swift
//
//  Created by Neil Sardesai on 2016-11-16.
//  Copyright © 2016 Neil Sardesai. All rights reserved.
//

import Foundation

struct ChronoParsedResult {
    
    private(set) var inputString: String?
    private(set) var indexOfStartingCharacterOfTimePhrase: Int?
    private(set) var timePhrase: String?
    private(set) var ignoredText: String?
    private(set) var referenceDate: Date?
    private(set) var startDate: Date?
    private(set) var endDate: Date?
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

extension ChronoParsedResult: CustomStringConvertible {
    
    var description: String {
        let inputStringDescription = self.inputString?.description ?? "nil"
        let indexOfStartingCharacterOfTimePhraseDescription = self.indexOfStartingCharacterOfTimePhrase?.description ?? "nil"
        let timePhraseDescription = self.timePhrase?.description ?? "nil"
        let ignoredTextDescription = self.ignoredText?.description ?? "nil"
        
        // Make the dates pretty
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        
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
