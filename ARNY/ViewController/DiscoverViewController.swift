//
//  DiscoverViewController.swift
//  ARNY
//
//  Created by Igloo on 11/22/20.
//

import UIKit

class DiscoverViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func buttonBack(_ sender: Any) {
        self.dismiss(animated: true, completion:nil)
        
    }
    
    @IBAction func buttonTypePage(_ sender: Any) {
        print("跳转TypePage")
        performSegue(withIdentifier: "showTypePage", sender: self)
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
