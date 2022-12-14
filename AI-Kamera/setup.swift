//
//  setup.swift
//  AI-Kamera
//
//  Created by Oskari Saarinen on 13.12.2022.
//

import Foundation

extension Float {
    var percentage_str: String { String((self * 10000.0).rounded() / 100.0) }
}
