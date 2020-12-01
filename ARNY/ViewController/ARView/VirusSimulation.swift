//import UIKit
//import ARKit
//import RealityKit
//
//extension ARViewController {
//    func virusSimulation() {
//
//        //        // 设置口罩固定并开启碰撞
//        // RC
//        //        let mask = lesson1004Anchor.goodMask
//        //        mask!.generateCollisionShapes(recursive: true)
//        //        mask!.components[PhysicsBodyComponent] = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .static)
//
//
//
//
//        // 起点锚定
//        let testboxMesh = MeshResource.generatePlane(width: 0, depth: 0)
//        let testbox = ModelEntity(mesh: testboxMesh)
//        testbox.transform.translation.z  += 0.4
//        lesson1004Anchor.addChild(testbox)
//
//        //let virus = lesson1004Anchor.virus as! Entity & HasPhysics & HasCollision
//        //var viruses = [virus]
//
//
//        // 碰撞测试探针
//        let box1 = CustomEntity(
//            color: .yellow,
//            position: [0,0,0]
//        )
//
//        box1.components[PhysicsBodyComponent] = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .dynamic)
//        //box1.components[ModelComponent] = virus.components[ModelComponent]
//        box1.generateCollisionShapes(recursive: true)
//
//        testbox.addChild(box1)
//        // 开启碰撞检测
//        box1.addCollisions()
//
//        box1.addForce([0,0,-10], relativeTo: self.lesson1004Anchor)
//
//
//
//
//
//
//        let virusnew = (virus.clone(recursive: true))
//        // 锚定
//        box1.addChild(virusnew)
//        virusnew.position = [0,0,0]
//
////        //生成2个病毒🦠
////        var temp = 1
////        while temp <= 1 {
////            let virusnew = (virus.clone(recursive: true))
////
//////            let  NwNumber1 = Float.randomFloatNumber(lower: -0.1, upper: 0.1)
//////            let  NwNumber2 = Float.randomFloatNumber(lower: -0.1, upper: 0.1)
//////            virusnew.transform.translation = [NwNumber1,NwNumber2,0]
////
////            virusnew.components[PhysicsBodyComponent] = PhysicsBodyComponent(massProperties: .default, material: nil, mode: .dynamic)
////            //svirusnew.generateCollisionShapes(recursive: true)
////
////            // 锚定
////            box1.addChild(virusnew)
////            virusnew.position = [0,0,0]
////
////            // 便于查找
////            viruses.append(virusnew)
////
////            temp += 1
////        }
//
//
////        var collisionSubs: [Cancellable] = []
////
////
////        DispatchQueue.main.asyncAfter(deadline: .now() + 2){
////
////            for virus in viruses {
////
////                //virus.addForce([0,0,-Float.randomFloatNumber(lower: 0.01, upper: 0.03)], relativeTo: self.lesson1004Anchor)
////                virus.addForce([0,0,-10], relativeTo: self.lesson1004Anchor)
////
////                collisionSubs.append(self.arView.scene.subscribe(to: CollisionEvents.Began.self, on: virus) { event in
////                    print(event.entityA.name)
////                    print(event.entityB.name)
////
////                    let kinematics: PhysicsBodyComponent = .init(massProperties: .default,material: nil,mode: .kinematic)
////                    let motion: PhysicsMotionComponent = .init(linearVelocity: [0 , 0, 0])
////                    event.entityA.components.set(kinematics)
////                    event.entityA.components.set(motion)
////
////                    // 遭遇口罩😷
////                    if event.entityB.name == "GoodMask" {
////                    }
////                })
////                collisionSubs.append(self.arView.scene.subscribe(to: CollisionEvents.Ended.self, on: virus) { event in
////                    print(event.entityA.name)
////                    print(event.entityB.name)
////                })
////
////            }
////        }
//
//
//
//        //
//        //        let kinematics: PhysicsBodyComponent = .init(massProperties: .default,
//        //                                                     material: nil,
//        //                                                     mode: .kinematic)
//        //
//        //let motion: PhysicsMotionComponent = .init(linearVelocity: [0 , -0.1, 0])
//
//        //let motion: PhysicsMotionComponent = .init(linearVelocity: [0.1 ,0, 0], angularVelocity: [3, 3, 3])
//
//
//
//
//
//
//
//
//    }
//}
//
//
//
//public extension Float {
//    static func randomFloatNumber(lower: Float = 0,upper: Float = 100) -> Float {
//        return (Float(arc4random()) / Float(UInt32.max)) * (upper - lower) + lower
//    }
//}
//
//
//class CustomEntity: Entity, HasModel, HasPhysics, HasCollision {
//
//    var collisionSubs: [Cancellable] = []
//
//    required init(color: UIColor) {
//        super.init()
//
//        self.components[CollisionComponent] = CollisionComponent(
//            shapes: [.generateBox(size: [0.01,0.01,0.01])],
//            mode: .trigger,
//            filter: .sensor
//        )
//
//        self.components[ModelComponent] = ModelComponent(
//            mesh: .generateBox(size: [0.01,0.01,0.01]),
//            materials: [SimpleMaterial(
//                            color: color,
//                            isMetallic: false)
//            ]
//        )
//
//
//    }
//
//    convenience init(color: UIColor, position: SIMD3<Float>) {
//        self.init(color: color)
//        self.position = position
//    }
//
//    required init() {
//        fatalError("init() has not been implemented")
//    }
//}
//
//extension CustomEntity {
//    func addCollisions() {
//        guard let scene = self.scene else {
//            return
//        }
//
//        collisionSubs.append(scene.subscribe(to: CollisionEvents.Began.self, on: self) { event in
//            guard let boxA = event.entityA as? CustomEntity else {
//                return
//            }
//            print(event.entityA.name)
//            print(event.entityB.name)
//            boxA.model?.materials = [SimpleMaterial(color: .red, isMetallic: false)]
//
//            // Stop The Virus
//            if event.entityB.name == "GoodMask"{
//                let kinematics: PhysicsBodyComponent = .init(massProperties: .default,material: nil,mode: .kinematic)
//                let motion: PhysicsMotionComponent = .init(linearVelocity: [0 , 0, 0])
//                boxA.components.set(kinematics)
//                boxA.components.set(motion)
//            }
//
//        })
//        collisionSubs.append(scene.subscribe(to: CollisionEvents.Ended.self, on: self) { event in
//
//            guard let boxA = event.entityA as? CustomEntity else {
//                return
//            }
//            print(event.entityA.name)
//            print(event.entityB.name)
//            boxA.model?.materials = [SimpleMaterial(color: .yellow, isMetallic: false)]
//        })
//    }
//}
