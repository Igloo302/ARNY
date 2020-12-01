import UIKit
import ARKit
import RealityKit

extension ARViewController {
    
    func startLesson1003() {
        // lesson1003Anchor.notifications.onStartByNoti.post()
    }
    
    func loadLesson1003(){
        print("⌚️开始载入...")
        
        // Create a session configuration
        let configuration = ARFaceTrackingConfiguration()
        // Yasss estimate light for me
        configuration.isLightEstimationEnabled = true
        // Enable back camera to do world tracking
        // configuration.isWorldTrackingEnabled = true
        // Run the view's session
        self.arView.session.run(configuration)
        
        
        Experience.loadLesson1003Async(completion: { (result) in
            do {
                self.lesson1003Anchor = try result.get()
                self.arView.scene.anchors.append(self.lesson1003Anchor)
                // ...
                self.setupNotifyActions1003()
                print("👌lesson1003加载完成")
                
            } catch {
                // handle error
                print("❌lesson1003加载失败")
            }
        })
    }
    
    func setupNotifyActions1003(){
        
    }
    
}
