//
//  MainViewController.swift
//  ARNY
//
//  Created by Igloo on 2020/11/22.
//

import UIKit

class MainViewController: UIViewController {
    
    // 主题栏
    @IBOutlet weak var subjectStackView: UIStackView!
    
    @IBOutlet weak var arMode: UIImageView!
    
    @IBOutlet weak var covid19: UIImageView!
    
    @IBOutlet weak var searchBar: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 隐藏导航栏
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // label.text = "从AR页面传入的值为：\(pageValue)"
        
        // 搜索框调整
        searchBar.layer.cornerRadius = 15
        
        
        // 配置手势
        let tapToAR = UITapGestureRecognizer(target: self, action: #selector(startARMode))
        tapToAR.numberOfTapsRequired = 1
        arMode.addGestureRecognizer(tapToAR)
    
        // 给每张卡片设置跳转
        (subjectStackView.viewWithTag(2)!).addGestureRecognizer(setGestureRecognizer())
        (subjectStackView.viewWithTag(3)!).addGestureRecognizer(setGestureRecognizer())
        (subjectStackView.viewWithTag(4)!).addGestureRecognizer(setGestureRecognizer())
        (subjectStackView.viewWithTag(5)!).addGestureRecognizer(setGestureRecognizer())
        
        // 阴影
//        arMode.layer.applySketchShadow(
//            color: .black,
//            alpha: 0.3,
//            x: 0,
//            y: 20,
//            blur: 30,
//            spread: 0)
    }
    
    @objc func startARMode(){
        print("启动AR Mode")
        
//        // Segue方式跳转
//        performSegue(withIdentifier: "ToARView", sender: self)
        
        // Navigation模式生效
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        var newVC: UIViewController!
        newVC = (storyboard.instantiateViewController(withIdentifier: "arMode") )
        self.navigationController?.pushViewController(newVC, animated: true)
        
    }
    
    
    
    @IBAction func buttonMore(_ sender: Any) {
        print("跳转Discover View")
        // performSegue(withIdentifier: "showTypePage", sender: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "discoverView")
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    // SubjectStackView跳转
    func setGestureRecognizer() -> UITapGestureRecognizer {

            var Recognizer = UITapGestureRecognizer()

            Recognizer = UITapGestureRecognizer (target: self, action: #selector(startSubjectView(gesture:)))
            Recognizer.numberOfTapsRequired = 1
            return Recognizer
        }
    
    @objc func startSubjectView(gesture:UITapGestureRecognizer){
        print("启动Subject View")
        
//        // Segue方式跳转
//        performSegue(withIdentifier: "ToSubjectView", sender: self)
        
        // Navigation模式生效
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = (storyboard.instantiateViewController(withIdentifier: "subjectView") ) as! SubjectViewController
        
        // 此处写了静态的主题ID
        switch gesture.view!.tag {
        case 2:
            newVC.subjectID = 8001
        case 3:
            newVC.subjectID = 8002
        case 4:
            newVC.subjectID = 8003
        case 5:
            newVC.subjectID = 8004
        default:
            newVC.subjectID = 999
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ToARView" {
//            if let destinationVC = segue.destination as? ARViewController {
//                destinationVC.labelText.text = "跳转成功"
//            }
//        }
//    }
    
}

