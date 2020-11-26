//
//  LessonViewController.swift
//  ARNY
//
//  Created by Igloo on 2020/11/23.
//

import UIKit

class LessonViewController: UIViewController {
    
    // 课程信息栏
    @IBOutlet weak var lessonCat: UILabel!
    @IBOutlet weak var lessonName: UILabel!
    @IBOutlet weak var lessonImg: UIImageView!
    @IBOutlet weak var lessonIntro: UITextView!
    
    @IBOutlet weak var buttonAR: UIButton!
    
    // 课程信息
    var lessonID:Int = 999
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initLP()
        // Do any additional setup after loading the view.
        updateUI()
    }
    
    func initLP(){
        // 课程信息初始化
        if lessonID != 999 {
            print("从上级页面接收lessonID=", lessonID)
        } else {
            lessonID = 1000
            print("未从上级页面接收到lessonID，设置为默认值1000")
        }
        
        print("当前课程位于",lessonID)
    }
    
    
    // MARK: - UI
    
    func updateUI(){
        // 课程信息初始化
        let currentLesson = lessonData[lessonData.firstIndex(where: {$0.id == lessonID})!]
        
        lessonCat.text = currentLesson.category
        lessonName.text = currentLesson.name
        lessonIntro.text = currentLesson.intro
        lessonImg.image = UIImage(named: currentLesson.imageName + ".jpg")
        lessonImg.contentMode = .scaleAspectFill
        
        // isWithAR时展示AR按钮
        if currentLesson.isWithAR {
            buttonAR.isHidden = false
        } else {
            buttonAR.isHidden = true
        }
        
    }
    
    // MARK: - UI Interaction
    @IBAction func buttonBack(_ sender: Any) {
        //self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonBasic(_ sender: Any) {
        print("启动Basic Mode")
        // Navigation模式生效
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //var newVC: UIViewController!
        //newVC = (storyboard.instantiateViewController(withIdentifier: "basicView") )
        //self.navigationController?.pushViewController(newVC, animated: true)
        //传递lessonID
        let newVC = storyboard.instantiateViewController(withIdentifier: "basicView") as! BasicViewController
        newVC.lessonID = lessonID
        self.navigationController?.pushViewController(newVC, animated: true)
       
    }
    
    
    @IBAction func buttonAR(_ sender: Any) {
        print("启动AR Mode")
        
        // Navigation模式生效
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = (storyboard.instantiateViewController(withIdentifier: "arMode") ) as! ARViewController
        newVC.lessonID = lessonID
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
