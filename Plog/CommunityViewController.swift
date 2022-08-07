//
//  CommunityViewController.swift
//  Plog
//
//  Created by 숙명 on 2022/07/24.
//

import UIKit

class CommunityViewController: UIViewController {

  
    @IBOutlet weak var courseBnt: UIButton!
    @IBAction func courseBnt(_ sender: UIButton) {
    
        
        
      /*  guard let nextVC =
                self.storyboard?.instantiateViewController(identifier: "CourseBoardViewController") as? CourseBoardViewController else { return }
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)*/
        print("course review")
        
    }
    
    @IBOutlet weak var discussionBnt: UIButton!
    @IBAction func discussionBnt(_ sender: Any) {
     /*   guard let nextVC =
                self.storyboard?.instantiateViewController(identifier: "DiscussionBoardViewController") as? DiscussionBoardViewController else { return }
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)*/
       print("discussion")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.courseBnt.layer.cornerRadius=20
        self.discussionBnt.layer.cornerRadius=20

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
