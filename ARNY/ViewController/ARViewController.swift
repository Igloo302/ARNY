//
//  ViewController.swift
//  ARNY
//
//  Created by Igloo on 2020/11/22.
//

import UIKit
import RealityKit
import ARKit

import Combine

class ARViewController: UIViewController,ARSessionDelegate {
    
    @IBOutlet var arView: ARView!
    
    
    // 右上角功能按钮
    @IBOutlet weak var buttonSwitchCamera: UIButton!
    
    // 通知Bar
    @IBOutlet var notificationBar: UIView!
    @IBOutlet var notiBarName: UILabel!
    @IBOutlet var notiBarCat: UILabel!
    @IBOutlet var notiBarImg: UIImageView!
    
    // 信息栏
    @IBOutlet var InfoView: UIView!
    @IBOutlet var pointNStep: UILabel!
    @IBOutlet var pointName: UILabel!
    @IBOutlet var pointDetail: UITextView!
    
    // 控制栏
    @IBOutlet var controllNext: UIButton!
    @IBOutlet var controllBack: UIButton!
    @IBOutlet var controllStackView: UIStackView!
    
    // CoachingOverlay
    let coachingOverlay = ARCoachingOverlayView()
    
    // 课程信息
    var lessonID:Int = 999
    var pointID:Int = 999
    var currentLesson: Lesson!
    var currentPoint: Lesson.point!
    var pointsCount: Int = 0
    
    // AR resources
    var lesson1000Anchor: Experience.Lesson1000!
    var lesson1000FaceAnchor : Experience.Lesson1000Face!
    
    // StikyNotes
    var stickyNotes = [StickyNoteEntity]()
    var trashZone: GradientView!
    var shadeView: UIView!
    var keyboardHeight: CGFloat! = 0
    var subscription: Cancellable!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setupCoachingOverlay()
        
        //课程信息初始化
        initLP()
        
        // UI初始化
        initUI()
        
        // 准备AR课程素材
        setupARLessonResources()
        
        // StikyNote
        subscription = arView.scene.subscribe(to: SceneEvents.Update.self) { [unowned self] in
            self.updateScene(on: $0)//这句话什么意思
        }
        arViewGestureSetup()
        overlayUISetup()
        arView.session.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // Add observer to the keyboardWillShowNotification to get the height of the keyboard every time it is shown
        // 检测键盘是否出来
//        let notificationName = UIResponder.keyboardWillShowNotification
//        let selector = #selector(keyboardIsPoppingUp(notification:))
//        NotificationCenter.default.addObserver(self, selector: selector, name: notificationName, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    // MARK: - StikyNote
    func updateScene(on event: SceneEvents.Update) {
        let notesToUpdate = stickyNotes.compactMap { !$0.isEditing && !$0.isDragging ? $0 : nil }
        for note in notesToUpdate {
            // Gets the 2D screen point of the 3D world point.
            // 这个地方写了一个迂回的策略，用了note的parent的parent（不知道🍎正确的处理应该是如何的，似乎不存在arView.scene的entity之说）
            guard let projectedPoint = arView.project(note.position(relativeTo: note.parent?.parent)) else { return }
            
            // Calculates whether the note can be currently visible by the camera.
            // 这边都没问题
            let cameraForward = arView.cameraTransform.matrix.columns.2[SIMD3(0, 1, 2)]
            let cameraToWorldPointDirection = normalize(note.transform.translation - arView.cameraTransform.translation)
            let dotProduct = dot(cameraForward, cameraToWorldPointDirection)
            let isVisible = dotProduct < 0

            // Updates the screen position of the note based on its visibility
            note.projection = Projection(projectedPoint: projectedPoint, isVisible: isVisible)
            note.updateScreenPosition()
        }
    }
    
    func reset() {
        guard let configuration = arView.session.configuration else { return }
        arView.session.run(configuration, options: .removeExistingAnchors)
        for note in stickyNotes {
            deleteStickyNote(note)
        }
    }
    
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // 单纯的错误检测和错误弹窗
        guard error is ARError else { return }
        
        let errorWithInfo = error as NSError
        let messages = [
            errorWithInfo.localizedDescription,
            errorWithInfo.localizedFailureReason,
            errorWithInfo.localizedRecoverySuggestion
        ]
        let errorMessage = messages.compactMap({ $0 }).joined(separator: "\n")
        
