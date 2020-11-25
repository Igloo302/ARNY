//
//  Topic.swift
//  ARNY
//
//  Created by Igloo on 11/22/20.
//

import SwiftUI
import CoreLocation

struct Subject: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var imageName: String
    var intro: String
    var category: String
    var isNew: Bool
    var isWithAR: Bool
}

extension Subject {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}
