/*
See LICENSE folder for this sample’s licensing information.

Abstract:
UITextView additions to the app's main view controller.
*/

import UIKit

// MARK: - UITextViewDelegate
extension ARViewController: UITextViewDelegate {
    
    // - Tag: TextViewDidBeginEditing
    func textViewDidBeginEditing(_ textView: UITextView) {

        // Get the main view for this sticky note.
        guard let stickyView = textView.firstSuperViewOfType(StickyNoteView.self) else { return }
        // ...
        // Fade out the user interface when editting a sticky note.
        trashZone.fadeOut(duration: 0.3)
        
        // Cancel any active sticky note dragging.
        for note in stickyNotes where note.isDragging { note.screenSpaceComponent.isDragging = false }
        
        // If the sticky note being edited has placeholder text, then clear it.
        // 去掉之后可以保留初始文本
        //clearPlaceholderText(stickyView, textView)
        
        // Bring the sticky note being edited to the front.
        arView.insertSubview(stickyView, belowSubview: trashZone)
        
        // Begin editing.
        stickyView.stickyNote.isEditing = true

        // Brighten the sticky note and blur the background.
        focusOnStickyView(stickyView)

    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let stickyView = textView.firstSuperViewOfType(StickyNoteView.self) else { return }
        stickyView.stickyNote.shouldAnimate = true
        stickyView.stickyNote.isEditing = false
        unfocusOnStickyView(stickyView)
    }
    
    // MARK: - UITextViewDelegate Helper Functions
    
    fileprivate func clearPlaceholderText(_ stickyView: StickyNoteView, _ textView: UITextView) {
        if !stickyView.placeHolderWasRemoved {
            textView.text = ""
            textView.textColor = .white
            stickyView.placeHolderWasRemoved = true
        }
    }
    
    fileprivate func focusOnStickyView(_ stickyView: StickyNoteView) {
        UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
            self.shadeView.alpha = 1
        }.startAnimation()
        animateStickyViewToEditingFrame(stickyView)
    }
    
    fileprivate func unfocusOnStickyView(_ stickyView: StickyNoteView) {
        UIViewPropertyAnimator(duration: 0.4, curve: .easeIn) {
            self.shadeView.alpha = 0
            stickyView.frame = stickyView.lastFrame
            stickyView.blurView.effect = UIBlurEffect(style: .dark)
            stickyView.layoutIfNeeded()
        }.startAnimation()
    }

    fileprivate func animateStickyViewToEditingFrame(_ stickyView: StickyNoteView) {
        let safeFrame = view.safeAreaLayoutGuide.layoutFrame
        let height = safeFrame.height - keyboardHeight
        let inset = height * 0.05
        let editingFrame = CGRect(origin: safeFrame.origin, size: CGSize(width: safeFrame.width, height: height)).insetBy(dx: inset, dy: inset)
        UIViewPropertyAnimator(duration: 0.2, curve: .easeIn) {
            stickyView.frame = editingFrame
            //...
            stickyView.blurView.effect = UIBlurEffect(style: .light)
            stickyView.layoutIfNeeded()
        }.startAnimation()
    }
    
}
