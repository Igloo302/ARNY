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
        lesson1000BoxAnchor.notifications.onStartByNoti.post()
    }
    
    func loadLesson1002(){
        print("⌚️开始载入...")
        Experience.loadLesson1000BoxAsync(completion: { (result) in
            do {
                self.lesson1000BoxAnchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1000BoxAnchor)
                // ...
                self.setupNotifyActions1000Box()
                print("👌lesson1000Box加载完成")
            } catch {
                // handle error
                print("❌lesson1000Box加载失败")
            }
        })
    }
    // MARK: - RealityKit Interaction
    
    func setupNotifyActions1000Box(){
        lesson1000BoxAnchor.actions.onShow.onAction = {entity in
            // 出现盒子
            self.showNotification(self.lessonID)
        }
        
        lesson1000BoxAnchor.actions.onStart.onAction = {entity in
            
            
        }
        
        lesson1000BoxAnchor.actions.showPoint1.onAction = { entity in
            //知识点1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            self.insertNewSticky(self.lesson1000BoxAnchor.mask2!)
            self.insertNewSticky(self.lesson1000BoxAnchor.maskn95!)
            self.insertNewSticky(self.lesson1000BoxAnchor.masknormal!)
            
            //self.deleteStickyNote(self.lesson1000BoxAnchor.findEntity(named: "label" + entity!.name)! as! StickyNoteEntity)
            
            //self.deleteStickyNote(of: entity!)
            
            // 开始识别盒子上的图像，开始流程
            // 判断是否锚到图像，决定下一流程的展示？ 等会再做
        }
    }
}

