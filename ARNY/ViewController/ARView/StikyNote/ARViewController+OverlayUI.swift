/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Overlay UI additions to the app's main view controller.
*/

import UIKit
import ARKit

extension ARViewController {
    
    // MARK: - Overlay UI layout constraints and setup
    
    func overlayUISetup() {
        
        // Setting up the shadeView, which is used to dim the camera feed when a user is editing a Sticky (helps to draw the user's focus).
        setupShadeView()
        
        // Setting up the trashZone, which is used to delete StickyViews and their associated StickyNotes.
        setupTrashZone()
        
        // Adding a Reset button, the user should always be able to reset the AR Experience at all times.
        //addResetButton()
        
        // Adding the ARCoachingOverlayView, which helps guide users to establish tracking.
        addCoachingOverlay()
        
        // 添加顶部的按钮下的阴影
        setupTopMaskZone()
        
        // Adding loading View
        setupLoadingView()
        addProcessView()
        
    }
    
    fileprivate func setupShadeView() {
        shadeView = UIView(frame: .zero)
        shadeView.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(shadeView)
        NSLayoutConstraint.activate([
            shadeView.topAnchor.constraint(equalTo: arView.topAnchor),
            shadeView.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            shadeView.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            shadeView.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
        ])
        shadeView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        shadeView.alpha = 0
    }
    
    fileprivate func setupTrashZone() {
        trashZone = GradientView(topColor: UIColor.red.withAlphaComponent(0.7).cgColor, bottomColor: UIColor.red.withAlphaComponent(0).cgColor)
        trashZone.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(trashZone)
        NSLayoutConstraint.activate([
            trashZone.topAnchor.constraint(equalTo: arView.topAnchor),
            trashZone.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            trashZone.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            trashZone.heightAnchor.constraint(equalTo: arView.heightAnchor, multiplier: 0.33)
        ])
        trashZone.alpha = 0
        addDeleteLabel()
    }
    
    fileprivate func addDeleteLabel() {
        // Adding a Delete label to the trashZone for clarity
        let deleteLabel = UILabel()
        deleteLabel.translatesAutoresizingMaskIntoConstraints = false
        trashZone.addSubview(deleteLabel)
        NSLayoutConstraint.activate([
            deleteLabel.topAnchor.constraint(equalTo: trashZone.safeAreaLayoutGuide.topAnchor, constant: 5),
            deleteLabel.centerXAnchor.constraint(equalTo: trashZone.centerXAnchor)
        ])
        deleteLabel.text = "Delete"
        deleteLabel.textColor = .white
    }
    
    fileprivate func addResetButton() {
        let resetButton = UIButton()
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(resetButton)
        NSLayoutConstraint.activate([
            resetButton.bottomAnchor.constraint(equalTo: arView.safeAreaLayoutGuide.bottomAnchor),
            resetButton.trailingAnchor.constraint(equalTo: arView.trailingAnchor, constant: -25)
        ])
        resetButton.setImage(UIImage(imageLiteralResourceName: "restart"), for: .normal)
        resetButton.addTarget(self, action: #selector(tappedReset(_:)), for: .touchUpInside)
        resetButton.showsTouchWhenHighlighted = true
        resetButton.alpha = 0.7
    }
    
    fileprivate func addCoachingOverlay() {
        let coachingOverlay = ARCoachingOverlayView(frame: arView.frame)
        coachingOverlay.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(coachingOverlay)
        NSLayoutConstraint.activate([
            coachingOverlay.topAnchor.constraint(equalTo: arView.topAnchor),
            coachingOverlay.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            coachingOverlay.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            coachingOverlay.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
        ])
        coachingOverlay.goal = .tracking
        coachingOverlay.session = arView.session
        coachingOverlay.delegate = self
    }
    
    fileprivate func setupTopMaskZone() {
        topMaskZone = GradientView(topColor: UIColor.white.withAlphaComponent(0.7).cgColor, bottomColor: UIColor.white.withAlphaComponent(0).cgColor)
        topMaskZone.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(topMaskZone)
        NSLayoutConstraint.activate([
            topMaskZone.topAnchor.constraint(equalTo: arView.topAnchor),
            topMaskZone.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            topMaskZone.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            topMaskZone.heightAnchor.constraint(equalTo: arView.heightAnchor, multiplier: 105/834)
        ])
        topMaskZone.alpha = 0
    }
    
    fileprivate func setupLoadingView() {
        loadingView = UIView(frame: .zero)
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        arView.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: arView.topAnchor),
            loadingView.leadingAnchor.constraint(equalTo: arView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: arView.trailingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: arView.bottomAnchor)
        ])
        loadingView.backgroundColor = UIColor.white
    }
    
    
    fileprivate func addProcessView() {
        let processLabel = UILabel()
        processLabel.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(processLabel)
        processLabel.text = "Now Loading..."

        let processView = UIProgressView()
        processView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.addSubview(processView)
        processView.setProgress(0.9, animated: true)
        
        NSLayoutConstraint.activate([
            processLabel.widthAnchor.constraint(equalToConstant: 300),
            processLabel.heightAnchor.constraint(equalToConstant: 30),
            processLabel.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            processLabel.bottomAnchor.constraint(equalTo:processView.topAnchor , constant: 50),
            
            processView.widthAnchor.constraint(equalToConstant: 300),
            processView.heightAnchor.constraint(equalToConstant: 10),
            processView.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            processView.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor)
        ])
        
    }
}
