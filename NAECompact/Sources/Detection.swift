//
//  Detection.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 16/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import Foundation
import CoreGraphics

struct Detection {
    var id = UUID()
    var identifier: String
    var confidence: Float = Float.random(in: 0..<0.25)
    var boundingBox: CGRect? = nil
}
