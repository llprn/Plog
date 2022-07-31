//토론 게시물 상세 페이지

import UIKit

class DiscussionPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate{
    
    var post : Post?
    
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
    @IBOutlet weak var CommentTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Post.dummyPostList[0].comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! customCommentCell

        //이전화면에서 데이터 전달 시 Post.comment[indexPath.row]
        let target = Post.dummyPostList[0].comment[indexPath.row]
        cell.cUserLabel?.text = target.dUserName
        cell.commentLabel?.text = target.dcomment

        return cell
    }
    
    //하단 툴바
    @IBOutlet weak var toolBar: UIToolbar!
    
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
    
    //댓글 글자 수 제한
    func checkMaxLength(textField: UITextField!, maxLength: Int) {
        if (textField.text?.count ?? 0 > maxLength) {
            textField.deleteBackward()
        }
    }
    @IBAction func textDidChanged(_ sender: Any) {
        checkMaxLength(textField: commentTextView, maxLength: 100)
    }
    
    //하단 툴바의 버튼으로 댓글 작성하기
    @IBAction func addComment(_ sender: Any) {
        let comment = commentTextView.text
        
        let newComment = DComment(dUserName: "작성자", dcomment: comment ?? "")
        Post.dummyPostList[0].comment.append(newComment)
        
        addButton.isEnabled = false
        commentTextView.resignFirstResponder()
        commentTextView.text = ""
        
        self.CommentTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DiscussionPostViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DiscussionPostViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //이전 화면에서 데이터 전달 시 Post.title 꼴로 변경
        titleLabel.text = Post.dummyPostList[0].title
        userLabel.text = Post.dummyPostList[0].userName
        postImage.image = UIImage(named: Post.dummyPostList[0].contentImage)
        contentLabel.text = Post.dummyPostList[0].content
        
        commentTextView.text = ""
        commentTextView.delegate = self
        
        CommentTableView.keyboardDismissMode = .onDrag
        addButton.isEnabled = false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
                
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
               return
            }
          
        self.view.frame.origin.y = 0 - keyboardSize.height
    }

    @objc func keyboardWillHide(notification: NSNotification) {
          self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
