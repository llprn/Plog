
//  CourseBoardViewController.swift
//  Plog

import UIKit

class CourseBoardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return boardTitle.count
        
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
}
class CustomCell: UITableViewCell{
    @IBOutlet weak var titleLabel:UILabel!
}


