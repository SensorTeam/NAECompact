//
//  UserDefaults+Keys.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 17/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import Foundation

extension UserDefaults {
    private struct Keys {
        static let usesRealModel = "UsesRealModel"
    }

    static var usesRealModel: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.usesRealModel)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Keys.usesRealModel)
        }
    }
}
