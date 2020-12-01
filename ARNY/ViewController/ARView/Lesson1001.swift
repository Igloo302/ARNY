import UIKit
import ARKit
import RealityKit

extension ARViewController {
    
    func startLesson1001() {
        lesson1001Anchor.notifications.onStartByNoti.post()
    }
    
    func loadLesson1001(){
        print("⌚️开始载入...")
        Experience.loadLesson1001Async(completion: { (result) in
            do {
                self.lesson1001Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1001Anchor)
                // ...
                self.setupNotifyActions1001()
                print("👌lesson1001加载完成")
                
                // Label Test
                self.insertNewSticky(self.lesson1001Anchor.x!)
                self.insertNewSticky(self.lesson1001Anchor.y!)
                self.insertNewSticky(self.lesson1001Anchor.z!)
                
            } catch {
                // handle error
                print("❌lesson1001加载失败")
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
    
    func setupNotifyActions1001(){
        
        lesson1001Anchor.actions.onShow.onAction = { entity in
            // 场景出现
            self.lessonID = 1001
            self.currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == self.lessonID})!]
            self.showNotification(self.lessonID)
        }
        
        lesson1001Anchor.actions.onStart.onAction = {entity in
            self.notificationBar.isHidden = true
            
            // 切换前置摄像头测试——测试成功
            self.arView.scene.anchors.removeAll()
            
            let config = self.arView.session.configuration
            self.arView.session.run(config!, options: [.resetTracking, .removeExistingAnchors])
            
            let faceconfig = ARFaceTrackingConfiguration()
            self.arView.session.run(faceconfig, options: [.resetTracking, .removeExistingAnchors])
            
            self.arView.scene.addAnchor(self.lesson1000FaceAnchor)
            
        }
        
        
    }
    
}
