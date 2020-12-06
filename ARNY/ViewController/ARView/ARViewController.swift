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
    var pointImg: UIImageView!
    
    // 控制栏
    @IBOutlet var controllNext: UIButton!
    @IBOutlet var controllBack: UIButton!
    @IBOutlet var controllStackView: UIStackView!
    var segmentedControl : UISegmentedControl!
    var switchControl:UISwitch!
    var pickView:UIPickerView!
    
    /// POP
    @IBOutlet var popView: UIView!
    @IBOutlet var popImageViewCont: UIView!
    var popImageView: UIImageView!
    @IBOutlet var popButtonsCont: UIView!
    var popLeftButton: UIButton!
    var popRightButton: UIButton!
    @IBOutlet var popStarSegmentControlCont: UIView!
    var popStarSegmentControl: UISegmentedControl!
    @IBOutlet var popLabelCont: UIView!
    var popLabel: UILabel!
    
    // 课程信息
    var lessonID:Int = 999
    var pointID:Int = 999
    var currentLesson: Lesson!
    var currentPoint: Lesson.point!
    var pointsCount: Int = 0
    /// 分支流程太多了，需要一个变量来代表一下当前走的分支流程是哪一个！！
    var lessonPath: Int = 0
    
    // AR resources
    var worldAnchor : AnchorEntity!
    
    //var lessonAnchors: [AnchorEntity]!
    var lesson1000Anchor: Experience.Lesson1000!
    var lesson1000FaceAnchor : Experience.Lesson1000Face!
    var lesson1000SimulationAnchor: Experience.Lesosn1000Simulation!
    var lesson10000MaskAnchor: Experience.Lesson1000WithRealMask!
    var lesson1001Anchor: Experience1.Lesson1001!
    var lesson1001ScaleAnchor: Experience1.Lesson1001Scale!
    var lesson1001MeltblownAnchor: Experience1.Lesson1001Meltblown!
    var lesson1002Anchor: Experience2.Lesson1002!
    var lesson1002s1Anchor: Experience2.Lesson1002s1!
    var lesson1002s2Anchor: Experience2.Lesson1002s2!
    var lesson1002s3Anchor: Experience2.Lesson1002s3!
    var lesson1002s4Anchor: Experience2.Lesson1002s4!
//    var lesson1003Anchor: Experience.Lesson1003!
//    var lesson1004Anchor: Experience.Lesson1004!
    
    
    var loadingView:UIView!
    var processImageView:UIImageView!
    var goBackButton: UIButton!
    var processView : UIProgressView!
    var processLabel : UILabel!
    
    // StikyNotes
    var stickyNotes = [StickyNoteEntity]()
    var trashZone: GradientView!
    var shadeView: UIView!
    var keyboardHeight: CGFloat! = 250
    var subscription: Cancellable!
    
    var topMaskZone: GradientView!
    
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlayUISetup()
        
        //课程信息初始化
        initLP()
        
        // UI初始化
        initUI()
        
        // 准备AR课程素材
        setupARLessonResources()
        
        // StikyNote
        subscription = arView.scene.subscribe(to: SceneEvents.Update.self) { [unowned self] in
            self.updateScene(on: $0)
        }
        arViewGestureSetup()
        worldAnchor = AnchorEntity(world: .zero)
        arView.scene.anchors.append(worldAnchor)
        arView.session.delegate = self
        
        
        
