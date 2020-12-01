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
        Experience.loadLesson1002Async(completion: { (result) in
            do {
                self.lesson1002Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1002Anchor)
                // ...
                self.setupNotifyActions1002()
                print("👌lesson1000Box加载完成")
            } catch {
                // handle error
                print("❌lesson1000Box加载失败")
            }
        })
    }
    // MARK: - RealityKit Interaction
    
    func setupNotifyActions1002(){
        lesson1002Anchor.actions.onShow.onAction = {entity in
            // 出现盒子
            // 场景出现
            self.lessonID = 1002
            self.currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == self.lessonID})!]
            self.showNotification(self.lessonID)
        }
        
        lesson1002Anchor.actions.onStart.onAction = {entity in
            self.notificationBar.isHidden = true
        }
        
        lesson1002Anchor.actions.showPoint1.onAction = { entity in
         
        }
        
        lesson1002Anchor.actions.clickMask.onAction = {entity in
            //普通口罩
            self.pointID = 2001
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1002Anchor.actions.clickSurgicalMask.onAction = {entity in
            //普通口罩
            self.pointID = 2002
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1002Anchor.actions.clickMaskN95.onAction = {entity in
            //N95
            self.pointID = 2004
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                //self.deleteStickyNote(self.lesson1002Anchor.findEntity(named: "label" + entity!.name)! as! StickyNoteEntity)
                self.deleteStickyNote(of: entity!)
            }
        }
        
        
    }
}

