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
    
    func startLesson1000() {
        lesson1000Anchor.notifications.onStartByNoti.post()
    }
    
    func loadLesson1000(){
        print("⌚️开始载入...")
        
        Experience.loadLesson1000Async(completion: { (result) in
            do {
                self.lesson1000Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1000Anchor)
                // ...
                // 响应Reality Composer设置的actions
                self.setupNotifyActions1000()
                self.lesson1000Anchor.generateCollisionShapes(recursive: true)
                self.lesson1000Anchor.bubble1000?.generateCollisionShapes(recursive: true)
                print("👌lesson1000加载完成")
            } catch {
                // handle error
                print("❌lesson1000加载失败")
            }
        })
        
        Experience.loadLesson1000FaceAsync(completion: { (result) in
            do {
                self.lesson1000FaceAnchor = try result.get()
                // self.arView.scene.anchors.append(self.lesson1000FaceAnchor)
                // ...
                // 响应Reality Composer设置的actions
                self.setupNotifyActions1000Face()
                print("👌lesson1000Face加载完成")
            } catch {
                // handle error
                print("❌lesson1000Face加载失败")
            }
        })
    }
    // MARK: - RealityKit Interaction
    func setupNotifyActions1000(){
        lesson1000Anchor.actions.onShow.onAction = { entity in
            // 场景出现
            self.showNotification(self.lessonID)
        }
        
        lesson1000Anchor.actions.onStartBasic.onAction = { entity in
            // 跳转常规模式，传递lessonID
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "basicView") as! BasicViewController
            newVC.lessonID = self.lessonID
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
        lesson1000Anchor.actions.onStart.onAction = {entity in
            // 启动显示课程信息
            self.notificationBar.isHidden = true
        }
        
        lesson1000Anchor.actions.showPoint1.onAction = {entity in
            //知识点1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            self.insertNewSticky(self.lesson1000Anchor.pushLiquid!)
        }
        
        lesson1000Anchor.actions.showPoint2.onAction = {entity in
            //知识点2
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            
        }
        
        lesson1000Anchor.actions.showPoint3.onAction = {entity in
            //知识点3
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1000Anchor.actions.showPoint4.onAction = {entity in
            //知识点4
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1000Anchor.actions.showPoint5.onAction = {entity in
            //知识点5
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            // 切换摄像头
            self.buttonSwitchCamera(self)
            
            // 添加FaceAnchor
            self.arView.scene.anchors.append(self.lesson1000FaceAnchor)
        }
    }
    
    func setupNotifyActions1000Face(){
        lesson1000FaceAnchor.actions.showPoint6.onAction = {entity in
            //知识点6
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1000FaceAnchor.actions.showPoint7.onAction = {entity in
            //知识点7
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
    }
    
}

