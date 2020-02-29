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

    // Convert Classifier into a Publisher that doesn't block the main thread

    let willChange = PassthroughSubject<Void, Never>()

    @Published var boundingBox: CGRect? = nil
    @Published var detections: [Detection] = []

    var classifier = AnimalClassifier()

    var usesRealModel: Bool = UserDefaults.usesRealModel {
        willSet {
            UserDefaults.usesRealModel = newValue
            willChange.send()
        }
    }

    func startClassification(for image: UIImage) {
        classifier.startClassification(for: image) { result in
            DispatchQueue.main.async {
                switch result {
                    case let .failure(error):
                        self.detections = []
                        self.boundingBox = nil

                        print(error)
                        break
                    case let .success(observation):
                        self.detections = observation.detections
                        self.boundingBox = observation.boundingBox
                        break
                }
            }
        }
    }

}
