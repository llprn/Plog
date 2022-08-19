//토론 게시물 상세 페이지

import UIKit
import KakaoSDKUser
import FirebaseFirestore

struct DComment: Codable, Hashable {
    var name: String
    var comment: String
    
    var firestoreData: [String: Any] {
        return [
            "name": name,
            "comment": comment
        ]
    }
}

struct DPost: Codable {
    var title: String
    var name: String
    var image: String
    var content: String
    var comments: Array<DComment>
}

class DiscussionPostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate, UIScrollViewDelegate{
    
    let db: Firestore = Firestore.firestore()
    var receiveId = ""
    var post: DPost = DPost(title: "", name: "", image: "", content: "", comments: [])
    
    func setData(){
        db.collection("discussion").document(self.receiveId).addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            
            do {
                let dPost = try document.data(as: DPost.self)
                
                self.post.title = dPost.title
                self.post.name = dPost.name
                self.post.image = dPost.image
                self.post.content = dPost.content
                self.post.comments = dPost.comments
            }
            catch {
              print(error)
            }
            
            self.CommentTableView.reloadData()
        }
    }
    
    //상단 네비게이션에서 창 닫기
    @IBAction func dismissVIew(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    //글, 댓글
    @IBOutlet weak var CommentTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return post.comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //글
        if indexPath.row < 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! customDPostCell
            
            let target = post
            cell.dTitleLabel?.text = target.title
            cell.dUserLabel?.text = target.name
            
            let url = URL(string: target.image)
            if url == nil {
                cell.dPostImage?.image = UIImage(systemName: "x.square")
            } else {
                do {
                    let data = try Data(contentsOf: url!)
                    let image = UIImage(data: data)!
                    
                    let scale = 350 / image.size.width
                    let height = image.size.height * scale
                    UIGraphicsBeginImageContext(CGSize(width: 350, height: height))
                    image.draw(in: CGRect(x: 0, y: 0, width: 350, height: height))
                    let newImage = UIGraphicsGetImageFromCurrentImageContext()
                    UIGraphicsEndImageContext()
                    
                    cell.dPostImage?.image = newImage
                } catch {
                    //로드 실패 시 x모양 아이콘 띄움
                    cell.dPostImage?.image = UIImage(systemName: "x.square")
                }
            }
            
            cell.dContentLabel?.text = target.content
            
            cell.countIcon?.image = UIImage(systemName: "bubble.right")
            cell.countLabel?.text = String(target.comments.count)
            
            cell.selectionStyle = .none
            
            return cell
        }
        
        //댓글
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! customCommentCell

        let target = post.comments[indexPath.row - 1]
        cell.cUserLabel?.text = target.name
        cell.commentLabel?.text = target.comment
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //하단 툴바
    @IBOutlet weak var toolBar: UIView!
    
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
        
        //카카오계정 아이디 불러옴
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                _ = user
                let nickname = user?.kakaoAccount?.profile?.nickname ?? ""
                let newComment = DComment(name: String(nickname), comment: comment ?? "")
                self.db.collection("discussion").document(self.receiveId).updateData(["comments" : FieldValue.arrayUnion([newComment.firestoreData])])
            }
        }
        
        addButton.isEnabled = false
        commentTextView.resignFirstResponder()
        commentTextView.text = ""
        
        self.CommentTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(DiscussionPostViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(DiscussionPostViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        commentTextView.text = ""
        commentTextView.delegate = self
        
        commentTextView.autocapitalizationType = .none
        commentTextView.layer.cornerRadius = 5
        commentTextView.layer.borderWidth = 1
        commentTextView.layer.borderColor = UIColor.gray.cgColor
        
        //CommentTableView.keyboardDismissMode = .onDrag
        addButton.isEnabled = false
    }
    
    @IBOutlet weak var toolBarBottomMargin: NSLayoutConstraint!
    
    @objc func keyboardWillShow(notification: NSNotification) {
        let notiInfo = notification.userInfo!
        // 키보드 높이를 가져옴
        let keyboardFrame = notiInfo[UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        let height = keyboardFrame.size.height - self.view.safeAreaInsets.bottom
        toolBarBottomMargin.constant = height + 39

        //애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        let notiInfo = notification.userInfo!
        let animationDuration = notiInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        self.toolBarBottomMargin.constant = 39

        //애니메이션 효과를 키보드 애니메이션 시간과 동일하게
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

//커스텀 셀: 댓글
class customCommentCell: UITableViewCell {

    @IBOutlet weak var cUserLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
//커스텀 셀: 게시글
class customDPostCell: UITableViewCell {
    
    @IBOutlet weak var dTitleLabel: UILabel!
    @IBOutlet weak var dUserLabel: UILabel!
    @IBOutlet weak var dPostImage: UIImageView!
    @IBOutlet weak var dContentLabel: UILabel!
    
    @IBOutlet weak var countIcon: UIImageView!
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
