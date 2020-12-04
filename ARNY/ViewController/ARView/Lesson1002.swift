//
//  Lesson1000.swift
//  ARNY
//
//  Created by Igloo on 2020/11/28.
//

import UIKit
import ARKit
import RealityKit

extension ARViewController {
    
    func startLesson1002() {
        lesson1002Anchor.notifications.onStartByNoti.post()
    }
    
    func loadLesson1002(){
        print("⌚️开始载入...")
        
        self.loadingView.isHidden = false
        Experience2.loadLesson1002Async(completion: { (result) in
            do {
                self.lesson1002Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1002Anchor)
                // ...
                self.setupNotifyActions1002()
                print("👌lesson1000Box加载完成")
                
                self.loadingView.isHidden = true
                
                self.showGuide()
            } catch {
                // handle error
            }
        })
        
        Experience2.loadLesson1002s1Async(completion: { (result) in
            do {
                self.lesson1002s1Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1002s1Anchor)
                self.lesson1002s1Anchor.isEnabled = false
                // ...
                self.setupNotifyActions1002s1()
            } catch {
                // handle error
            }
        })
        
        Experience2.loadLesson1002s2Async(completion: { (result) in
            do {
                self.lesson1002s2Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1002s2Anchor)
                self.lesson1002s2Anchor.isEnabled = false
                // ...
                self.setupNotifyActions1002s2()
                
            } catch {
                // handle error
            }
        })
        
        Experience2.loadLesson1002s3Async(completion: { (result) in
            do {
                self.lesson1002s3Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1002s3Anchor)
                self.lesson1002s3Anchor.isEnabled = false
                // ...
                self.setupNotifyActions1002s3()
            } catch {
                // handle error
            }
        })
        
        Experience2.loadLesson1002s4Async(completion: { (result) in
            do {
                self.lesson1002s4Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1002s4Anchor)
                self.lesson1002s4Anchor.isEnabled = false
                // ...
                self.setupNotifyActions1002s4()
            } catch {
                // handle error
            }
        })
        
    }
    // MARK: - RealityKit Interaction
    
    func setupNotifyActions1002(){
        lesson1002Anchor.actions.onShow.onAction = {entity in
            // 出现盒子
            // 场景出现
            self.lessonID = 1002
            self.showNotification(self.lessonID)
            
            self.hideGuide()
        }
        
        lesson1002Anchor.actions.onStart.onAction = {entity in
            self.notificationBar.isHidden = true
        }
        
        lesson1002Anchor.actions.showPoint1.onAction = { entity in
            
        }
        
        lesson1002Anchor.actions.clickMask.onAction = {entity in
            //普通口罩
            self.pointID = 2001
            self.updateUI(self.lessonID, self.pointID)
            
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1002Anchor.actions.clickSurgicalMask.onAction = {entity in
            //医用外科口罩
            self.pointID = 2002
            self.updateUI(self.lessonID, self.pointID)
            
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1002Anchor.actions.clickMaskN95.onAction = {entity in
            //N95
            self.pointID = 2003
            self.updateUI(self.lessonID, self.pointID)
            
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1002Anchor.actions.startScenarios.onAction = {entity in
            
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            
            self.lesson1002Anchor.isEnabled = false
            self.lesson1002s1Anchor.isEnabled = true
        }
    }
    
    func setupNotifyActions1002s1(){
        lesson1002s1Anchor.actions.onShow1.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
        }
        
        lesson1002s1Anchor.actions.yes1.onAction = {entity in
            self.pointID = 2005
            self.updateUI(self.lessonID, self.pointID)
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            
            print("s1 yes")
        }
        
        lesson1002s1Anchor.actions.back1.onAction = {entity in
            
            self.controllBack.isHidden = false
            self.pointID = 2001
            self.updateUI(self.lessonID, self.pointID)
            
            self.lesson1002s1Anchor.isEnabled = false
            self.lesson1002Anchor.isEnabled = true
            //self.lesson1002Anchor.notifications.showAll.post()
        }
        
        lesson1002s1Anchor.actions.next1.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            
            self.lesson1002s1Anchor.isEnabled = false
            self.lesson1002s2Anchor.isEnabled = true
        }
    }
    
    
    func setupNotifyActions1002s2(){
        lesson1002s2Anchor.actions.onShow2.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
        }
        
        lesson1002s2Anchor.actions.yes2.onAction = {entity in
            self.pointID = 2006
            self.updateUI(self.lessonID, self.pointID)
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            print("s2 yes")
        }
        
        lesson1002s2Anchor.actions.back2.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            
            self.lesson1002s2Anchor.isEnabled = false
            self.lesson1002s1Anchor.isEnabled = true
        }
        
        lesson1002s2Anchor.actions.next2.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            
            self.lesson1002s2Anchor.isEnabled = false
            self.lesson1002s3Anchor.isEnabled = true
        }
    }
    
    func setupNotifyActions1002s3(){
        lesson1002s3Anchor.actions.onShow3.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
        }
        
        lesson1002s3Anchor.actions.yes3.onAction = {entity in
            self.pointID = 2007
            self.updateUI(self.lessonID, self.pointID)
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            print("s3 yes")
        }
        
        lesson1002s3Anchor.actions.back3.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            
            self.lesson1002s3Anchor.isEnabled = false
            self.lesson1002s2Anchor.isEnabled = true
        }
        
        lesson1002s3Anchor.actions.next3.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            
            self.lesson1002s4Anchor.isEnabled = true
            self.lesson1002s3Anchor.isEnabled = false
        }
    }
    
    func setupNotifyActions1002s4(){
        lesson1002s4Anchor.actions.onShow4.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
        }
        
        lesson1002s4Anchor.actions.yes4.onAction = {entity in
            
            self.controllBack.isHidden = false
            self.pointID = 2008
            self.updateUI(self.lessonID, self.pointID)
            print("s4 yes")
        }
        
        lesson1002s4Anchor.actions.close.onAction = {entity in
            
            self.controllBack.isHidden = false
            self.pointID = 2001
            self.updateUI(self.lessonID, self.pointID)
            
            self.lesson1002s4Anchor.isEnabled = false
            self.lesson1002Anchor.isEnabled = true
            
            //self.lesson1002Anchor.notifications.showAll.post()
        }
        
        lesson1002s4Anchor.actions.back4.onAction = {entity in
            self.InfoView.isHidden = true
            self.controllNext.isHidden = true
            self.controllBack.isHidden = true
            
            self.lesson1002s4Anchor.isEnabled = false
            self.lesson1002s3Anchor.isEnabled = true
        }
    }
    //
    //    func garden(){
    //
    //        let scene = try! Experience2.loadScene()
    //
    //        let girl1 = scene.girl1!  as! Entity & HasCollision
    //        girl1.name = "girl1"
    //        let garden = scene.garden!
    //        garden.name = "garden"
    //
    //        let parentEntity = ModelEntity()
    //        parentEntity.addChild(girl1)
    //        parentEntity.addChild(garden)
    //
    //        parentEntity.name = "parenEntity"
    //
    //        let entityBounds = garden.visualBounds(relativeTo: nil)
    //        parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: SIMD3(x: entityBounds.extents.x, y: entityBounds.extents.y/10, z: entityBounds.extents.z)).offsetBy(translation: entityBounds.center-[0,entityBounds.extents.y/2,0])])
    //        //parentEntity.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: entityBounds.extents).offsetBy(translation: entityBounds.center)])
    //
    //
    //
    //        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
    //        anchor.addChild(parentEntity)
    //
    //        self.arView.scene.addAnchor(anchor)
    //
    //        self.arView.installGestures(for: parentEntity)
    //
    //
    //        let girl1Bounds = girl1.visualBounds(relativeTo: parentEntity)
    //        girl1.collision = CollisionComponent(shapes: [ShapeResource.generateBox(size: girl1Bounds.extents).offsetBy(translation: girl1Bounds.center)])
    //
    //
    //
    //
    //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showRightMask1002))
    //        self.arView.addGestureRecognizer(tapGesture)
    //
    //
    //
    //
    //        //let scene = try! Experience2.loadScene()
    //
    //        let noneed = scene.noneed!  as! Entity & HasCollision
    //        let clothMask = scene.clothmask!  as! Entity & HasCollision
    //        let Mask1 = scene.mask1!  as! Entity & HasCollision
    //        let sMask = scene.surgicalMask!  as! Entity & HasCollision
    //        let n95 = scene.n95Respirator!  as! Entity & HasCollision
    //
    //        let maskChoose = ModelEntity()
    //        maskChoose.addChild(noneed)
    //        maskChoose.addChild(clothMask)
    //        maskChoose.addChild(Mask1)
    //        maskChoose.addChild(sMask)
    //        maskChoose.addChild(n95)
    //
    //        maskChoose.name = "maskChoose"
    //
    //        //let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: .zero))
    //        parentEntity.addChild(maskChoose)
    //    }
    //
    //    /// - Tag: TapHandler
    //    @objc
    //    func showRightMask1002(_ sender: UITapGestureRecognizer) {
    //
    //        // 点击的时候展示NoteLabel，3秒后自动关闭
    //        let tapLocation = sender.location(in: arView)
    //
    //        guard let entityTapped = arView.entity(at: tapLocation) else {
    //            return
    //        }
    //
    //        print(entityTapped.name)
    //
    //    }
}

