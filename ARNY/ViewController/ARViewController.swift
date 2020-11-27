//
//  ViewController.swift
//  ARNY
//
//  Created by Igloo on 2020/11/22.
//

import UIKit
import RealityKit
import ARKit

class ARViewController: UIViewController {
    
    @IBOutlet var arView: ARView!
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCoachingOverlay()
        
        // 开启前置摄像头面部识别Indicate to use the FaceTrackingConfiguration (front camera)
        //        guard ARFaceTrackingConfiguration.isSupported else { return }
        //        let configuration = ARFaceTrackingConfiguration()
        //        configuration.isLightEstimationEnabled = true
        
        
        //课程信息初始化
        initLP()
        
        // UI初始化
        initUI()
    
        // AR 配置工作 (需要改成lessionID相关）
        lesson1000Anchor = try! Experience.loadLesson1000()
        
        // Add the box anchor to the scene
        arView.scene.anchors.append(lesson1000Anchor)
        
        // 响应Reality Composer设置的actions
        setupNotifyActions1000()
        
        
        
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
        
        // 延迟5s后消失
        DispatchQueue.main.asyncAfter(deadline: .now() + 5){
            self.notificationBar.isHidden = true
        }
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
            // 切换回之后无法进行追踪
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
