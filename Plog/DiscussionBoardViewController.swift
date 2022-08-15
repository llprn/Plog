//
//  DiscussionBoardViewController.swift
//  Plog
//

import UIKit

class DiscussionBoardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DiscussionTite.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MyCell else{
            return UITableViewCell()
        }
        cell.labelTitle.text=DiscussionTite[indexPath.row]
        return cell
    }
    func tableView(_tableView:UITableView,heightForRowAt indexPath:IndexPath)->CGFloat{
        return 100.0
    }
    let DiscussionTite=["숙대입구","삼각지-녹사평","공덕역","해방촌 오거리"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemGray6
     
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
