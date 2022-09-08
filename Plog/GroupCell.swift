//그룹 목록을 위한 View

import SwiftUI

struct GroupCell: View {
    var group: Groups
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(group.place)
                .font(.body)
                .lineLimit(1)
            
            Text(group.cycle+" "+ConvertDayList(dayArray: group.days).convertDay())
                .font(.caption)
                .padding(.top, 1.0)
            
            HStack {
                Text(String(group.startTime)+" ~ "+String(group.endTime))
                    .font(.caption)
                
                Spacer()
                
                if(group.capacity == 21) {
                    Text(String(group.member.count)+" / 제한 없음")
                        .font(.caption)
                        .foregroundColor((group.member.count == group.capacity) ? .red : .black)
                } else {
                    Text(String(group.member.count)+" / "+String(group.capacity))
                        .font(.caption)
                        .foregroundColor((group.member.count == group.capacity) ? .red : .black)
                }
            }
        }
        .padding(10)
    }
}

struct GroupCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupCell(group: Groups(id: UUID().uuidString, place: "장소 정보", cycle: "주기 정보", days: [true, true, true, true, true, true, true], startTime: "시작 시간", endTime: "종료 시간", capacity: 5, member: [GroupMember(id: 0, name: "멤버 정보", trashList: [false, false,false,false,true])], trashList: [true, true, true, true, false], comment: "그룹 설명"))
    }
}