//        arView.debugOptions.insert(.showStatistics)
//        arView.debugOptions.insert(.showAnchorGeometry)
//        arView.debugOptions.insert(.showAnchorOrigins)
//        arView.debugOptions.insert(.showPhysics)
//        arView.debugOptions.insert(.showWorldOrigin)
//        arView.renderOptions.insert(.disableMotionBlur)
        
        
        // Capture the default value after you initialize the view.
        let defaultScaleFactor = arView.contentScaleFactor
        
        // Scale as needed. For example, here the scale factor is
        // set to 75% of the default value.
        arView.contentScaleFactor = 0.75 * defaultScaleFactor
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Prevent the screen from being dimmed to avoid interuppting the AR experience.
        UIApplication.shared.isIdleTimerDisabled = true
        
    }
    
    // MARK: - AR Lesson Resources
    func setupARLessonResources() {
        // AR 配置工作
        switch  lessonID {
        case 999:
            loadARNY()
        case 1000:
            loadLesson1000()
        case 1001:
            loadLesson1001()
        case 1002:
            loadLesson1002()
//        case 1003:
//            loadLesson1003()
//        case 1004:
//            loadLesson1004()
        default:
            print("本AR课程未就绪")
            arView.removeFromSuperview()
            goBackButton.isHidden = false
            processLabel.isHidden = true
            processView.isHidden = true
        }
        
    }
    
    // MARK: - StikyNote
    func updateScene(on event: SceneEvents.Update) {
        let notesToUpdate = stickyNotes.compactMap { !$0.isEditing && !$0.isDragging ? $0 : nil }
        for note in notesToUpdate {
            // Gets the 2D screen point of the 3D world point.
            // 写这个地方的时候我凌乱了，这个地方写了一个迂回的策略，用了note.parent?.parent?.parent?.parent?.parent)（不知道🍎正确的处理应该是如何的，似乎不存在arView.scene的entity之说）
            // note.position(relativeTo: note.parent?.parent?.parent?.parent)
            guard let projectedPoint = arView.project(note.position(relativeTo: worldAnchor.parent)) else { return }
            
            // Calculates whether the note can be currently visible by the camera.
            // 这边都没问题
            let cameraForward = arView.cameraTransform.matrix.columns.2[SIMD3(0, 1, 2)]
            let cameraToWorldPointDirection = normalize(note.position(relativeTo: note.parent?.parent?.parent?.parent) - arView.cameraTransform.translation)
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
        arView.scene.anchors.removeAll()
        for note in stickyNotes {
            deleteStickyNote(note)
        }
        print("AR Sesson Reset")
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
            currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == lessonID})!]
            
            if pointID != 999 {
                print("从上级页面接收pointID=", pointID)
                updatePoints()
            } else {
                currentPoint = currentLesson.points.first!
                pointID = currentPoint.id
                print("未从上级页面接收到PointID，设置为PointID默认值", pointID)
            }
            
            pointsCount = currentLesson.points.count
            print("课程信息载入完成，当前课程位于",lessonID, pointID,"课程共有",pointsCount)
            
            processImageView.image = UIImage(named: currentLesson.imageName)
        } else {
            //lessonID = 1000
            print("未从上级页面接收到lessonID，进入ARNY")
        }
    }
    
    func updatePoints(){
        currentPoint = currentLesson.points[currentLesson.points.firstIndex(where: { $0.id == pointID })!]
    }
    
    
    
    // MARK: - UI
    
    func initUI(){
        // 更新UI信息，包括文案、按钮
        if !ARFaceTrackingConfiguration.isSupported {
            buttonSwitchCamera.isHidden = true
        }
        
        switch lessonID {
        // ARNY
        case 999:
            buttonSwitchCamera.isHidden  = false
        default:
            buttonSwitchCamera.isHidden = true
        }
        
        // 控制按钮
        controllStackView.isHidden = true
        controllNext.isHidden = true
        controllBack.isHidden = true
        controllNext.addTarget(self, action: #selector(controlNext(_ :)), for: .touchUpInside)
        controllBack.addTarget(self, action: #selector(controlBack(_ :)), for: .touchUpInside)
        
        segmentedControl = (controllStackView.viewWithTag(12) as! UISegmentedControl)
        pickView = (controllStackView.viewWithTag(22) as! UIPickerView)
        switchControl = (controllStackView.viewWithTag(32) as! UISwitch)
        
        // pop view
        popImageView = (popView.viewWithTag(1) as! UIImageView)
        popLabel = (popView.viewWithTag(2) as! UILabel)
        popStarSegmentControl = (popView.viewWithTag(3) as! UISegmentedControl)
        popLeftButton =  (popView.viewWithTag(4) as! UIButton)
        popRightButton =  (popView.viewWithTag(5) as! UIButton)
        //popView.layer.applySketchShadow(color: UIColor(red: 0.44, green: 0.53, blue: 0.82, alpha: 1.00), alpha: 0.2, x: 0, y: 10, blur: 30, spread: 0)

        
        // info view
        InfoView.isHidden = true
        pointImg = (InfoView.viewWithTag(123) as! UIImageView)
        pointImg.contentMode = .scaleAspectFill
    }
    
    /// 更新UI元素
    func updateUI(_ lessionID: Int, _ pointID: Int){
        // 根据lessionID和pointID查找数据
        guard let index = currentLesson.points.firstIndex(where: { $0.id == pointID }) else {
            print("没有找到pointID", pointID)
            return
        }
        
        currentPoint = currentLesson.points[index]
        
        // Info View 展示
        InfoView.isHidden = false
        if currentLesson.isWithSteps {
            pointNStep.text = "STEP " + String(index+1) + "/" + String(pointsCount)
        } else {
            pointNStep.text = currentLesson.category
        }
        pointName.text = currentPoint.name
        pointDetail.text = currentPoint.detail
        print("更新数据成功：Point",pointID)
        
        // 控制按钮，上一步和下一步
        guard controllNext.titleLabel?.text != "Back to Main" else {
            return
        }
        if currentLesson.isWithSteps {
            // 步骤类课程，暂不做处理，不展示上一步和下一步按钮
            // 目前来说更理想的方案是，可以回退之前的，但是无法Next到下一步（可以之后再加，需要引入LatestPoint变量）
            
            if ((index+1) == pointsCount) {
                controllNext.setTitle("End Lesson", for: .normal)
            }else {
                //
            }
        } else
        {   /// 不是按照步骤，而是按照知识点的，显示步骤按钮，支持用户随意切换Point（目前技术上无法支持在AR中响应）
            self.controllNext.isHidden = false
            if ((index+1) == pointsCount) {
                controllNext.setTitle("End Lesson", for: .normal)
            }else {
                self.controllNext.setTitle("Next Point", for: .normal)
            }
            
            // point为1时隐藏返回按钮
            if ((pointID - 2000) == 1) {
                controllBack.isHidden = true
            }else {
                controllBack.isHidden = false
            }
        }
        
    }
    
    /// restore控制按钮，上一步和下一步
    func restoreNextNBack(){
        controllNext.isHidden = false
        controllNext.setTitle("Next Point", for: .normal)
        controllNext.addTarget(self, action: #selector(controlNext(_ :)), for: .touchUpInside)
        
        controllBack.isHidden = true
    }
    
    func showNotification(_ lessionID: Int){
        //读取课程信息，使用局部变量
        let currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == self.lessonID})!]
        
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
    
    
    func setColor(entity : Entity, color: UIColor){
        var noseModelComp: ModelComponent = (entity.components[ModelComponent])!
        let material = SimpleMaterial(color: color, isMetallic: false)
        noseModelComp.materials[0] = material
        entity.components.set(noseModelComp)
    }
    
    // MARK: - UI Interaction
    
    @IBAction func BtnBack(_ sender: Any) {
        
        //pop确认
        popView.isHidden = false
        popStarSegmentControlCont.isHidden = true
        popImageViewCont.isHidden = true
        popButtonsCont.isHidden = false
        
        popLabel.text = "Comfirm to Quit"
        popRightButton.isHidden = false
        popLeftButton.isHidden = false
        popRightButton.addTarget(self, action: #selector(popRightButtonRateNExit(_ :)), for: .touchUpInside)
        popLeftButton.addTarget(self, action:#selector(popLeftButtonClose(_ :)), for: .touchUpInside)
    }
    
    @IBAction func buttonSwitchCamera(_ sender: Any) {
        // 加载不同ARkit配置，切换相机
        if arView.session.configuration is ARFaceTrackingConfiguration {
            self.arView.scene.anchors.removeAll()
            arView.session.run(ARWorldTrackingConfiguration(), options: [.resetTracking, .removeExistingAnchors])
            setupARLessonResources()
            print("切换回之后无法进行追踪，暂时无法解决⚠️")
        } else {
            // 开启前置摄像头面部识别Indicate to use the FaceTrackingConfiguration (front camera)
            guard ARFaceTrackingConfiguration.isSupported else { return }
            self.arView.scene.anchors.removeAll()
            let configuration = ARFaceTrackingConfiguration()
            configuration.isLightEstimationEnabled = true
            arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        }
    }
    
    @IBAction func buttonNotification(_ sender: Any) {
        
        switch lessonID {
        case 1000:
            startLesson1000()
        case 1001:
            startLesson1001()
        case 1002:
            startLesson1002()
        case 1003:
            startLesson1003()
        case 1004:
            startLesson1004()
        default:
            startLessonARNY()
        }
        
        notificationBar.isHidden = true
    }
    
    
    /// 下一步和上一步操作，原则上，上一步和下一步需要在AR中进行直接反馈，但是由于技术限制，因此仅展示文案变化。
    @objc func controlNext(_ sender: Any) {
        /// 结束课程
        if (self.controllNext.titleLabel?.text == "End Lesson") {
            //pop
            popView.isHidden = false
            popStarSegmentControlCont.isHidden = false
            popImageViewCont.isHidden = true
            popButtonsCont.isHidden = false
            
            popLabel.text = "This lesson has been completed"
            popRightButton.isHidden = false
            popLeftButton.isHidden = false
            popRightButton.addTarget(self, action: #selector(popRightButtonRateNExit(_ :)), for: .touchUpInside)
            popLeftButton.addTarget(self, action:#selector(popLeftButtonClose(_ :)), for: .touchUpInside)
        } else {
            // 正常Next
            //            // 先执行本课程中的任务
            //            switch lessonID {
            //            case 1000:
            //                do{
            //                    //perform1000(at: pointID)
            //                }
            //            default: break
            //            }
            //更新UI
            pointID += 1
            updateUI(lessonID, pointID)
        }
    }
    
    @objc func controlBack(_ sender: Any) {
        // 更新UI
        pointID -= 1
        updateUI(lessonID, pointID)
        
        
        //        switch lessonID {
        //        case 1000:
        //            do {
        //
        //                //perform1000(at: pointID)
        //            }
        //        case 1001:
        //            do {
        //
        //                //perform1001(to: pointID)
        //            }
        //        default: break
        //        //
        //        }
    }
    
    /// EndLessonPopComfirm
    @objc func popRightButtonRateNExit(_ sender: UIButton){
        self.popView.isHidden = true
        // 打分存储
        
        
        // 退出
        navigationController?.popViewController(animated: true)
    }
    
    @objc func popLeftButtonClose(_ sender: UIButton){
        //close the pop view and do nothing
        self.popView.isHidden = true
    }
    
    
    /// Scan Guide
    func showGuide(){
        self.popView.isHidden = false
        self.popImageViewCont.isHidden = false
        self.popButtonsCont.isHidden = true
        self.popStarSegmentControlCont.isHidden = true
        
        if lessonID != 999 {
            self.popLabel.text = "Scan the object in the picture"
            //self.popImageView.image = UIImage(named: "1001T.jpg")
            self.popImageView.image = UIImage(named: String(lessonID) + "T.jpg")
            
        } else {
            self.popLabel.text = "ANRY Mode. Scan Anything."
            self.popImageView.image = UIImage(named: "ARNY.png")
        }
        
        
        
    }
    
    /// hide Guide
    func hideGuide(){
        self.popView.isHidden = true
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
