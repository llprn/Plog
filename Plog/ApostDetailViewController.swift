
//  ApostDetailViewController.swift
//  Plog


import UIKit

class ApostDetailViewController: UIViewController {

 
    @IBOutlet weak var ttleLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var beforeImg: UIImageView!
    @IBOutlet weak var afterImg: UIImageView!
    @IBOutlet weak var volume: UITextView!
    @IBOutlet weak var type: UITextView!
    @IBOutlet weak var review: UITextView!
    
    @IBAction func backBnt(_ sender: Any) {
//        print("hi")
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
    }
    

}



