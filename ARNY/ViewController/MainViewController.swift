//
//  MainViewController.swift
//  ARNY
//
//  Created by Igloo on 2020/11/22.
//

import UIKit

class MainViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    
    // 主题栏
    @IBOutlet weak var subjectStackView: UIStackView!
    
    @IBOutlet weak var arMode: UIImageView!
    
    @IBOutlet weak var covid19: UIImageView!
    
    @IBOutlet weak var searchBar: UIView!
    @IBOutlet weak var headButton: UIButton!
    
    
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
        
        arMode.layer.applySketchShadow(color: UIColor(red: 0.49, green: 0.46, blue: 0.71, alpha: 1.00), alpha: 0.3, x: 0, y: 20, blur: 30, spread: 0)
    
        // 给每张卡片设置跳转
//        (subjectStackView.viewWithTag(2)!).addGestureRecognizer(setGestureRecognizer())
//        (subjectStackView.viewWithTag(3)!).addGestureRecognizer(setGestureRecognizer())
//        (subjectStackView.viewWithTag(4)!).addGestureRecognizer(setGestureRecognizer())
//        (subjectStackView.viewWithTag(5)!).addGestureRecognizer(setGestureRecognizer())
        var t = 2
        while t <= 5{
            (subjectStackView.viewWithTag(t)!).addGestureRecognizer(setGestureRecognizer())
            (subjectStackView.viewWithTag(t)!).layer.applySketchShadow(color: UIColor(red: 0.49, green: 0.46, blue: 0.71, alpha: 1.00), alpha: 0.3, x: 0, y: 20, blur: 30, spread: 0)
            t+=1
        }
        
        // 阴影
        searchBar.layer.applySketchShadow(color: UIColor(red: 0.25, green: 0.46, blue: 0.80, alpha: 1.00), alpha: 0.08, x: 0, y: 10, blur: 20, spread: 0)
        headButton.layer.applySketchShadow(color: UIColor(red: 0.25, green: 0.46, blue: 0.80, alpha: 1.00), alpha: 0.08, x: 0, y: 10, blur: 20, spread: 0)
        
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
    
    // MARK: - Collection View
    let numberOfitems = 10
    var lessons:[Lesson]!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        lessons = Array(lessonData.shuffled().prefix(upTo: numberOfitems))
        
        return numberOfitems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "lessonCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let imageName = lessons![(indexPath as NSIndexPath).row].imageName
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        
        let lessonCatLabel = cell.viewWithTag(2) as! UILabel
        lessonCatLabel.text = lessons![(indexPath as NSIndexPath).row].category
        
        let lessonNameLabel = cell.viewWithTag(3) as! UILabel
        lessonNameLabel.text = lessons![(indexPath as NSIndexPath).row].name
        
        if (lessons![(indexPath as NSIndexPath).row].isNew) {
            (cell.viewWithTag(4) as! UIImageView).isHidden = false
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        
        let lessonID = lessonData[lessonData.firstIndex(where: {$0.name == (cell?.viewWithTag(3)as! UILabel).text })!].id
        
        
        // Navigation模式生效
        //传递lessonID
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "lessonView") as! LessonViewController
        newVC.lessonID = lessonID
        print("启动Lesson页面,lessonID:", lessonID)
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

