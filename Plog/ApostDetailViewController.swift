
//  ApostDetailViewController.swift
//  Plog


import UIKit
import Firebase
import FirebaseFirestore


class ApostDetailViewController: UIViewController {
    let db = Firestore.firestore()

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
        dismiss(animated: true, completion: nil) //컨트롤러 닫기
 //       self.navigationController?.popViewController(animated: true)
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}



