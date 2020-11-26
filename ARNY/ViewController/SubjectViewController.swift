//
//  SubjectViewController.swift
//  ARNY
//
//  Created by Igloo on 2020/11/23.
//

import UIKit

class SubjectViewController: UIViewController {

    @IBOutlet weak var lessonCard1: UIView!
    @IBOutlet weak var lessonCard2: UIView!
    @IBOutlet weak var lessonCard3: UIView!
    
    @IBOutlet weak var subjectName: UILabel!
    
    // 主题信息
    var subjectID:Int = 999
    var currentSubject:Subject!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置圆角
        lessonCard1.layer.cornerRadius = 20
        lessonCard2.layer.cornerRadius = 20
        lessonCard3.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initSP()
        
        updateUI()

        // Do any additional setup after loading the view.
        // 配置手势
        lessonCard1.addGestureRecognizer(setGestureRecognizer())
        lessonCard2.addGestureRecognizer(setGestureRecognizer())
        lessonCard3.addGestureRecognizer(setGestureRecognizer())
    }
    
    func initSP(){
        // 主题信息初始化
        if subjectID != 999 {
            print("从上级页面接收subjectID=", subjectID)
        } else {
            subjectID = 8001
            print("未从上级页面接收到subjectID，设置为默认值8001")
        }
        
        print("当前主题位于",subjectID)
        
        currentSubject = subjectData[subjectData.firstIndex(where: { $0.id == subjectID })!]
    }
    
    func updateUI(){
        subjectName.text = currentSubject.name
        
        // 这个地方建议以后用ScrollView封装，现在强制三个子课程
        // 卡片1
        var subLessonID = currentSubject.subLessons[0].id
        var subLessonInfo = lessonData[lessonData.firstIndex(where: { $0.id == subLessonID})!]
        (lessonCard1.viewWithTag(10) as! UILabel).text = subLessonInfo.category.uppercased()
        (lessonCard1.viewWithTag(1) as! UILabel).text = subLessonInfo.name
        
        if !subLessonInfo.isWithAR {
            (lessonCard1.viewWithTag(3) as! UIButton).isHidden = true
        }
        (lessonCard1.viewWithTag(4) as! UIImageView).image = UIImage(named: subLessonInfo.imageName + ".jpg")
        (lessonCard1.viewWithTag(4) as! UIImageView).contentMode = .scaleAspectFill
        
        (lessonCard1.viewWithTag(5) as! UITextView).text = subLessonInfo.intro
        
        // 卡片2
        subLessonID = currentSubject.subLessons[1].id
        subLessonInfo = lessonData[lessonData.firstIndex(where: { $0.id == subLessonID})!]
        (lessonCard2.viewWithTag(10) as! UILabel).text = subLessonInfo.category.uppercased()
        (lessonCard2.viewWithTag(1) as! UILabel).text = subLessonInfo.name
        
        if !subLessonInfo.isWithAR {
            (lessonCard2.viewWithTag(3) as! UIButton).isHidden = true
        }
        (lessonCard2.viewWithTag(4) as! UIImageView).image = UIImage(named: subLessonInfo.imageName + ".jpg")
        (lessonCard2.viewWithTag(4) as! UIImageView).contentMode = .scaleAspectFill
        
        (lessonCard2.viewWithTag(5) as! UITextView).text = subLessonInfo.intro
        
        // 卡片3
        subLessonID = currentSubject.subLessons[2].id
        subLessonInfo = lessonData[lessonData.firstIndex(where: { $0.id == subLessonID})!]
        (lessonCard3.viewWithTag(10) as! UILabel).text = subLessonInfo.category.uppercased()
        (lessonCard3.viewWithTag(1) as! UILabel).text = subLessonInfo.name
        
        if !subLessonInfo.isWithAR {
            (lessonCard3.viewWithTag(3) as! UIButton).isHidden = true
        }
        (lessonCard3.viewWithTag(4) as! UIImageView).image = UIImage(named: subLessonInfo.imageName + ".jpg")
        (lessonCard3.viewWithTag(4) as! UIImageView).contentMode = .scaleAspectFill
        
        (lessonCard3.viewWithTag(5) as! UITextView).text = subLessonInfo.intro

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
        var newVC: UIViewController!
        newVC = (storyboard.instantiateViewController(withIdentifier: "arMode") )
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func buttonBasic(_ sender: Any) {
        
        
        print("启动Basic Mode")
        // Navigation模式生效
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = (storyboard.instantiateViewController(withIdentifier: "basicView") ) as! BasicViewController
        
        //傻不拉几的区分方法
        switch (sender as! UIButton).tag {
        case 12:
            newVC.lessonID = currentSubject.subLessons[0].id
        case 22:
            newVC.lessonID = currentSubject.subLessons[1].id
        case 32:
            newVC.lessonID = currentSubject.subLessons[2].id
        default:
            newVC.lessonID = 999
        }
        
        print("跳转基本模式")
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    func setGestureRecognizer() -> UITapGestureRecognizer {

            var Recognizer = UITapGestureRecognizer()

        Recognizer = UITapGestureRecognizer (target: self, action: #selector(startLessonView(gesture:)))
            Recognizer.numberOfTapsRequired = 1
            return Recognizer
        }
    
    @objc func startLessonView(gesture:UITapGestureRecognizer){
        print("启动Lesson View")
        // Navigation模式生效
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = (storyboard.instantiateViewController(withIdentifier: "lessonView") ) as! LessonViewController
        switch gesture.view!.tag {
        case 101:
            newVC.lessonID = currentSubject.subLessons[0].id
        case 102:
            newVC.lessonID = currentSubject.subLessons[1].id
        case 103:
            newVC.lessonID = currentSubject.subLessons[2].id
        default:
            newVC.lessonID = 999
        }
        self.navigationController?.pushViewController(newVC, animated: true)
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
