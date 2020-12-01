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
        
        
    }
    
    func loadLesson1000Face(){
        Experience.loadLesson1000FaceAsync(completion: { (result) in
            do {
                self.lesson1000FaceAnchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1000FaceAnchor)
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
    
    func loadLesson1000Simulation(){
        Experience.loadLesosn1000SimulationAsync(completion: { (result) in
            do {
                self.lesson1000SimulationAnchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1000SimulationAnchor)
                // ...
                // 响应Reality Composer设置的actions
                self.setupNotifyActions1000Simulation()
                print("👌lesson1000Simulation加载完成")
            } catch {
                // handle error
                print("❌lesson1000Simulation加载失败")
            }
        })
    }
    // MARK: - RealityKit Interaction
    func setupNotifyActions1000(){
        lesson1000Anchor.actions.onShow.onAction = { entity in
            // 场景出现
            self.lessonID = 1000
            self.currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == self.lessonID})!]
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
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            self.insertNewSticky(self.lesson1000Anchor.pushLiquid!)
        }
        
        lesson1000Anchor.actions.press.onAction = {entity in
            //按下洗手液
            self.deleteStickyNote(of: entity!)
        }
        
        lesson1000Anchor.actions.showOpenMask.onAction = {entity in
            // 显示打开包装的引导
            self.insertNewSticky(entity!)
        }
        
        lesson1000Anchor.actions.openMask.onAction = {entity in
            // 关闭打开包装的引导
            // 这个关闭显示太傻逼了，应该写个全局的回调或者每次操作都检查一下Entity是否在场
            self.deleteStickyNote(of: entity!)
        }
        
        lesson1000Anchor.actions.showPoint2.onAction = {entity in
            //知识点2：检查口罩
            self.pointID = 2002
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            // 旋转检查的引导
            self.insertNewSticky(entity!)
        }
        
        lesson1000Anchor.actions.check.onAction = {entity in
            // 旋转检查
            self.deleteStickyNote(of: entity!)
        }
        
        lesson1000Anchor.actions.showPoint3.onAction = {entity in
            //知识点3 确认顶部
            self.pointID = 2003
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            // 金属条
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.showPoint4.onAction = {entity in
            //知识点4
            self.pointID = 2004
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            // 内部白色
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.goToPutOn.onAction = {entity in
            // 引导用户去佩戴口罩
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.showPoint5.onAction = {entity in
            //知识点5
            self.pointID = 2005
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            if ARFaceTrackingConfiguration.isSupported {
                // 切换摄像头
                self.buttonSwitchCamera(self)
                
                // 添加FaceAnchor
                self.loadLesson1000Face()
            }
            else {
                // 非前置摄像头流程
                print("设备不支持Face Tracking")
                self.lesson1000Anchor.notifications.showHead.post()
            }
            
        }
        
        // 以下为非前置摄像头版本
        
        lesson1000Anchor.actions.showHead.onAction = {entity in
            // 引导用户去佩戴口罩
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.showPoint6.onAction = {entity in
            //知识点6
            self.pointID = 2006
            self.updateUI(self.lessonID, self.pointID)
            
            // 显示点击金属条
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.showPoint7.onAction = { entity in
            //知识点7
            self.pointID = 2007
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1000Anchor.actions.clickMask.onAction = {entity in
            // 点击口罩
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                self.deleteStickyNote(of: entity!)
            }
        }
    }
    
    func setupNotifyActions1000Face(){
        lesson1000FaceAnchor.actions.onShow.onAction = {entity in
            // 场景出现
            //self.lessonID = 1000
            //self.currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == self.lessonID})!]
            //self.showNotification(self.lessonID)
            
        }
        lesson1000FaceAnchor.actions.showPoint6.onAction = {entity in
            //知识点6
            self.pointID = 2006
            self.updateUI(self.lessonID, self.pointID)
            
            // 显示点击金属条
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000FaceAnchor.actions.showPoint7.onAction = {entity in
            //知识点7 不能触摸
            self.pointID = 2007
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
        }
        
        lesson1000FaceAnchor.actions.startSimulation.onAction = {entity in
            
            self.arView.scene.anchors.removeAll()
            self.loadLesson1000Simulation()
            self.InfoView.isHidden = true
            // 准备Simulation模式的UI
            // 备注：无法通过actions启动entity的运动，原因未知，此处按钮改为结束本次课程
            self.controllNext.isHidden = false
            self.controllNext.setTitle("开始模拟", for: .normal)
            
            self.controllBack.isHidden = false
            //self.controllBack.currentImage =
            
            self.controllStackView.isHidden = false
            (self.controllStackView.viewWithTag(11) as! UILabel).text = "佩戴方式"
            (self.controllStackView.viewWithTag(21) as! UILabel).text = "地点"
            (self.controllStackView.viewWithTag(31) as! UILabel).text = "是否佩戴口罩"
        }
    }
    
    func setupNotifyActions1000Simulation(){
//        lesson1000SimulationAnchor.actions.prepareFly.onAction = {entity in
//            // lesson1000SimulationAnchor.notifications.reset.post()
//            let dynamic: PhysicsBodyComponent = .init(massProperties: .default,material: nil,mode: .dynamic)
//            let virus = self.lesson1000SimulationAnchor.virus as! Entity & HasPhysics & HasCollision
//            virus.components.set(dynamic)
//        }
    }
    
    /**
     开始模拟病毒入侵
     */
    func startSimulation(){
        
//        lesson1000SimulationAnchor.notifications.reset.post()
//
//        let dynamic: PhysicsBodyComponent = .init(massProperties: .default,material: nil,mode: .dynamic)
//        let virus = self.lesson1000SimulationAnchor.virus as! Entity & HasPhysics & HasCollision
//        virus.components.set(dynamic)
//
        self.lesson1000SimulationAnchor.notifications.goFly.post()
        
    }
}

