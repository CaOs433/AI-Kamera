//
//  CameraViewControllerDetector.swift
//  AI-Kamera
//
//  Created by Oskari Saarinen on 4.12.2022.
//

import Vision
import AVFoundation
import UIKit

extension CameraViewController {
    
    func setupDetector() {
        let modelURL = Bundle.main.url(forResource: self.modelFileName, withExtension: "mlmodelc")
    
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: modelURL!))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print(error)
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async(execute: {
            if let results = request.results {
                self.extractDetections(results)
            }
        })
    }
    
    func extractDetections(_ results: [VNObservation]) {
        detectionLayer.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                print("No object recognized")
                continue
            }
            
            print("Object recognized:")
            var results: [String:Float] = [:]
            for label in objectObservation.labels {
                results[label.identifier] = label.confidence
                
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
                print("identifier: \(label.identifier)")
                print("confidence: \(label.confidence)")
                print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")
            }
            
            var labelStr = ""
            if let maxValueElement = results.max(by: { a, b in a.value < b.value }) {
                print(maxValueElement)
                labelStr = "\(maxValueElement.key)\n\(maxValueElement.value.percentage_str)%"
            }
            
            // Transformations
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
            let transformedBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            
            let boxLayer = self.drawBoundingBox(transformedBounds, labelStr: labelStr)

            detectionLayer.addSublayer(boxLayer)
        }
    }
    
    func setupLayers() {
        detectionLayer = CALayer()
        let frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        detectionLayer.frame = frame
        print("frame: \(frame)")
        self.view.layer.addSublayer(detectionLayer)
    }
    
    func updateLayers() {
        detectionLayer?.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
    }
    
    func drawBoundingBox(_ bounds: CGRect, labelStr: String) -> CATextLayer /*CALayer*/ {
        let detectionBoxLayer = CATextLayer()
        detectionBoxLayer.frame = bounds
        detectionBoxLayer.string = labelStr
        detectionBoxLayer.isWrapped = true
        detectionBoxLayer.truncationMode = .end
        detectionBoxLayer.fontSize = 18
        detectionBoxLayer.font = CGFont("Courier-Bold" as CFString)!
        detectionBoxLayer.alignmentMode = .left
        detectionBoxLayer.backgroundColor = CGColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 0.2)
        detectionBoxLayer.foregroundColor = UIColor.green.cgColor
        detectionBoxLayer.borderWidth = 3.0
        detectionBoxLayer.borderColor = UIColor.green.cgColor
        detectionBoxLayer.cornerRadius = 4.0
        
        return detectionBoxLayer
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .up, options: [:]) // Create handler to perform request on the buffer

        do {
            try imageRequestHandler.perform(self.requests) // Schedules vision requests to be performed
        } catch {
            print(error)
        }
    }
}
