    /*
     See LICENSE folder for this sample’s licensing information.
     
     Abstract:
     Gesture additions to the app's main view controller.
     */
    
    import UIKit
    import ARKit
    import RealityKit
    
    extension ARViewController {
        
        // MARK: - Gesture recognizer setup
        // - Tag: AddViewTapGesture
        func arViewGestureSetup() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedOnARView))
            arView.addGestureRecognizer(tapGesture)
            
//            let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedDownOnARView))
//            swipeGesture.direction = .down
//            arView.addGestureRecognizer(swipeGesture)
        }
        
        func stickyNoteGestureSetup(_ note: StickyNoteEntity) {
            //        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnStickyView))
            //        note.view?.addGestureRecognizer(panGesture)
            
            let tapOnStickyView = UITapGestureRecognizer(target: self, action: #selector(tappedOnStickyView(_:)))
            note.view?.addGestureRecognizer(tapOnStickyView)
        }
        
        // MARK: - Gesture recognizer callbacks
        
        /// Tap gesture input handler.
        /// - Tag: TapHandler
        @objc
        func tappedOnARView(_ sender: UITapGestureRecognizer) {
            
            // Ignore the tap if the user is editing a sticky note.
            for note in stickyNotes where note.isEditing { return }
            
            // 点击的时候展示NoteLabel，3秒后自动关闭
            let tapLocation = sender.location(in: arView)
            
            guard let entityTapped = arView.entity(at: tapLocation) else {
                return
            }
            
            print(entityTapped.name)
            
            
            // 尝试失败，大概原因是通过Hittesting无法直接获得看到的那个entity的路径，而是其父路径。
            //        insertNewSticky(entityTapped)
            //        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            //            self.deleteStickyNote(of: entityTapped)
            //        }
        }
        

        /**
         添加标签修改版
         Hit test the feature point cloud and use any hit as the position of a new StickyNote. Otherwise, display a tip.
         - Tag: ScreenSpaceViewInsertionTag
         */
        func insertNewSticky(_ entity: Entity,offset: SIMD3<Float>? = [0,0,0]) {
            
            // 如果已经创建了同名Note则弹出
            let noteName = "label" + entity.name
            guard stickyNotes.firstIndex(where: {$0.name == noteName}) == nil else { return }
            
            // 如果label没有内容则退出
            guard let labelText = entity.accessibilityLabel  else {
                return
            }
            
            // Create a new sticky note positioned at the hit test result's world position.
            let frame = CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: 200, height: 40))
            
            let note = StickyNoteEntity(frame: frame, worldTransform: entity.transform.matrix,offset: offset)
            
            // Center the sticky note's view on the tap's screen location.
            //note.setPositionCenter(touchLocation)
            
            // Add the sticky note to the scene's entity hierarchy.
            // arView.scene.addAnchor(note)
            entity.parent?.addChild(note)
            
            // 取个名字用于之后找回，label+xxxx
            note.name = noteName
            
            // 标签上的文字更改一下
            note.view?.textView.text = labelText
            
            if entity.accessibilityDescription != nil {
                note.view?.textView.text =  labelText + "\n" + entity.accessibilityDescription!
            }
            // Add the sticky note's view to the view hierarchy.
            guard let stickyView = note.view else { return }
            arView.insertSubview(stickyView, belowSubview: trashZone)
            
            // Enable gestures on the sticky note.
            stickyNoteGestureSetup(note)
            
            // Save a reference to the sticky note.
            stickyNotes.append(note)
            
            // Volunteer to handle text view callbacks.
            //stickyView.textView.delegate = self
            
            print("创建标签",noteName)
        }

        
        @objc
        func tappedOnStickyView(_ sender: UITapGestureRecognizer) {
            guard let stickyView = sender.view as? StickyNoteView else { return }
            //stickyView.textView.becomeFirstResponder()
            if stickyView.frame.height == 40 {
                print("Click to big")
                UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
                    self.shadeView.alpha = 0.5
                }.startAnimation()
                
                //let editingFrame = CGRect(origin: stickyView.frame.origin, size: CGSize(width: 200, height: 200)).insetBy(dx: 10, dy: 10)
                let editingFrame = CGRect(origin: stickyView.frame.origin, size: CGSize(width: 200, height: 200))
                
                UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
                    stickyView.frame = editingFrame
                    //...
                    //stickyView.blurView.effect = UIBlurEffect(style: .light)
                    stickyView.layoutIfNeeded()
                }.startAnimation()
            }
            else {
                print("Click to small")
                let editingFrame = CGRect(origin: stickyView.frame.origin, size: CGSize(width: 200, height: 40))
                UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
                    self.shadeView.alpha = 0
                    stickyView.frame = editingFrame
                    //stickyView.blurView.effect = UIBlurEffect(style: .dark)
                    stickyView.layoutIfNeeded()
                }.startAnimation()
            }
        }
        
        
        
        
        //    //- Tag: PanOnStickyView
        //    // 拖动标签🏷️
        //    fileprivate func panStickyNote(_ sender: UIPanGestureRecognizer, _ stickyView: StickyNoteView, _ panLocation: CGPoint) {
        //        let feedbackGenerator = UIImpactFeedbackGenerator()
        //
        //        switch sender.state {
        //        case .began:
        //            // Prepare the taptic engine to reduce latency in delivering feedback.
        //            feedbackGenerator.prepare()
        //
        //            // Drag if the gesture is beginning.
        //            stickyView.stickyNote.isDragging = true
        //
        //            // Save offsets to implement smooth panning.
        //            guard let frame = sender.view?.frame else { return }
        //            stickyView.xOffset = panLocation.x - frame.origin.x
        //            stickyView.yOffset = panLocation.y - frame.origin.y
        //
        //            // Fade in the widget that's used to delete sticky notes.
        //            trashZone.fadeIn(duration: 0.4)
        //        case .ended:
        //            // Stop dragging if the gesture is ending.
        //            stickyView.stickyNote.isDragging = false
        //
        //            // Delete the sticky note if the gesture ended on the trash widget.
        //            if stickyView.isInTrashZone {
        //                deleteStickyNote(stickyView.stickyNote)
        //                // ...
        //            } else {
        //                attemptRepositioning(stickyView)
        //            }
        //
        //            // Fades out the widget that's used to delete sticky notes when there are no sticky notes currently being dragged.
        //            if !stickyNotes.contains(where: { $0.isDragging }) {
        //                trashZone.fadeOut(duration: 0.2)
        //            }
        //        default:
        //            // Update the sticky note's screen position based on the pan location, and initial offset.
        //            stickyView.frame.origin.x = panLocation.x - stickyView.xOffset
        //            stickyView.frame.origin.y = panLocation.y - stickyView.yOffset
        //
        //            // Give feedback whenever the pan location is near the widget used to delete sticky notes.
        //            trashZoneThresholdFeedback(sender, feedbackGenerator)
        //        }
        //    }
        //
        //    /// Sticky note pan-gesture handler.
        //    /// - Tag: PanHandler
        //    @objc
        //    func panOnStickyView(_ sender: UIPanGestureRecognizer) {
        //
        //        guard let stickyView = sender.view as? StickyNoteView else { return }
        //
        //        let panLocation = sender.location(in: arView)
        //
        //        // Ignore the pan if any StickyViews are being edited.
        //        for note in stickyNotes where note.isEditing { return }
        //
        //        panStickyNote(sender, stickyView, panLocation)
        //    }
        
        func deleteStickyNote(_ note: StickyNoteEntity) {
            guard let index = stickyNotes.firstIndex(of: note) else { return }
            note.removeFromParent()
            stickyNotes.remove(at: index)
            note.view?.removeFromSuperview()
            note.view?.isInTrashZone = false
        }
        
        func deleteStickyNote(of entity: Entity) {
            let noteName = "label" + entity.name
            guard let index = stickyNotes.firstIndex(where: {$0.name == noteName}) else { return }
            let note  = stickyNotes[index]
            note.removeFromParent()
            stickyNotes.remove(at: index)
            note.view?.removeFromSuperview()
            note.view?.isInTrashZone = false
        }
        
