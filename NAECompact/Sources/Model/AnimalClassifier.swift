//  Copyright © 2020 Carlos Melegrito. All rights reserved.
//

import Foundation
import CoreML
import Vision
import ImageIO
import CoreImage
import UIKit

class AnimalClassifier {

    // turn into an Observable object

    enum Error: Swift.Error {
        case noResults(Swift.Error?)
    }

    let model: MLModel = Possums().model

    private var workQueue = DispatchQueue(label: "Animal Classifier", qos: .userInitiated, attributes: [], autoreleaseFrequency: .inherit, target: nil)

    typealias ResultHandler = (Result<(detections: [Detection], boundingBox: CGRect), Error>) -> Void

    /// - Parameters:
    ///   - handler: Called with result of classification (on arbitary queue)
    func startClassification(for image: UIImage, handler: @escaping ResultHandler) {
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(String(describing: image))")
        }

        let model: VNCoreMLModel
        do {
            model = try VNCoreMLModel(for: self.model)
        } catch {
            fatalError("Failed to load ML model: \(error)")
        }

        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))

        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let observations = request.results as? [VNRecognizedObjectObservation], observations.isEmpty == false else {
                handler(.failure(.noResults(error)))
                return
            }

            let firstObservation = observations.first!
            let detections = firstObservation.labels.map {
                Detection(identifier: $0.identifier, confidence: $0.confidence)
            }

            let boundingBox = firstObservation.boundingBox


            handler(.success((detections: detections, boundingBox: boundingBox)))
        }

        workQueue.async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation ?? .up)
            do {
                try handler.perform([request])
            } catch {
                // TODO handle errors
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
}
