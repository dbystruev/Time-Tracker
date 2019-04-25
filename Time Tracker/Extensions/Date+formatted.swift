//
//  Date+formatted.swift
//  Time Tracker
//
//  Created by Denis Bystruev on 16/04/2019.
//  Copyright © 2019 Denis Bystruev. All rights reserved.
//

import Foundation

extension Date {
    var formatted: String {
        let formatter = DateFormatter()
        
        formatter.locale = Locale.current
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
    
    func formatted(with date: Date) -> String {
        let isSameDay = Calendar.current.isDate(self, inSameDayAs: date)
        let formatter = DateFormatter()
        
        formatter.dateStyle = isSameDay ? .none : .short
        formatter.locale = Locale.current
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
