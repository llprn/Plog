//

import Foundation

class GroupMember {
    var id: Int64
    var name: String
    var trash: Array<Bool>
    
    init(id: Int64, name: String, trash: Array<Bool>){
        self.id = id
        self.name = name
        self.trash = trash
    }
}

class Groups {
    var id: UUID
    var place: String
    //날짜(주기, 요일 시작시간, 종료시간)
    var cycle: String
    var days: Array<Bool>
    var startTime: String
    var endTime: String
    //인원(참여, 정원)
    var capacity: Int
    var peopleList: Array<GroupMember>
    //분리수거 항목
    var trashList: Array<Bool>
    //그룹 설명
    var comment: String
    
    
    init(place: String,
         cycle: String, days: Array<Bool>, startTime: String, endTime: String,
        capacity: Int, peopleList: Array<GroupMember>,
         trashList: Array<Bool> , comment: String){
        id = UUID()
        self.place = place
        self.cycle = cycle
        self.days = days
        self.startTime = startTime
        self.endTime = endTime
        self.capacity = capacity
        self.peopleList = peopleList
        self.trashList = trashList
        self.comment = comment
    }
    
    static var dummyGroupList = [
        Groups(place: "숙명여자대학교",
               cycle: "매주", days: [false, true, false, true, false, false, false],
               startTime: "12:30", endTime: "13:30",
               capacity: 5, peopleList: [GroupMember(id: 0, name: "김눈송", trash: [false,false,true,true,true]), GroupMember(id: 1, name: "이숙명", trash: [true,false,false,false,false])],
               trashList: [true, true, false, false, false], comment: "7월 25일부터 활동 시작합니다. 학교 정문 앞에서 만나요"),
    ]
}
