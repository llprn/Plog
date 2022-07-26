//

import UIKit

class DiscussionPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate{
    
    //상단 네비게이션에서 창 닫기
    @IBAction func dismissVIew(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //글 내용
    @IBOutlet weak var postView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    
    //댓글 목록
    @IBOutlet weak var commentTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Post.dummyPostList[0].comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)

        let target = Post.dummyPostList[0].comment[indexPath.row]
        cell.textLabel?.text = target.dUserName
        cell.detailTextLabel?.text = target.dcomment

        return cell
    }
    
    //하단 툴바 댓글 입력창
    @IBOutlet weak var commentTextView: UITextField!
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        if range.location == 0 && range.length != 0{
            self.addButton.isEnabled = false
        } else {
            self.addButton.isEnabled = true
        }
        
        return true
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    //하단 툴바의 버튼으로 댓글 작성하기
    @IBAction func addComment(_ sender: Any) {
        let comment = commentTextView.text
        
        let newComment = DComment(dUserName: "작성자", dcomment: comment ?? "")
        Post.dummyPostList[0].comment.append(newComment)
        
        addButton.isEnabled = false
        commentTextView.resignFirstResponder()
        commentTextView.text = ""
        
        self.commentTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = Post.dummyPostList[0].title
        userLabel.text = Post.dummyPostList[0].userName
        postImage.image = UIImage(named: Post.dummyPostList[0].contentImage)
        contentLabel.text = Post.dummyPostList[0].content
        
        commentTextView.text = ""
        commentTextView.delegate = self
        addButton.isEnabled = false
    }
}
