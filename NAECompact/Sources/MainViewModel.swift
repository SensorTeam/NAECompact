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
import CoreML
import Vision
import ImageIO

class MainViewModel: ObservableObject {

    @Published var image: UIImage? = nil
    @Published var boundingBox: CGRect? = nil
    @Published var detections: [Detection] = []

    var model: MLModel

    init(mlModel model: MLModel) {
        self.model = model
    }

    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: self.model)
            return VNCoreMLRequest(model: model) { [weak self] (request, error) in
                self?.processDetections(for: request, error: error)
            }

        } catch {
            fatalError("Failed to load ML model. \n\(error)")
        }
    }()

    private func processDetections(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }

            let detections = results as! [VNRecognizedObjectObservation]
            self.getProminentDetection(from: detections)
        }
    }

    private func getProminentDetection(from results: [VNRecognizedObjectObservation]) {
        if (!results.isEmpty) {
            self.detections = (results.first?.labels.map { label in
                Detection(
                    identifier: label.identifier,
                    confidence: label.confidence
                )
                })!
            self.boundingBox = results.first?.boundingBox
        } else {
            self.detections = [Detection]()
            self.boundingBox = nil
        }
    }

    func startClassification() {
        if (self.image != nil) {
            let orientation = CGImagePropertyOrientation(rawValue: UInt32(self.image!.imageOrientation.rawValue))

            guard let ciImage = CIImage(image: self.image!) else {
                fatalError("Unable to create \(CIImage.self) from \(String(describing: self.image))")
            }

            DispatchQueue.global(qos: .userInitiated).async {
                let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation ?? .up)
                do {
                    try handler.perform([self.classificationRequest])
                } catch {
                    print("Failed to perform classification.\n\(error.localizedDescription)")
                }
            }
        }
    }

}
