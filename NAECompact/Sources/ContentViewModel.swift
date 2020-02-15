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
    @Published var confidence: Float = 0.0
    @Published var boundingBox: CGRect? = nil

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
        var prominentDetectionBoundingBox: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)

        for detection in detections {
            for label in detection.labels {
                if (label.confidence > prominentDetectionConfidence) {
                    prominentDetectionConfidence = label.confidence
                    prominentDetection = label.identifier
                    prominentDetectionBoundingBox = detection.boundingBox
                }
            }
        }

        self.confidence = prominentDetectionConfidence
        self.label = prominentDetection
        self.boundingBox = prominentDetectionBoundingBox
    }

    func startPredictClassification() {
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

    func reset() {
        self.uiImage = nil
        self.label = ""
        self.confidence = 0.0
        self.boundingBox = nil
    }

}
