
//  ApostDetailViewController.swift
//  Plog


import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class ApostDetailViewController: UIViewController {
    //db
    var documentIDString: String!
    let db = Firestore.firestore()
    var uuid: String = "DDE03054-D606-4D53-BE4E-492A5526020B" //""로 수정하기
 
    @IBOutlet weak var routeImage: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var routeText: UILabel!
    @IBOutlet weak var ploggingTime: UILabel!
    @IBOutlet weak var ploggingDist: UILabel!
    @IBOutlet weak var beforePlogging: UIImageView!
    @IBOutlet weak var afterPlogging: UIImageView!
    
    @IBOutlet weak var trashAmount: UITextView!
    @IBOutlet weak var theMostTrash: UITextView!
    @IBOutlet weak var joggingReview: UITextView!
 
    
    @IBAction func backBnt(_ sender: Any) {
        let nextVC = UIStoryboard(name: "CourseBoard", bundle: nil).instantiateViewController(withIdentifier: "CourseBoardViewController") as! CourseBoardViewController
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
        //dismiss(animated: true, completion: nil) //컨트롤러 닫기
 //       self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        db.collection("review").document(uuid).getDocument { [self] snapshot, error in
        guard let data = snapshot?.data(), error == nil else {
            return
        }
            self.ploggingTime.text = data["ploggingTime"] as? String
            self.ploggingDist.text = data["ploggingDist"] as? String
        self.trashAmount.text = data["trashAmount"] as? String
        self.theMostTrash.text = data["theMostTrash"] as? String
        self.joggingReview.text = data["joggingReview"] as? String
        self.dateLabel.text = data["date"] as? String
            
        let pathURL1 = data["routeImage"] as! String
        let reference1 = Storage.storage().reference().child(pathURL1)
        reference1.getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let _error = error {
                print(_error)
            } else {
                self.routeImage.image = UIImage(data: data!)
            }
        }
            
        let pathURL2 = data["beforePlogging"] as! String
        let reference2 = Storage.storage().reference().child(pathURL2)
        reference2.getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let _error = error {
                print(_error)
            } else {
                self.beforePlogging.image = UIImage(data: data!)
            }
        }
            
        let pathURL3 = data["afterPlogging"] as! String
        let reference3 = Storage.storage().reference().child(pathURL3)
        reference3.getData(maxSize: 15 * 1024 * 1024) { (data, error) in
            if let _error = error {
                print(_error)
            } else {
                self.afterPlogging.image = UIImage(data: data!)
            }
        }
    }
}

}
