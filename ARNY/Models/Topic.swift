//
//  Topic.swift
//  ARNY
//
//  Created by Igloo on 11/22/20.
//

import SwiftUI
import CoreLocation

struct Topic: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    fileprivate var imageName: String
    var intro: String
    var category: String
    var isNew: Bool
    var isWithAR: Bool
}

extension Topic {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}
