//그룹 정보

import Foundation

class DComment {
    var dUserName: String
    var dcomment: String
    
    init(dUserName: String, dcomment: String) {
        self.dUserName = dUserName
        self.dcomment = dcomment
    }
}

class Post {
    var title: String
    var userName: String
    var contentImage: String
    var content: String
    var comment: Array<DComment>
    
    init(title: String, userName: String, contentImage: String, content: String, comment: Array<DComment>) {
        self.title = title
        self.userName = userName
        self.contentImage = contentImage
        self.content = content
        self.comment = comment
    }
    
    static var dummyPostList = [
        Post(title: "숙명여자대학교", userName: "작성자1", contentImage: "", content: "게시글 내용\n내용내용", comment: [DComment(dUserName: "작성자2", dcomment: "댓글1")])
    ]
}