        DispatchQueue.main.async {
            // Present an alert informing about the error that has occurred.
            let alertController = UIAlertController(title: "The AR session failed.", message: errorMessage, preferredStyle: .alert)
            let restartAction = UIAlertAction(title: "Restart Session", style: .default) { _ in
                alertController.dismiss(animated: true, completion: nil)
                self.reset()
            }
            alertController.addAction(restartAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Lesson & Point Content
    func initLP(){
        // 课程信息初始化
        if lessonID != 999 {
            print("从上级页面接收lessonID=", lessonID)
        } else {
            lessonID = 1000
            print("未从上级页面接收到lessonID，设置为默认值1000")
        }
        currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == lessonID})!]
        
        
        if pointID != 999 {
            print("从上级页面接收pointID=", pointID)
            updatePoints()
        } else {
            currentPoint = currentLesson.points.first!
            pointID = currentPoint.id
            print("未从上级页面接收到lessonID，设置为本leeson默认值", pointID)
        }

        pointsCount = currentLesson.points.count
        
        print("当前课程位于",lessonID, pointID)
    }
    
    func updatePoints(){
        currentPoint = currentLesson.points[currentLesson.points.firstIndex(where: { $0.id == pointID })!]
    }
    
    // MARK: - AR Lesson Resources
    func setupARLessonResources() {
        // 需要lessonid相关和异步加载
        // AR 配置工作
        lesson1000Anchor = try! Experience.loadLesson1000()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(lesson1000Anchor)
        
        // 响应Reality Composer设置的actions
        setupNotifyActions1000()
        

    }
    
    // MARK: - UI
    
    func initUI(){
        // 更新UI信息，包括文案、按钮
        if !ARFaceTrackingConfiguration.isSupported {
            buttonSwitchCamera.isHidden = true
        }
        
        // lessonID不为0，进入学习流程，不展示相机切换按钮
        if lessonID != 0 {
            buttonSwitchCamera.isHidden = true
        }
    }
    
    func updateUI(_ lessionID: Int, _ pointID: Int){
        
        // 界面元素（需要根据课程是否有信息展示）
        InfoView.isHidden = false
        // controllNext.isHidden = false
        // controllBack.isHidden = false
        
        // 根据lessionID和pointID查找数据
        let index = currentLesson.points.firstIndex(where: { $0.id == pointID })!
        pointNStep.text = "STEP " + String(index+1) + "/" + String(pointsCount)
        pointName.text = currentPoint.name
        pointDetail.text = currentPoint.detail
        
        
    }
    
    func showNotification(_ lessionID: Int){
        notificationBar.isHidden = false
        notiBarName.text = currentLesson.name
        notiBarCat.text = currentLesson.category
        notiBarImg.image = UIImage(named: currentLesson.imageName)
        notiBarImg.contentMode = .scaleAspectFill
        
        // 延迟8s后消失
        DispatchQueue.main.asyncAfter(deadline: .now() + 8){
            self.notificationBar.isHidden = true
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    // MARK: - RealityKit Interaction
    
    func setupNotifyActions1000(){
        lesson1000Anchor.actions.onShow.onAction = { entity in
            // 场景出现
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
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1000Anchor.actions.showPoint2.onAction = {entity in
            //知识点2
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
        }
        
        lesson1000Anchor.actions.showPoint3.onAction = {entity in
            //知识点3
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1000Anchor.actions.showPoint4.onAction = {entity in
            //知识点4
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1000Anchor.actions.showPoint5.onAction = {entity in
            //知识点5
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
            
            // 切换摄像头
            self.buttonSwitchCamera(self)
            
            self.lesson1000FaceAnchor = try! Experience.loadLesson1000Face()
            self.arView.scene.anchors.append(self.lesson1000FaceAnchor)
            self.setupNotifyActions1000Face()
        }
    }
    
    func setupNotifyActions1000Face(){
        lesson1000FaceAnchor.actions.showPoint6.onAction = {entity in
            //知识点6
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
        
        lesson1000FaceAnchor.actions.showPoint7.onAction = {entity in
            //知识点7
            self.pointID += 1
            self.updatePoints()
            self.updateUI(self.lessonID, self.pointID)
        }
    }
    
    
    
    // MARK: - UI Interaction
    
    @IBAction func BtnBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
        //self.dismiss(animated: true, completion:nil)
    }
    
    @IBAction func buttonSwitchCamera(_ sender: Any) {
        // 加载不同ARkit配置，切换相机
        if arView.session.configuration is ARFaceTrackingConfiguration {
            arView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
            setupARLessonResources()
            print("切换回之后无法进行追踪，暂时无法解决⚠️")
        } else {
            // 开启前置摄像头面部识别Indicate to use the FaceTrackingConfiguration (front camera)
            guard ARFaceTrackingConfiguration.isSupported else { return }
            let configuration = ARFaceTrackingConfiguration()
            configuration.isLightEstimationEnabled = true
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    @IBAction func buttonNotification(_ sender: Any) {
        
        lesson1000Anchor.notifications.onStartByNoti.post()
        notificationBar.isHidden = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
