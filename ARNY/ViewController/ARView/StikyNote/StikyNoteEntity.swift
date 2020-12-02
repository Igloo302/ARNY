/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 An entity used to house the AR screen space annotation.
 */

import ARKit
import RealityKit

/// An Entity which has an anchoring component and a screen space view component, where the screen space view is a StickyNoteView.
class StickyNoteEntity: Entity, HasScreenSpaceView {
    // ...
    
    var screenSpaceComponent = ScreenSpaceComponent()
    
    /// Initializes a new StickyNoteEntity and assigns the specified transform.
    /// Also automatically initializes an associated StickyNoteView with the specified frame.
    init(frame: CGRect, worldTransform: simd_float4x4, offset: SIMD3<Float>? = [0,0,0]) {
        super.init()
        
        // 可视化StickyNoteEntity的位置
//        let testboxMesh = MeshResource.generateSphere(radius: 0.025)
//        let testbox = ModelEntity(mesh: testboxMesh)
//        testbox.name = "testbox"
//        self.addChild(testbox)
        
        self.transform.matrix = worldTransform
        
        // 偏移
        self.position += offset ?? [0,0,0]
        // ...
        screenSpaceComponent.view = StickyNoteView(frame: frame, note: self)
    }
    required init() {
        fatalError("init() has not been implemented")
    }
}
