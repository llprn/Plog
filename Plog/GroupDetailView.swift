//그룹 상세 페이지

import SwiftUI

struct GroupDetailView: View {
    var group: Groups
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button{
                    group.peopleList.removeAll{ String($0.name) == "개설자" }
                    if (group.peopleList.isEmpty) {
                        Groups.dummyGroupList.removeAll { $0.id == group.id }
                    }
                    dismiss()
                } label: {
                    Text("탈퇴")
                        .padding(5)
                }
                .foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.green, lineWidth: 2))
                .padding()
            }
            ScrollView {
                VStack(alignment: .leading) {
                    Text(group.place)
                        .padding(.leading)
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    Divider()
                    
                    HStack {
                        VStack(alignment: .leading){
                            Text(group.cycle+" "+ConvertDayList(dayArray: group.days).convertDay())
                            Text(group.startTime+"~"+group.endTime)
                        }
                        .padding()
                        Spacer()
                    }
                    
                    VStack(alignment: .leading) {
                        Divider()
                        HStack {
                            Text("참여인원")
                                .font(.headline)
                                .padding([.top, .leading, .trailing])
                            Text(String(group.peopleList.count)+"/"+String(group.capacity))
                                .padding(.top)
                            Spacer()
                        }
                        
                        GroupBox(label: Text("")) {
                            HStack {
                                Text(people)
                                    .padding([.leading, .bottom, .trailing])
                                .multilineTextAlignment(.leading)
                                Spacer()
                            }
                        }
                        .padding([.leading, .bottom, .trailing])
                        
                        Text("나의 수거 항목")
                            .padding(.leading)
                            .font(.headline)
                        GroupBox(label: Text("")) {
                            HStack {
                                Text(ConvertTrashList(trashArray: myTrashList.trash).convertTrash())
                                    .multilineTextAlignment(.leading)
                                .padding([.leading, .bottom, .trailing])
                                Spacer()
                            }
                        }
                        .padding([.leading, .bottom, .trailing])
                        
                        Text("그룹 설명")
                            .padding(.leading)
                            .font(.headline)
                        GroupBox(label: Text("")) {
                            HStack {
                                Text(group.comment)
                                    .multilineTextAlignment(.leading)
                                .padding([.leading, .bottom, .trailing])
                                Spacer()
                            }
                        }
                        .padding([.leading, .bottom, .trailing])
                    }
                }
            }
            Button{
                dismiss()
            } label: {
                Text("확인")
            }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                .frame(width: 60.0, height: 40.0)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                .padding()
        }.refreshable{}
    }
    
    var people: String {
        var peopleListString = ""
        group.peopleList.forEach {
            if (peopleListString != "") {
                peopleListString += ", "
            }
            peopleListString += $0.name
        }
        return peopleListString
    }
    
    var myTrashList: GroupMember {
        var member = group.peopleList.first{$0.name == "개설자"}
        if (member == nil) {
            member = GroupMember(name: "없음", trash: [false,false,false,false,false])
        }
        return member!
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: Groups(place: "장소 정보", cycle: "주기 정보", days: [true, true, true, true, true, true, true], startTime: "시작 시간", endTime: "종료 시간", capacity: 5, peopleList: [GroupMember(name: "멤버 정보", trash: [true, true, true, false, false])], trashList: [true, true, true, true, true], comment: "그룹 설명"))
    }
}
