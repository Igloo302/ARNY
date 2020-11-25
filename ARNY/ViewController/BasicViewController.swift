//
//  BasicViewController.swift
//  ARNY
//
//  Created by Igloo on 2020/11/23.
//

import UIKit

class BasicViewController: UIViewController {
    
    // 信息栏
    @IBOutlet var InfoView: UIView!
    @IBOutlet var pointNStep: UILabel!
    @IBOutlet var pointName: UILabel!
    @IBOutlet var pointDetail: UITextView!

    @IBOutlet weak var imgForBasic: UIImageView!
    
    
    // 控制栏
    @IBOutlet var controllNext: UIButton!
    @IBOutlet var controllBack: UIButton!
    @IBOutlet var controllStackView: UIStackView!
    
    // 课程信息
    var lessonID:Int = 999
    var pointID:Int = 999
    var currentLesson: Lesson!
    var currentPoint: Lesson.point!
    var pointsCount: Int = 0
    
    // 头部
    @IBOutlet weak var buttonAR: UIButton!

    @IBOutlet weak var infoViewConstraintsButton: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //课程信息初始化
        initLP()
        
        // UI初始化
        initUI()
        updateUI(lessonID, pointID)
    }
    
    // MARK: - UI Interaction
    @IBAction func buttonBack(_ sender: Any) {
        //self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonAR(_ sender: Any) {
        print("启动AR Mode")
        
//        // Segue方式跳转
//        performSegue(withIdentifier: "ToARView", sender: self)
        
        // Navigation模式生效
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = (storyboard.instantiateViewController(withIdentifier: "arMode") ) as! ARViewController
        newVC.lessonID = lessonID
        print("目前不支持basic Mode到AR mode直接跳到某一点point，仅支持从零开始")
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func controllNext(_ sender: Any) {
        pointID += 1
        updatePoints()
        print(lessonID, pointID)
        updateUI(lessonID, pointID)
    }
    
    
    @IBAction func controllBack(_ sender: Any) {
        pointID -= 1
        updatePoints()
        print(lessonID, pointID)
        updateUI(lessonID, pointID)
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

        //隐藏控制栏
        controllStackView.isHidden = true
        infoViewConstraintsButton.constant -= controllStackView.frame.height
        
    }
    
    func updateUI(_ lessionID: Int, _ pointID: Int){
        // 根据lessionID和pointID查找数据
        let index = currentLesson.points.firstIndex(where: { $0.id == pointID })!
        pointNStep.text = "STEP " + String(index+1) + "/" + String(pointsCount)
        pointName.text = currentPoint.name
        pointDetail.text = currentPoint.detail
        
        imgForBasic.image = UIImage(named: currentPoint.imageNameForBasic + ".jpg")
        imgForBasic.contentMode = .scaleAspectFill
        
        // point为1时隐藏返回按钮
        if ((pointID - 2000) == 1) {
            controllBack.isHidden = true
        }else {
            controllBack.isHidden = false
        }
        
        if ((index+1) == pointsCount) {
            controllNext.isHidden = true
        }else {
            controllNext.isHidden = false
        }
        
        // isWithAR时展示AR按钮
        if currentPoint.isWithAR {
            buttonAR.isHidden = false
        } else {
            buttonAR.isHidden = true
        }
        
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
