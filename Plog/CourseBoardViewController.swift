
//  CourseBoardViewController.swift
//  Plog

import UIKit
import FirebaseFirestore
import FirebaseStorage


class CourseBoardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardTitle.count
    }
    
    @IBAction func backBnt(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as? CustomCell else{
            return UITableViewCell()
        }
        
        cell.titleLabel.text = boardTitle[indexPath.row]
        return cell
    }
    
    func tableView(_tableView:UITableView,heightForRowAt indexPath:IndexPath) -> CGFloat{
        return 100.0
    }
    let boardTitle = ["숙대입구-효창공원", "공덕역-애오개역", "삼각지역-숙대입구", "용산역-삼각지역", "효창공원-공덕역"]
    
    override func viewDidLoad() {
         super.viewDidLoad()
         self.view.backgroundColor = .systemGray6
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "cell"{
                let nvc = segue.destination as! ApostDetailViewController
                //추가
                         
            }
        }

}
class CustomCell: UITableViewCell{
    @IBOutlet weak var titleLabel:UILabel!
}


