//
//  BpostRegisterViewController.swift
//  Plog
//
//  Created by 숙명 on 2022/07/24.
//

import UIKit

class BpostRegisterViewController: UIViewController {


    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var contentTF: UITextField!
    
    @IBOutlet weak var test: UILabel!
    
    @IBAction func registerBnt(_ sender: UIButton) {
      //  result.text=titleTF.text!+"dd"
        test.text=titleTF.text

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
