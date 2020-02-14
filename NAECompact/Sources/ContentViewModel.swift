//
//  ContentViewModel.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 14/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import UIKit
import SwiftUI
import CoreML
import Vision
import ImageIO

class ContentViewModel: ObservableObject {

    @Published var uiImage: UIImage? = nil
    @Published var label: String = ""

    var model: MLModel

    init(model: MLModel) {
        self.model = model
    }

    private lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: self.model)
            return VNCoreMLRequest(model: model) { [weak self] (request, error) in
                self?.processDetections(for: request, error: error)
            }
        } catch {
            fatalError("Failed to load ML model. \(error)")
        }
    }()

    private func processDetections(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.label = "None Detected"
                return
            }

            let detections = results as! [VNRecognizedObjectObservation]
            self.getProminentDetection(detections: detections)
        }
    }

    private func getProminentDetection(detections: [VNRecognizedObjectObservation]) {
        var prominentDetection: String = ""
        var prominentDetectionConfidence: Float = 0.0

        for detection in detections {

            for label in detection.labels {
                print("\(label.identifier)")
                print("\(label.confidence)")

                if (label.confidence > prominentDetectionConfidence) {
                    prominentDetectionConfidence = label.confidence
                    prominentDetection = label.identifier
                }
            }

            print("\(detection.confidence)")
            print("\(detection.boundingBox)")
            print("--------")
            print("minX \(detection.boundingBox.minX)")
            print("minY \(detection.boundingBox.minY)")
            print("width \(detection.boundingBox.width)")
            print("height \(detection.boundingBox.height)")
        }

        self.label = prominentDetection
    }

    func startPredictClassification() {
        self.label = "Detecting..."
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(self.uiImage!.imageOrientation.rawValue))

        guard let ciImage = CIImage(image: self.uiImage!) else {
            fatalError("Unable to create \(CIImage.self) from \(String(describing: self.uiImage))")
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
