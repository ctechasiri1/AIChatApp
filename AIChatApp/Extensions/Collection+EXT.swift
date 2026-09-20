//
//  Collection+EXT.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 9/15/26.
//

import IdentifiableByString
import Foundation

extension Collection {
    func first(upTo value: Int) -> [Element]? {
        guard !isEmpty else { return nil }
        
        let maxItems = Swift.min(count, value)
        return Array(prefix(maxItems))
    }
    
    func last(upTo value: Int) -> [Element]? {
        guard !isEmpty else { return nil }
        
        let maxItems = Swift.min(count, value)
        return Array(suffix(maxItems))
    }
}
