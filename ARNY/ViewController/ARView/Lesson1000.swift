//
//  Lesson1000.swift
//  ARNY
//
//  Created by Igloo on 2020/11/28.
//

/// lessonpath:
/// 1.1000; 2.1000Face; 3.1000Mask; 4. 1000Simulation

import UIKit
import ARKit
import RealityKit

extension ARViewController {
    
    func perform1000(at lessonPoint: Int){
        switch self.lessonPath {
        case 3:
            do{
                switch lessonPoint {
                default:
                    return
                }
            }
        default:
            return
        }
    }
    
    func startLesson1000() {
        lesson1000Anchor.notifications.onStartByNoti.post()
    }
    
    func loadLesson1000(){
        print("⌚️开始载入...")
        self.loadingView.isHidden = false
        
        Experience.loadLesson1000Async(completion: { (result) in
            do {
                self.lesson1000Anchor = try result.get()
                
                self.arView.scene.anchors.removeAll()
                self.arView.scene.anchors.append(self.lesson1000Anchor)
                // ...
                // 响应Reality Composer设置的actions
                self.setupNotifyActions1000()
                //                self.lesson1000Anchor.generateCollisionShapes(recursive: true)
                //                self.lesson1000Anchor.bubble1000?.generateCollisionShapes(recursive: true)
                
                self.lessonPath = 1
                print("👌lesson1000加载完成")
                self.loadingView.isHidden = true
            } catch {
                // handle error
                print("❌lesson1000加载失败")
            }
        })
        
        
    }
    
