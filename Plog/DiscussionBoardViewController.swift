//
//  DiscussionBoardViewController.swift
//  Plog
//

import UIKit
import FirebaseFirestore
import FirebaseStorage


class DiscussionBoardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let navigationBarAppearance = UINavigationBarAppearance()
   
    @IBAction func backBnt(_ sender: Any) {
        let nextVC = UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "CommunityViewController") as! CommunityViewController
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
//        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBnt(_ sender: Any) {
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DiscussionTite.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCell else{
            return UITableViewCell()
        }
        //db 데이터로 변경
        cell.labelTitle.text=DiscussionTite[indexPath.row]
        return cell
    }
    func tableView(_tableView:UITableView,heightForRowAt indexPath:IndexPath)->CGFloat{
        return 100.0
    }
    //삭제
    let DiscussionTite=["숙대입구","삼각지-녹사평","공덕역","해방촌 오거리"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
        navigationBarAppearance.backgroundColor = .systemGray6
    }
    
    //상세 페이지로 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showDetail", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            let vc = segue.destination as! DiscussionPostViewController
            //문서 아이디 전달: 변경 필요
            vc.receiveId = "qPKLJSL6swUUzdrHGlPC"
        }
        
        
    }
}
class MyCell:UITableViewCell{
    @IBOutlet weak var labelTitle:UILabel!
}
