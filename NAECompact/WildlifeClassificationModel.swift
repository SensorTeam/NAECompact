//
//  WildlifeClassificationModel.swift
//  NAECompact
//
//  Created by Carlos Melegrito on 13/2/20.
//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

final class WildlifeClassificationModel: ObservableObject {

    @Published var image: UIImage? = nil
    @Published var label: String = ""

    var model: MLModel = WildlifeClassifier().model

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
            fatalError("Error: Failed to load ML Model. \(error)")
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
        // For now, iterate through all detections and print the outputs
        for detection in detections {
            print("\(detection)")
        }
    }

    func startClassification() {
        self.label = "Detecting..."
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(self.image!.imageOrientation.rawValue))

        guard let ciImage = CIImage(image: self.image!) else {
            fatalError("Unable to create \(CIImage.self) from \(String(describing: image))")
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
