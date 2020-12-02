/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Methods on the main view controller for conforming to the ARCoachingOverlayViewDelegate protocol.
*/

import UIKit
import ARKit

extension ARViewController: ARCoachingOverlayViewDelegate {
    
    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        messageLabel.ignoreMessages = true
//        messageLabel.isHidden = true
//        restartButton.isHidden = true
        
        // Disables user interaction when the coaching overlay activates.
        view.isUserInteractionEnabled = false
        
//        // Stops editing of sticky notes if any are being edited when the coaching overlay activates.
//        for stickyNote in stickyNotes where stickyNote.isEditing {
//            stickyNote.shouldAnimate = true
//            stickyNote.isEditing = false
//            //guard let stickyView = stickyNote.view else { return }
//            //stickyView.textView.dismissKeyboard()
//        }
    }

    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        messageLabel.ignoreMessages = false
//        restartButton.isHidden = false
        
        // Re-enables user interaction once the coaching overlay deactivates.
        view.isUserInteractionEnabled = true
    }

    func coachingOverlayViewDidRequestSessionReset(_ coachingOverlayView: ARCoachingOverlayView) {
//        resetTracking()
    }

}
