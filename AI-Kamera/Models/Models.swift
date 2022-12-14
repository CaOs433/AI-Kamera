//
//  Models.swift
//  AI-Kamera
//
//  Created by Oskari Saarinen on 4.12.2022.
//

import Foundation

let COREML_MODELS: [Model] = [
    Model(
        name: "Facemask",
        description: "Detects if a person has a facemask and is it weared correctly."
    ),
    Model(
        name: "License plate",
        description: "Detects car license plates."
    ),
]

struct Model: Identifiable {
    let name: String
    let description: String
    var id: String { name.lowercased().replacingOccurrences(of: " ", with: "_") }
}
