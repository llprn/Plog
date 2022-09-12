//그룹 상세 페이지

import SwiftUI
import FirebaseFirestore

struct GroupDetailView: View {
    var group: Groups
    var userId: Int64
    
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button{
                    if (group.member.count == 1) {
                        //탈퇴: 그룹에서 사용자 정보 삭제
                        Firestore.firestore().collection("group").document(group.id).collection("member").document(String(userId)).delete()
                        //모든 멤버 탈퇴 시 그룹 삭제
                        Firestore.firestore().collection("group").document(group.id).delete()
                    } else {
                        //탈퇴: 그룹에서 사용자 정보 삭제
                        Firestore.firestore().collection("group").document(group.id).collection("member").document(String(userId)).delete()
                    }
                    showingAlert = true
                } label: {
                    Text("탈퇴")
                        .padding(5)
                }
                .foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.green, lineWidth: 2))
                .padding()
                .alert("그룹에서 탈퇴하였습니다.", isPresented: $showingAlert) {
                    Button("확인") { dismiss() }
                }
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
                            if group.capacity == 21 {
                                Text(String(group.member.count)+"/제한 없음")
                                    .padding(.top)
                            } else {
                                Text(String(group.member.count)+"/"+String(group.capacity))
                                    .padding(.top)
                                    .foregroundColor((group.member.count == group.capacity) ? .red : .black)
                            }
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
                                Text(ConvertTrashList(trashArray: myTrashList.trashList).convertTrash())
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
        group.member.forEach {
            if (peopleListString != "") {
                peopleListString += ", "
            }
            peopleListString += $0.name
        }
        return peopleListString
    }
    
    var myTrashList: GroupMember {
        var member = group.member.first{$0.id == userId}
        if (member == nil) {
            member = GroupMember(id: 0, name: "없음", trashList: [false,false,false,false,false])
        }
        return member!
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        GroupDetailView(group: Groups(id: UUID().uuidString, place: "장소 정보", cycle: "주기 정보", days: [true, true, true, true, true, true, true], startTime: "시작 시간", endTime: "종료 시간", capacity: 5, member: [GroupMember(id: 1, name: "멤버 정보", trashList: [true, true, true, false, false])], trashList: [true, true, true, true, true], comment: "그룹 설명"), userId: 0)
    }
}
