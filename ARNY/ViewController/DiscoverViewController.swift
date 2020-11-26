//
//  DiscoverViewController.swift
//  ARNY
//
//  Created by Igloo on 11/22/20.
//

import UIKit

var categorys = ["Tech", "Health","Nature","Other"]

var images0 :[String] = [""]
var lessonNames0 : [String] = [""]

var images1 :[String] = [""]
var lessonNames1 : [String] = [""]

var images2 :[String] = [""]
var lessonNames2 : [String] = [""]

var imagesD :[String] = [""]
var lessonNamesD : [String] = [""]



class DiscoverViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    @IBOutlet weak var stackView1: UIStackView!
    
    @IBOutlet weak var stackView2: UIStackView!
    
    @IBOutlet weak var stackView3: UIStackView!
    
    @IBOutlet weak var stackView4: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        (stackView1.viewWithTag(11) as! UILabel).text = categorys[0]
        (stackView2.viewWithTag(11) as! UILabel).text = categorys[1]
        (stackView3.viewWithTag(11) as! UILabel).text = categorys[2]
        (stackView4.viewWithTag(11) as! UILabel).text = categorys[3]
        
        images0.removeAll()
        images1.removeAll()
        images2.removeAll()
        imagesD.removeAll()
        lessonNames0.removeAll()
        lessonNames1.removeAll()
        lessonNames2.removeAll()
        lessonNamesD.removeAll()
        
        for lesson in lessonData {
            switch lesson.category {
            case categorys[0]:
                do {
                    images0.append(lesson.imageName)
                    lessonNames0.append(lesson.name)
                }
            case categorys[1]:
                do {
                    images1.append(lesson.imageName)
                    lessonNames1.append(lesson.name)
                }
            case categorys[2]:
                do {
                    images2.append(lesson.imageName)
                    lessonNames2.append(lesson.name)
                }
            default:
                do {
                    imagesD.append(lesson.imageName)
                    lessonNamesD.append(lesson.name)
                }
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case 100:
            return images0.count
        case 200:
            return images1.count
        case 300:
            return images2.count
        default:
            return imagesD.count
        }
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        case 100:
            let cellIdentifier = "lessonCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            let imageName = images0[(indexPath as NSIndexPath).row]
            imageView.image = UIImage(named: imageName + ".jpg")
            imageView.contentMode = .scaleAspectFill
            
            let lessonCatLabel = cell.viewWithTag(2) as! UILabel
            lessonCatLabel.text = categorys[0]
            
            let lessonNameLabel = cell.viewWithTag(3) as! UILabel
            lessonNameLabel.text = lessonNames0[(indexPath as NSIndexPath).row]
            
            return cell
        case 200:
            let cellIdentifier = "lessonCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            let imageName = images1[(indexPath as NSIndexPath).row]
            imageView.image = UIImage(named: imageName + ".jpg")
            imageView.contentMode = .scaleAspectFill
            
            let lessonCatLabel = cell.viewWithTag(2) as! UILabel
            lessonCatLabel.text = categorys[1]
            
            let lessonNameLabel = cell.viewWithTag(3) as! UILabel
            lessonNameLabel.text = lessonNames1[(indexPath as NSIndexPath).row]
            
            return cell
        case 300:
            let cellIdentifier = "lessonCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            let imageName = images2[(indexPath as NSIndexPath).row]
            imageView.image = UIImage(named: imageName + ".jpg")
            imageView.contentMode = .scaleAspectFill
            
            let lessonCatLabel = cell.viewWithTag(2) as! UILabel
            lessonCatLabel.text = categorys[2]
            
            let lessonNameLabel = cell.viewWithTag(3) as! UILabel
            lessonNameLabel.text = lessonNames2[(indexPath as NSIndexPath).row]
            
            return cell
        default:
            let cellIdentifier = "lessonCell"
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            let imageView = cell.viewWithTag(1) as! UIImageView
            let imageName = imagesD[(indexPath as NSIndexPath).row]
            imageView.image = UIImage(named: imageName + ".jpg")
            imageView.contentMode = .scaleAspectFill
            
            let lessonCatLabel = cell.viewWithTag(2) as! UILabel
            lessonCatLabel.text = categorys[3]
            
            let lessonNameLabel = cell.viewWithTag(3) as! UILabel
            lessonNameLabel.text = lessonNamesD[(indexPath as NSIndexPath).row]
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        print("click", indexPath)
        let lessonID = lessonData[lessonData.firstIndex(where: {$0.name == (cell?.viewWithTag(3)as! UILabel).text })!].id
        
        
        // Navigation模式生效
        //传递lessonID
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "lessonView") as! LessonViewController
        newVC.lessonID = lessonID
        print("启动Lesson页面,lessonID:", lessonID)
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    
    
    @IBAction func buttonBack(_ sender: Any) {
        //self.dismiss(animated: true, completion:nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func buttonTypePage(_ sender: Any) {
        print("跳转TypePage")
        // performSegue(withIdentifier: "showTypePage", sender: self)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "typeView")
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func more0(_ sender: Any) {// Navigation模式生效
        //传递lessonID
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "typeView") as! TypePageViewContorller
        newVC.category = categorys[0]
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func more1(_ sender: Any) {// Navigation模式生效
        //传递lessonID
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "typeView") as! TypePageViewContorller
        newVC.category = categorys[1]
        self.navigationController?.pushViewController(newVC, animated: true)
    }
    
    @IBAction func more2(_ sender: Any) {// Navigation模式生效
        //传递lessonID
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "typeView") as! TypePageViewContorller
        newVC.category = categorys[2]
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
