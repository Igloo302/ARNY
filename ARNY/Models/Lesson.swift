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
    // 是否有顺序展开
    var isWithSteps: Bool
    var intro: String
    var imageName: String
    var score: Double
    var relatedLessons: [relatedLesson]

    struct relatedLesson: Codable, Hashable {
        var id: Int
    }
    
    var points : [point]
    
    struct point: Codable, Hashable, Identifiable {
        var name: String
        var id: Int
        var isNew: Bool
        var isWithAR: Bool
        var detail: String
        // 小图用于配合detail站时，大图针对basic模式展示
        var imageName: String
        var imageNameForBasic: String
        
        //相关知识点过于复杂，暂时不设计
//        var relatedPoints: [relatedPoint]
//
//        struct relatedPoint: Codable, Hashable {
//            var id: Int
//        }
    }

}

extension Lesson {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}

extension Lesson.point {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
    var imageForBasic: Image {
        ImageStore.shared.image(name: imageNameForBasic)
    }
}