//        /// - Tag: AttemptRepositioning
//        // 拖动标签的时候重新找平面
//        fileprivate func attemptRepositioning(_ stickyView: StickyNoteView) {
//            // Conducts a ray-cast for feature points using the panned position of the StickyNoteView
//            let point = CGPoint(x: stickyView.frame.midX, y: stickyView.frame.midY)
//            if let result = arView.raycast(from: point, allowing: .estimatedPlane, alignment: .any).first {
//                stickyView.stickyNote.transform.matrix = result.worldTransform
//            } else {
//                print("No surface detected, unable to reposition note.")
//                stickyView.stickyNote.shouldAnimate = true
//            }
//        }
//
//        fileprivate func trashZoneThresholdFeedback(_ sender: UIPanGestureRecognizer, _ feedbackGenerator: UIImpactFeedbackGenerator) {
//
//            guard let stickyView = sender.view as? StickyNoteView else { return }
//
//            let panLocation = sender.location(in: trashZone)
//
//            if trashZone.frame.contains(panLocation), !stickyView.isInTrashZone {
//                stickyView.isInTrashZone = true
//                feedbackGenerator.impactOccurred()
//
//            } else if !trashZone.frame.contains(panLocation), stickyView.isInTrashZone {
//                stickyView.isInTrashZone = false
//                feedbackGenerator.impactOccurred()
//
//            }
//        }
        
        @objc
        func tappedReset(_ sender: UIButton) {
            reset()
        }
        
    }
