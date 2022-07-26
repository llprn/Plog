//

import Foundation

class GroupMember {
    var id: UUID
    var name: String
    var trash: Array<Bool>
    
    init(name: String, trash: Array<Bool>){
        id = UUID()
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
               capacity: 5, peopleList: [GroupMember(name: "닉네임1", trash: [false,false,true,true,true]), GroupMember(name: "닉네임2", trash: [true,false,false,false,false])],
               trashList: [true, true, false, false, false], comment: "7월 25일부터 활동 시작합니다. 학교 정문 앞에서 만나요"),
        Groups(place: "효창공원",
               cycle: "격주", days: [true, false, false, false, false, false, false],
               startTime: "17:30", endTime: "18:30",
               capacity: 4, peopleList: [GroupMember(name: "개설자", trash: [true,false,false,false,false]), GroupMember(name: "닉네임3", trash: [false,true,false,false,true]), GroupMember(name: "닉네임4", trash: [false, false, true, true, false])],
               trashList: [false, true, true, true, true], comment: "역 앞에서 시작합니다. 각자 쓰레기 종류 2개씩 선택해주세요"),
        Groups(place: "공덕역",
               cycle: "매달", days: [false, false, true, false, true, false, false],
               startTime: "15:00", endTime: "16:30",
               capacity: 3, peopleList: [GroupMember(name: "닉네임5", trash: [true,false,false,false,false]), GroupMember(name: "닉네임6", trash: [false,true,false,false,true]), GroupMember(name: "닉네임7", trash: [false, false, true, true, false])],
               trashList: [false, true, true, true, true], comment: "각자 활동 후 역 앞에서 만납시다")
    ]
}
