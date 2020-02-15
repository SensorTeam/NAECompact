//
//  MainViewModel.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 16/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import SwiftUI
import Combine
import UIKit

class MainViewModel: ObservableObject {

    @Published var image: UIImage? = nil
    @Published var boundingBox: CGRect? = nil
    @Published var detections: [Detection] = []

    func setImage() {
        self.image = UIImage(named: "Possum")
    }

    func setDetections() {
        self.detections = [
            Detection(identifier: "possum", confidence: 1.0, boundingBox: CGRect(x: 0.25, y: 0.25, width: 0.5, height: 0.5)),
            Detection(identifier: "fox"),
            Detection(identifier: "cat"),
            Detection(identifier: "cow"),
            Detection(identifier: "sheep")
        ]
        self.boundingBox = self.detections.first?.boundingBox
    }

}
