//그룹 데이터

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

//그룹 회원 구조: 아이디, 닉네임, 분리수거목록
struct GroupMember: Identifiable {
    var id: Int64
    var name: String
    var trashList: Array<Bool>
}

//그룹 구조: 아이디, 장소, 주기, 요일, 시작시간, 종료시간, 정원, 회원, 분리수거목록, 설명
struct Groups: Identifiable {
    var id: String
    var place: String
    var cycle: String
    var days: Array<Bool>
    var startTime: String
    var endTime: String
    var capacity: Int
    var member: Array<GroupMember>
    var trashList: Array<Bool>
    var comment: String
}

class GroupViewModel: ObservableObject {
    private var db = Firestore.firestore()
    var groups = [Groups]()
    
    init () {
        self.fetchGroupData()
    }
    
    //Read
    func fetchGroupData() {
        db.collection("group").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.groups = documents.map { (queryDocumentSnapshot) -> Groups in
                let data = queryDocumentSnapshot.data()
                
                //필드 값 불러오기
                let id = queryDocumentSnapshot.documentID
                let place = data["place"] as? String ?? ""
                let cycle = data["cycle"] as? String ?? ""
                let days = data["days"] as? Array ?? [false, false, false, false, false, false, false]
                let startTime = data["startTime"] as? String ?? ""
                let endTime = data["endTime"] as? String ?? ""
                let capacity = data["capacity"] as? Int ?? 0
                let trashList = data["trashList"] as? Array ?? [false, false, false, false, false]
                let comment = data["comment"] as? String ?? ""
                
                //하위 컬렉션 값 불러오기
                //return이 더 먼저 되는 현상 때문에 member는 빈 배열으로 전달 후, append함
                let member = [GroupMember]()
                self.db.collection("group").document(id).collection("member").addSnapshotListener { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let gIndex = self.groups.firstIndex(where: {$0.id == id})
                        if gIndex != nil { self.groups[gIndex!].member.removeAll() }
                        for document in querySnapshot!.documents {
                            if gIndex != nil {
                                self.groups[gIndex!].member.append(GroupMember(id: document.data()["id"] as? Int64 ?? 0, name: document.data()["name"] as? String ?? "", trashList: document.data()["trashList"] as? Array ?? [false, false, false, false,false]))
                            }
                        }
                    }
                }

                return Groups(id: id, place: place, cycle: cycle, days: days, startTime: startTime, endTime: endTime, capacity: capacity, member: member, trashList: trashList, comment: comment)
            }
        }
    }
}
