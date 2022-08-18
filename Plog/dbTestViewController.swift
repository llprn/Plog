//
//  dbTestViewController.swift
//  Plog


import UIKit
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class dbTestViewController: UIViewController {
    var documentIDString: String!
    
    let db = Firestore.firestore()
    var uuid: String!
    

    @IBOutlet var routeImage: UIImageView!
    @IBOutlet var ploggingTime: UILabel!
    @IBOutlet var ploggingDist: UILabel!
    @IBOutlet var routeText: UILabel!
    
    @IBOutlet var beforePlogging: UIImageView!
    @IBOutlet var afterPlogging: UIImageView!
    
    @IBOutlet var trashAmount: UILabel!
    @IBOutlet var theMostTrash: UILabel!
    @IBOutlet var joggingReview: UILabel!
    
    @IBOutlet var currentDate: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        db.collection("review").document(uuid!).getDocument { [self] snapshot, error in
            guard let data = snapshot?.data(), error == nil else {
                return
            }
            
            self.ploggingTime.text = data["ploggingTime"] as? String
            self.ploggingDist.text = data["ploggingDist"] as? String
            self.routeText.text = data["routeText"] as? String
            
            self.trashAmount.text = data["trashAmount"] as? String
            self.theMostTrash.text = data["theMostTrash"] as? String
            self.joggingReview.text = data["joggingReview"] as? String
            self.currentDate.text = data["date"] as? String
            
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



