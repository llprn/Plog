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
                
                Text(String(group.peopleList.count)+" / "+String(group.capacity))
                    .font(.caption)
                    .foregroundColor((group.peopleList.count == group.capacity) ? .red : .black)
            }
        }
        .padding(10)
    }
}

struct GroupCell_Previews: PreviewProvider {
    static var previews: some View {
        GroupCell(group: Groups(place: "장소 정보", cycle: "주기 정보", days: [true, true, true, true, true, true, true], startTime: "시작 시간", endTime: "종료 시간", capacity: 5, peopleList: [GroupMember(name: "멤버 정보", trash: [false, false,false,false,true])], trashList: [true, true, true, true, false], comment: "그룹 설명"))
    }
}
