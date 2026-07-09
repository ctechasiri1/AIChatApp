//
//  Binding+EXT.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 7/8/26.
//

import Foundation
import SwiftUI

extension Binding where Value == Bool {
    init<T: Sendable>(ifNotNil value: Binding<T?>) {
        self.init {
            return value.wrappedValue != nil
        } set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        }
    }
}
