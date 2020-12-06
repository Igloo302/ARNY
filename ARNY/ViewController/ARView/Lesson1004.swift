import UIKit
import ARKit
import RealityKit
import Combine

extension ARViewController {
    
    func startLesson1004() {
        // lesson1003Anchor.notifications.onStartByNoti.post()
    }
    
    func loadLesson1004(){
        print("⌚️开始载入...")
        
        self.loadingView.isHidden = false
        
//        // Create a session configuration
//        let configuration = ARFaceTrackingConfiguration()
//        // Yasss estimate light for me
//        configuration.isLightEstimationEnabled = true
//        // Enable back camera to do world tracking
//        // configuration.isWorldTrackingEnabled = true
//        // Run the view's session
//        self.arView.session.run(configuration)
        
//        
//        Experience.loadLesson1004Async(completion: { (result) in
//            do {
//                
//                
//                self.lesson1004Anchor = try result.get()
//                self.arView.scene.anchors.append(self.lesson1004Anchor)
//                // ...
//                self.setupNotifyActions1004()
//                print("👌lesson1004加载完成")
//                
//                self.loadingView.isHidden = true
//            
//                self.insertNewSticky(self.lesson1004Anchor.mouth!, offset: [0.05,0,0])
//                self.insertNewSticky(self.lesson1004Anchor.mouth2!, offset: [0.05,0,0])
//                self.insertNewSticky(self.lesson1004Anchor.mouth3!, offset: [0.05,0,0])
//            } catch {
//                // handle error
//                print("❌lesson1004加载失败")
//            }
//        })
    }
    
    func setupNotifyActions1004(){
        
    }
    
    
    
    
}