    func loadLesson1000Face(){
        self.loadingView.isHidden = false
        
        Experience.loadLesson1000FaceAsync(completion: { (result) in
            do {
                self.lesson1000FaceAnchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1000FaceAnchor)
                // ...
                // 响应Reality Composer设置的actions
                self.setupNotifyActions1000Face()
                self.lessonPath = 2
                print("👌lesson1000Face加载完成")
                
                self.loadingView.isHidden = true
            } catch {
                // handle error
                print("❌lesson1000Face加载失败")
            }
        })
    }
    
    func loadLesson1000Simulation(){
        
        self.loadingView.isHidden = false
        Experience.loadLesosn1000SimulationAsync(completion: { (result) in
            do {
                self.lesson1000SimulationAnchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1000SimulationAnchor)
                // ...
                // 响应Reality Composer设置的actions
                self.setupNotifyActions1000Simulation()
                self.lessonPath = 4
                print("👌lesson1000Simulation加载完成")
                self.loadingView.isHidden = true
            } catch {
                // handle error
                print("❌lesson1000Simulation加载失败")
            }
        })
    }
    
    func loadLesson1000Mask(){
        Experience.loadLesson1000WithRealMaskAsync(completion: { (result) in
            do {
                self.lesson10000MaskAnchor = try result.get()
                self.arView.scene.anchors.append(self.lesson10000MaskAnchor)
                // ...
                // 响应Reality Composer设置的actions
                self.setupNotifyActions1000Mask()
                self.lessonPath = 3
                print("👌lesson10000MaskAnchor加载完成")
            } catch {
                // handle error
                print("❌lesson10000MaskAnchor加载失败")
            }
        })
    }
    
    
    // MARK: - RealityKit Interaction
    func setupNotifyActions1000(){
        /// 场景出现浮标
        lesson1000Anchor.actions.onShow.onAction = { entity in
            self.lessonID = 1000
            self.showNotification(self.lessonID)
        }
        
        /// 跳转常规模式，传递lessonID
        lesson1000Anchor.actions.onStartBasic.onAction = { entity in
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newVC = storyboard.instantiateViewController(withIdentifier: "basicView") as! BasicViewController
            newVC.lessonID = self.lessonID
            self.navigationController?.pushViewController(newVC, animated: true)
        }
        
        /// click ar mode
        lesson1000Anchor.actions.startAR.onAction = {entity in
            self.notificationBar.isHidden = true
            // update currentlesson
            self.currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == self.lessonID})!]
            // update UI
            self.pointID = 2001
            self.updateUI(self.lessonID, self.pointID)
            
            //
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.showOpen.onAction = {entity in
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.showPoint2Switch.onAction = {entity in
            // update UI
            self.pointID = 2002
            self.updateUI(self.lessonID, self.pointID)
            
            /// 🐂 分支路径->lesson1000Mask lessonpath=3
            //ui
            self.popView.isHidden = false
            self.popLabel.text = "Do you have a real mask like this on hand?"
            self.popLeftButton.setTitle("No Mask", for: .normal)
            self.popRightButton.setTitle("Yes", for: .normal)
            self.popRightButton.addTarget(self, action: #selector(self.popRightButtonHaveMask(_ :)), for: .touchUpInside)
            self.popLeftButton.addTarget(self, action:#selector(self.popLeftButtonHaveMask(_ :)), for: .touchUpInside)
        }
        
        
        lesson1000Anchor.actions.showPoint2.onAction = {entity in
            // Check Mask
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }

        }
        
        
        lesson1000Anchor.actions.showPoint3.onAction = {entity in
            // update UI
            self.pointID = 2003
            self.updateUI(self.lessonID, self.pointID)
            
            // Mental
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.showPoint4.onAction = {entity in
            //知识点4
            self.pointID = 2004
            self.updateUI(self.lessonID, self.pointID)
            
            // 内部白色
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
                self.lessonPath = 2
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000Anchor.actions.showPoint7.onAction = { entity in
            //知识点7
            self.pointID = 2007
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            //end
            self.controllNext.isHidden = false
            self.controllNext.setTitle("End Lesson", for: .normal)
        }
        
        lesson1000Anchor.actions.clickMask.onAction = {entity in
            // 点击口罩
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1){
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
            
            //知识点5
            self.pointID = 2005
            self.updateUI(self.lessonID, self.pointID)
            
        }
        lesson1000FaceAnchor.actions.showPoint6.onAction = {entity in
            //知识点6
            self.pointID = 2006
            self.updateUI(self.lessonID, self.pointID)
            
            // 显示点击金属条
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson1000FaceAnchor.actions.showPoint7.onAction = {entity in
            //知识点7 不能触摸
            self.pointID = 2007
            //self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            //end
            self.controllNext.isHidden = false
            self.controllNext.setTitle("End Lesson", for: .normal)
            
        }
        
        lesson1000FaceAnchor.actions.startSimulation.onAction = {entity in
            
            self.arView.scene.anchors.removeAll()
            self.loadLesson1000Simulation()
            
            // 准备Simulation模式的UI
            // 备注：无法通过actions启动entity的运动，原因未知，此处按钮改为结束本次课程
            
            self.InfoView.isHidden = true
            
            
            self.controllNext.isHidden = false
            self.controllNext.setTitle("End Lesson", for: .normal)
            
            self.controllStackView.isHidden = false
            
            // 地点，比较麻烦，不写了
            (self.controllStackView.viewWithTag(21) as! UILabel).text = "Place and Occasion"
            
            
            // 佩戴方式
            (self.controllStackView.viewWithTag(11) as! UILabel).text = "Wearing Method"
            self.segmentedControl.addTarget(self, action: #selector(self.segmentedControlChangeForVirusSimulation(_ :)), for: .valueChanged)
            self.segmentedControl.setTitle("Right", forSegmentAt: 0)
            self.segmentedControl.setTitle("Bad Nose", forSegmentAt: 1)
            self.segmentedControl.setTitle("Bad Mouth", forSegmentAt: 2)
            
            
            (self.controllStackView.viewWithTag(31) as! UILabel).text = "Whether to Wear a Mask"
            self.switchControl.addTarget(self, action: #selector(self.switchWearMask(_ :)), for: .valueChanged)
            
        }
    }
    
    func setupNotifyActions1000Simulation(){

        
        lesson1000SimulationAnchor.actions.flying.onAction = {entity in
            
            guard self.switchControl.isOn else {
                self.lesson1000SimulationAnchor.notifications.hi.post()
                return
            }
            switch self.segmentedControl.selectedSegmentIndex {
            case 0:
                self.lesson1000SimulationAnchor.notifications.low.post()
            case 1:
                self.lesson1000SimulationAnchor.notifications.md.post()
            default:
                self.lesson1000SimulationAnchor.notifications.hi.post()
            }
            
        }
        
        lesson1000SimulationAnchor.actions.goFly.onAction = {entity in
            self.segmentedControl.isEnabled = false
            self.switchControl.isEnabled = false
        }
        
        lesson1000SimulationAnchor.actions.flyEnd.onAction = {entity in
            self.segmentedControl.isEnabled = true
            self.switchControl.isEnabled = true
        }
    }
    
    func setupNotifyActions1000Mask(){
        
        lesson10000MaskAnchor.actions.onShow.onAction = {entity in
            // 加载自己的口罩成功
            self.pointID = 2003
            self.updateUI(self.lessonID, self.pointID)
            
            // 显示点击金属条
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson10000MaskAnchor.actions.showPoint4.onAction = {entity in
            //请求点击箭头
            self.pointID = 2004
            self.updateUI(self.lessonID, self.pointID)
            
            self.insertNewSticky(entity!)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3){
                self.deleteStickyNote(of: entity!)
            }
        }
        
        lesson10000MaskAnchor.actions.clickput.onAction = {entity in
            // 加载戴口罩的
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
                
                self.popView.isHidden = false
                self.popLabel.text = "Your Device doesn't support the lesson."
                self.popLeftButton.setTitle("Close", for: .normal)
                self.popRightButton.setTitle("End Lesson", for: .normal)
                self.popRightButton.addTarget(self, action: #selector(self.popRightButtonRateNExit(_ :)), for: .touchUpInside)
                self.popLeftButton.addTarget(self, action:#selector(self.popLeftButtonClose(_ :)), for: .touchUpInside)
                
                self.controllNext.isHidden = false
                self.controllNext.setTitle("End Lesson", for: .normal)
            }
        }
    }
    
    @objc func segmentedControlChangeForVirusSimulation(_ segmented: UISegmentedControl) {
        if segmented.selectedSegmentIndex == 0 {
            self.lesson1000SimulationAnchor.notifications.mask1.post()
        }
        else if segmented.selectedSegmentIndex == 1 {
            self.lesson1000SimulationAnchor.notifications.mask2.post()
        }
        else {
            self.lesson1000SimulationAnchor.notifications.mask3.post()
        }
    }
    
    @objc func switchWearMask(_ sender: UISwitch) {
        if sender.isOn {
            //segmentedControlChangeForVirusSimulation(self.segmentedControl)
            self.segmentedControl.isEnabled = true
        } else{
            self.lesson1000SimulationAnchor.notifications.noMask.post()
            self.segmentedControl.isEnabled = false
        }
    }
    
    @objc func popRightButtonHaveMask(_ sender: UIButton){
        self.popView.isHidden = true
        // 加载lesson1000Mask
        self.lessonPath = 3
        self.arView.scene.anchors.removeAll()
        self.loadLesson1000Mask()
    }
    
    @objc func popLeftButtonHaveMask(_ sender: UIButton){
        //close the pop view and do nothing
        self.popView.isHidden = true
        self.lesson1000Anchor.notifications.showPoint2.post()
    }
}

