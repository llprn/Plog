//토론 게시물 상세 페이지

import UIKit

class DiscussionPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIScrollViewDelegate{
    
    var post : Post?
    
    //상단 네비게이션에서 창 닫기
    @IBAction func dismissVIew(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //글, 댓글
    @IBOutlet weak var CommentTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Post.dummyPostList[0].comment.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //글
        if indexPath.row < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! customDPostCell
            
            let target = Post.dummyPostList[0]
            cell.dTitleLabel?.text = target.title
            cell.dUserLabel?.text = target.userName
            cell.dPostImage?.image = UIImage(systemName: "square")
            cell.dContentLabel?.text = target.content
            
            cell.countIcon?.image = UIImage(systemName: "bubble.right")
            cell.countLabel?.text = String(target.comment.count)
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        //댓글
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! customCommentCell

        //이전화면에서 데이터 전달 시 Post.comment[indexPath.row]
        let target = Post.dummyPostList[0].comment[indexPath.row - 1]
        cell.cUserLabel?.text = target.dUserName
        cell.commentLabel?.text = target.dcomment
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //하단 툴바
    @IBOutlet weak var toolBar: UIToolbar!
    
    //하단 툴바 댓글 입력창
    @IBOutlet weak var commentTextView: UITextView!
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let str = textView.text else { return true }
        let newLength = str.count + text.count - range.length
        return newLength <= 100
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if commentTextView.text.isEmpty{
            commentTextView.text = ""
            addButton.isEnabled = false
        }
        else {
            addButton.isEnabled = true
        }
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
        
        self.CommentTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DiscussionPostViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DiscussionPostViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        commentTextView.text = ""
        commentTextView.delegate = self
        
        commentTextView.autocapitalizationType = .none
        commentTextView.layer.cornerRadius = 5
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        
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
