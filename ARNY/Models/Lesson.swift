/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The model for a lesson.
*/

import SwiftUI

struct Lesson: Codable, Hashable, Identifiable {
    var name: String
    var category: String
    var id: Int
    var isNew: Bool
    var isWithAR: Bool
    var intro: String
    fileprivate var imageName: String
    var score: Double
    var relatedLessons: [relatedLesson]

    struct relatedLesson: Codable, Hashable {
        var id: Int
    }
}

extension Lesson {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}
