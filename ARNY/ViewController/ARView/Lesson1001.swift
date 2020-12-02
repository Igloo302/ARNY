import UIKit
import ARKit
import RealityKit

extension ARViewController {
    
    func startLesson1001() {
        lesson1001Anchor.notifications.onStart.post()
    }
    
    func loadLesson1001(){
        print("⌚️开始载入...")
        self.loadingView.isHidden = false
        Experience.loadLesson1001Async(completion: { (result) in
            do {
                self.lesson1001Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1001Anchor)
                // ...
                self.setupNotifyActions1001()
                print("👌lesson1001加载完成")
                
                
                self.loadingView.isHidden = true
                
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
            
            // Show Label
            self.insertNewSticky(self.lesson1001Anchor.layer1!,offset: [0.1,0,0])
            self.insertNewSticky(self.lesson1001Anchor.layer2!,offset: [0.1,0,0])
            self.insertNewSticky(self.lesson1001Anchor.layer3!,offset: [0.1,0,0])
            DispatchQueue.main.asyncAfter(deadline: .now() + 10){
                self.deleteStickyNote(of: self.lesson1001Anchor.layer1!)
                self.deleteStickyNote(of: self.lesson1001Anchor.layer2!)
                self.deleteStickyNote(of: self.lesson1001Anchor.layer3!)
            }
        }
        
        lesson1001Anchor.actions.onStart.onAction = {entity in
            self.notificationBar.isHidden = true
            
            
            
        }
        
        /// Fiber
        lesson1001Anchor.actions.showFiber.onAction = { entity in
            // 点击或靠近，显示Fiber
            self.lesson1001Anchor.notifications.showFiber.post()
        }
        lesson1001Anchor.actions.showScale.onAction = { entity in
            // 点击ShowScale详情
            self.pointID = 2005
            self.updateUI(self.lessonID, self.pointID)
            
            //需要补充一个引导进入子场景和退出子场景的交互？
            
            
            // 载入Scale场景
            self.loadLesson1001Scale()
            
            //UI更新
            self.controllStackView.isHidden = false
            (self.controllStackView.viewWithTag(1)!).isHidden = true
            (self.controllStackView.viewWithTag(2)!).isHidden = true
            
            (self.controllStackView.viewWithTag(31) as! UILabel).text = "真实比例"
            self.switchControl.addTarget(self, action: #selector(self.switchScale(_ :)), for: .valueChanged)
            
            
        }
        
        ///纺粘布
        lesson1001Anchor.actions.showSpunbond.onAction = { entity in
            // 点击查看纺粘布详情
            self.pointID = 2003
            self.updateUI(self.lessonID, self.pointID)
        }
        
        /// 多层结构
        lesson1001Anchor.actions.showMLS.onAction = { entity in
            // 点击查看纺粘布详情
            self.pointID = 2004
            self.updateUI(self.lessonID, self.pointID)
        }
        
        
        /// 熔喷布
        lesson1001Anchor.actions.clickMeltblown.onAction = { entity in
            // 点击查看纺粘布详情
            self.pointID = 2003
            self.updateUI(self.lessonID, self.pointID)
        }
    }
    
    
    
    func loadLesson1001Scale(){
        print("⌚️开始载入...")
        Experience.loadLesson1001ScaleAsync(completion: { (result) in
            do {
                self.lesson1001ScaleAnchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1001ScaleAnchor)
                //self.setupNotifyActions1001Scale()
                print("👌lesson1001Scale加载完成")
            } catch {
                // handle error
                print("❌lesson1001Scale加载失败")
            }
        })
    }
    
    @objc func switchScale(_ sender: UISwitch) {
        if sender.isOn {
            self.lesson1001ScaleAnchor.notifications.small.post()
        } else{
            self.lesson1001ScaleAnchor.notifications.big.post()
        }
    }
    
}
