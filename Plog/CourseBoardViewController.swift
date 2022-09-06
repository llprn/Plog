//  CourseBoardViewController.swift
//  Plog

import UIKit
import FirebaseFirestore
import FirebaseStorage

class CourseBoardViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    struct rBoard {
        var rTitle: String
        var rId: String
    }
    var boardTitle = [rBoard]()
    @IBOutlet weak var reviewTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
               return boardTitle.count
    }

    @IBAction func backBnt(_ sender: Any) {
    /*    let nextVC = UIStoryboard(name: "Community", bundle: nil).instantiateViewController(withIdentifier: "CommunityViewController") as! CommunityViewController
                nextVC.modalTransitionStyle = .coverVertical
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil)*/
        dismiss(animated: true, completion: nil)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath) as? CustomCell else{
            return UITableViewCell()
        }
        let board = boardTitle[indexPath.row]
        cell.titleLabel.text = board.rTitle as? String

        return cell
    }

    func tableView(_tableView:UITableView,heightForRowAt indexPath:IndexPath) -> CGFloat{
        return 100.0
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setRData()

        self.view.backgroundColor = .systemGray6

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "cell", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {

//            if segue.identifier == "cell"{
                let nextVC = segue.destination as! ApostDetailViewController
                nextVC.modalPresentationStyle = .fullScreen
            }
        }

    func setRData(){
        let db = Firestore.firestore()
        db.collection("review").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print(err)
            } else {
                for document in querySnapshot!.documents {
                    self.boardTitle.append(rBoard(rTitle: document.data()["routeText"] as? String ?? "", rId: document.documentID))
                    print(document.data()["routeText"] ?? "ajdla")
                }
                self.reviewTableView.reloadData()
            }
        }
    }
}

class CustomCell: UITableViewCell{
    var uuid:String = ""
    var documentIDString: String!
 //   var board = ""
    @IBOutlet weak var titleLabel:UILabel!
}
