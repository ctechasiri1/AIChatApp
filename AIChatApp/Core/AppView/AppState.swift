//
//  AppState.swift
//  AIChatApp
//
//  Created by Chiraphat Techasiri on 6/10/26.
//

import Foundation
import Observation

@Observable
class AppState {
    private(set) var showTabBar: Bool {
        didSet {
            UserDefaults.showTabBarView = showTabBar
        }
    }
    
    init(showTabBar: Bool = UserDefaults.showTabBarView) {
        self.showTabBar = showTabBar
    }
    
    func updateViewState(showTabBarView: Bool) {
        showTabBar = showTabBarView
    }
}

extension UserDefaults {
    private struct Keys {
        static let showTabbarView = "showTabBarView"
    }
    
    static var showTabBarView: Bool {
        get {
            standard.bool(forKey: Keys.showTabbarView)
        } set {
            standard.set(newValue, forKey: Keys.showTabbarView)
        }
    }
}
