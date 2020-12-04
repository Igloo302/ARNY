import UIKit
import ARKit
import RealityKit

extension ARViewController {
    
    // MARK: - 1001 Main
    
    func startLesson1001() {
        lesson1001Anchor.notifications.onStart.post()
    }
    
    func loadLesson1001(){
        print("⌚️开始载入...")
        
        // 载入信息
        self.loadingView.isHidden = false
        
        Experience.loadLesson1001Async(completion: { (result) in
            do {
                self.lesson1001Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1001Anchor)
                // ...
                self.setupNotifyActions1001()
                print("👌lesson1001加载完成")
                
                
                self.loadingView.isHidden = true
                self.showGuide()
            } catch {
                // handle error
                print("❌lesson1001加载失败")
            }
        })
    }
    
    
    
    func setupNotifyActions1001(){
        
        lesson1001Anchor.actions.onShow.onAction = { entity in
            // 场景出现
            self.lessonID = 1001
            self.showNotification(self.lessonID)
            self.hideGuide()
            
        }
        
        lesson1001Anchor.actions.clickBubble.onAction = { entity in
            // 点击bubble，显示课程信息
            self.lesson1001Anchor.notifications.onStart.post()
            self.notificationBar.isHidden = true
            
        }
        
        lesson1001Anchor.actions.clickARMode.onAction = { entity in
            // 点击ARMode，初始化课程
            self.lesson1001Anchor.notifications.reset.post()
            
            // 无纺布，第一节课程
            self.pointID = 2001
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1001Anchor.actions.onBasicMode.onAction = { entity in
            // BasicMode
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "basicView") as! BasicViewController
            newVC.lessonID = self.lessonID
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
        /// Fiber
        lesson1001Anchor.actions.showFiber.onAction = { entity in
            // 点击或靠近，显示Fiber
            self.lesson1001Anchor.notifications.showFiber.post()
            
            // 点击ShowScale详情
            self.pointID = 2005
            self.updateUI(self.lessonID, self.pointID)
            
            // fiber label
            self.insertNewSticky(entity!,offset: [0.02, 0 ,0 ])
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        lesson1001Anchor.actions.showScale.onAction = { entity in
            //需要补充一个引导进入子场景和退出子场景的交互？
            
            
            // 载入Scale场景
            self.lesson1001Anchor.isEnabled = false
            self.loadLesson1001Scale()
            
            //UI更新
            self.controllStackView.isHidden = false
            (self.controllStackView.viewWithTag(1)!).isHidden = true
            (self.controllStackView.viewWithTag(2)!).isHidden = true
            
            (self.controllStackView.viewWithTag(31) as! UILabel).text = "真实比例"
            self.switchControl.isOn = false
            self.switchControl.addTarget(self, action: #selector(self.switchScale(_ :)), for: .valueChanged)
            
            self.controllBack.isHidden = true
            
            self.controllNext.isHidden = false
            self.controllNext.setTitle("Back to Main", for: .normal)
            self.controllNext.addTarget(self, action: #selector(self.backToMain1001Scale(_ :)), for: .touchUpInside)
            
            
        }
        
        ///纺粘布
        lesson1001Anchor.actions.showSpunbond.onAction = { entity in
            // 点击查看纺粘布详情
            self.pointID = 2003
            self.updateUI(self.lessonID, self.pointID)
            
            // show note label
            self.insertNewSticky(entity!,offset: [0.02, 0 ,0 ])
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        /// 多层结构
        lesson1001Anchor.actions.showMLS.onAction = { entity in
            // 点击查看纺粘布详情
            self.pointID = 2001
            self.updateUI(self.lessonID, self.pointID)
            
            // show note label
            self.insertNewSticky(entity!,offset: [0.02, 0 ,0 ])
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.deleteStickyNote(of: entity!)
            }
            
        }
        
        
        /// 熔喷布
        lesson1001Anchor.actions.clickMeltblown.onAction = { entity in
            // 点击查看纺粘布详情
            self.pointID = 2004
            self.updateUI(self.lessonID, self.pointID)
            
            // show note label
            self.insertNewSticky(entity!,offset: [0.02, 0 ,0 ])
            DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1001Anchor.actions.showMeltblown.onAction = { entity in
            // 点击查看熔喷布制造
            // 载入
            self.loadLesson1001Meltblown()
            self.lesson1001Anchor.isEnabled = false
            
            // UI
            self.controllBack.isHidden = true
            
            self.controllNext.isHidden = false
            self.controllNext.setTitle("Back to Main", for: .normal)
            self.controllNext.addTarget(self, action: #selector(self.backToMain1001Meltblown(_ :)), for: .touchUpInside)
            
        }
        
        lesson1001Anchor.actions.clickZG.onAction = { entity in
            // 点击查看纺粘布详情
            self.pointID = 2010
            self.updateUI(self.lessonID, self.pointID)
        }
    }
    
    // MARK: - Scale
    
    func loadLesson1001Scale(){
        print("⌚️开始载入...")
        Experience.loadLesson1001ScaleAsync(completion: { (result) in
            do {
                self.lesson1001ScaleAnchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1001ScaleAnchor)
                self.setupNotifyActions1001Scale()
                print("👌lesson1001Scale加载完成")
            
                print(self.lesson1001ScaleAnchor as Any)
                
                // 技术笔记！RC最坑的地方！
                // RC生成的文件的场景的结构是Scene-一个AnchorEntity-很多Entity（包括model、notificaiton、actions……）
                // 如果要实现对一个物体的手势操作，这个物体必须是HasCollision的，因此，如果要对整个场景进行旋转、缩放，需要把一堆entity都作为一个HasCollision的children，如果使用RC这样处理的话，就会丢失acitons、notificaitons等数据。
                // 如果要对RC内的模型进行交互的话，必须在RC里面手动开启参与物理，使得entity拥有了hasphysics和HasCollision
                // 通过generateCollisionShapes(recursive: true)不确定是否可以起到一样的效果
                // 参考文档:https://stackoverflow.com/questions/62825198/how-do-i-load-my-own-reality-composer-scene-into-realitykit
                // https://stackoverflow.com/questions/64182764/enabling-gestures-in-realitykit
                
                // 几个小技巧
                // 更换anchor
                // coneAndBoxAnchor.children[0].anchor!.anchoring = AnchoringComponent(.image(group: "AR Resources", name: "planets"))

                
                //                // Creating parent ModelEntity
                //                let parentEntity = ModelEntity()
                //                //parentEntity.addChild(self.lesson1001ScaleAnchor)
                //                for item in self.lesson1001ScaleAnchor.children[0].children{
                //                    parentEntity.children.append(item)
                //                }
                //
                //                //let entityBounds = self.lesson1001ScaleAnchor.visualBounds(relativeTo: parentEntity)
                //                //parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                //
                //                let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
                //                anchor.addChild(parentEntity)
                //
                //                self.arView.scene.addAnchor(anchor)
                //
                //
                //                self.arView.installGestures(for: parentEntity)
                //
                //
                //                let entityBounds = self.lesson1001ScaleAnchor.visualBounds(relativeTo: parentEntity)
                //                self.lesson1001ScaleAnchor.children[0].components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)]))
                //                self.arView.installGestures(for: self.lesson1001ScaleAnchor.children[0] as! HasCollision)
                
                // 给一个模型的
                if let ball = self.lesson1001ScaleAnchor.crtf as? Entity & HasCollision & HasPhysics {
                    self.arView.installGestures([.translation, .rotation], for: ball)
                    //                    if let gestureRecognizer = gestureRecognizers.first as? EntityTranslationGestureRecognizer {
                    //
                    //                        self.gestureRecognizer = gestureRecognizer
                    //
                    //                        // Disable default translation.
                    //                        gestureRecognizer.removeTarget(nil, action: nil)
                    //
                    //                        // Add an alternative gesture handler that applies a linear velocity to the ball.
                    //                        gestureRecognizer.addTarget(self, action: #selector(self.handleTranslation))
                    
                    //                    let forceMultiplier = simd_float3(repeating: 10)
                    //                    ball.addForce(simd_float3(x: 1,
                    //                                              y: 0,
                    //                                              z: 0) * forceMultiplier,
                    //                                  relativeTo: nil)
                    //
                    //                    let myEntity = ball.clone(recursive: true)
                    //
                    //
                    //                    myEntity.transform.translation += SIMD3<Float>(1, 0, 0)
                    //                    myEntity.transform.scale /= 2
                    //                    let radians = 90.0 * Float.pi / 180.0
                    //
                    //                    myEntity.transform.rotation += simd_quatf(angle: radians,
                    //                                                              axis: SIMD3<Float>(0,0,1))
                    //
                    //
                    //                    parentEntity.addChild(myEntity)
                    //
                    
                }
                
                
                
                //                self.lesson1001ScaleAnchor.generateCollisionShapes(recursive: true)
                //                self.arView.installGestures(.all, for: self.lesson1001ScaleAnchor as! HasCollision).forEach{
                //                    $0.addTarget(self, action: #selector(self.handleModelGesture))}
                //
                //                let entityBounds = self.lesson1001ScaleAnchor.visualBounds(relativeTo: self.lesson1001ScaleAnchor.parent)
                //
                //                self.lesson1001ScaleAnchor.parent.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
                //
                
                
                
            } catch {
                // handle error
                print("❌lesson1001Scale加载失败")
            }
        })
    }
    
    func setupNotifyActions1001Scale(){
        
    }
    
    
    @objc func switchScale(_ sender: UISwitch) {
        if sender.isOn {
            self.lesson1001ScaleAnchor.notifications.small.post()
        } else{
            self.lesson1001ScaleAnchor.notifications.big.post()
        }
    }
    
    
    @objc func backToMain1001Scale(_ sender: UIButton) {
        self.lesson1001ScaleAnchor.removeFromParent()
        //self.arView.scene.anchors.append(self.lesson1001Anchor)
        self.lesson1001Anchor.isEnabled = true
        self.controllStackView.isHidden = true
        self.pointID = 2001
        self.updateUI(lessonID, pointID)
        
        self.controllNext.removeTarget(self, action: #selector(self.backToMain1001Scale(_ :)), for: .touchUpInside)
        self.restoreNextNBack()
    }
    
    @objc func backToMain1001Meltblown(_ sender: UIButton) {
        self.lesson1001MeltblownAnchor.removeFromParent()
        //self.arView.scene.anchors.append(self.lesson1001Anchor)
        self.lesson1001Anchor.isEnabled = true
        self.pointID = 2001
        self.updateUI(lessonID, pointID)
        
        self.controllNext.removeTarget(self, action: #selector(self.backToMain1001Meltblown(_ :)), for: .touchUpInside)
        self.restoreNextNBack()
    }
    
    // MARK: - Meltblown
    
    func loadLesson1001Meltblown(){
        print("⌚️开始载入...")
        Experience.loadLesson1001MeltblownAsync(completion: { (result) in
            do {
                self.lesson1001MeltblownAnchor = try result.get()
                //                self.lesson1001MeltblownAnchor.transform.scale = [0.05, 0.05, 0.05]
                //self.lesson1001MeltblownAnchor.setScale(SIMD3(repeating: 0.01), relativeTo: nil)
                
                //self.lesson1001MeltblownAnchor.children[0].anchor?.setScale(SIMD3(repeating: 0.3), relativeTo: nil)
                
                self.arView.scene.anchors.append(self.lesson1001MeltblownAnchor)
                self.setupNotifyActions1001Meltblown()
                print("👌lesson1001Meltblown加载完成")
                
            } catch {
                // handle error
                print("❌lesson1001Meltblown加载失败")
            }
        })
    }
    
    func setupNotifyActions1001Meltblown(){
        lesson1001MeltblownAnchor.actions.onShow.onAction = { entity in
            self.pointID = 2004
            self.updateUI(self.lessonID, self.pointID)
            
            
        }
        
        lesson1001MeltblownAnchor.actions.process1.onAction = { entity in
            self.pointID = 2006
            self.updateUI(self.lessonID, self.pointID)
            
            //            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            //                self.lesson1001MeltblownAnchor.transform.scale = [0.3,0.3,0.3]
            //            }
        }
        lesson1001MeltblownAnchor.actions.process2.onAction = { entity in
            self.pointID = 2007
            self.updateUI(self.lessonID, self.pointID)
        }
        lesson1001MeltblownAnchor.actions.process3.onAction = { entity in
            self.pointID = 2008
            self.updateUI(self.lessonID, self.pointID)
        }
        lesson1001MeltblownAnchor.actions.process4.onAction = { entity in
            self.pointID = 2009
            self.updateUI(self.lessonID, self.pointID)
        }
    }
    
}
