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
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置圆角
        lessonCard1.layer.cornerRadius = 20
        lessonCard2.layer.cornerRadius = 20
        lessonCard3.layer.cornerRadius = 20
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 配置手势
        let tapToLesson = UITapGestureRecognizer(target: self, action: #selector(startLessonView))
        tapToLesson.numberOfTapsRequired = 1
        lessonCard1.addGestureRecognizer(tapToLesson)
        lessonCard2.addGestureRecognizer(tapToLesson)
        lessonCard3.addGestureRecognizer(tapToLesson)
    }
    
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
        var newVC: UIViewController!
        newVC = (storyboard.instantiateViewController(withIdentifier: "basicView") )
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    
    @objc func startLessonView(){
        print("启动Lesson View")
        // Navigation模式生效
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var newVC: UIViewController!
        newVC = (storyboard.instantiateViewController(withIdentifier: "lessonView") )
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
