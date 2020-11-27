//
//  TypePageViewContorller.swift
//  ARNY
//
//  Created by Igloo on 2020/11/23.
//

import UIKit

class TypePageViewContorller: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {
    
    
    var category:String = "Tech"
    
    var images :[String] = [""]
    var lessonNames : [String] = [""]

    @IBOutlet weak var catNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        catNameLabel.text = category
        
        images.removeAll()
        lessonNames.removeAll()
        
        for lesson in lessonData {
            if (lesson.category == category) {
                images.append(lesson.imageName)
                lessonNames.append(lesson.name)
            }
        }
        
    }
    
    // MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "lessonCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        let imageView = cell.viewWithTag(1) as! UIImageView
        let imageName = images[(indexPath as NSIndexPath).row]
        imageView.image = UIImage(named: imageName)
        imageView.contentMode = .scaleAspectFill
        
        let lessonCatLabel = cell.viewWithTag(2) as! UILabel
        lessonCatLabel.text = category
        
        let lessonNameLabel = cell.viewWithTag(3) as! UILabel
        lessonNameLabel.text = lessonNames[(indexPath as NSIndexPath).row]
        
        return cell
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
