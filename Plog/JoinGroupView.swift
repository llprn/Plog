//그룹 참여 페이지

import SwiftUI
import KakaoSDKUser
import FirebaseFirestore

struct JoinGroupView: View {
    var group: Groups
    var userId: Int64
    @Environment(\.dismiss) var dismiss
    
    //분리수거 목록
    @State var cans = false
    @State var papers = false
    @State var bags = false
    @State var plastics = false
    @State var etcs = false
    
    @State private var showingAlert = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(group.place)
                        .padding()
                        .font(.title)
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
                            Text(String(group.member.count)+"/"+String(group.capacity))
                                .padding([.top, .leading])
                                .foregroundColor((group.member.count == group.capacity) ? .red : .black)
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
                        
                        Text("분리수거 항목")
                            .font(.headline)
                            .padding(.leading)
                        GroupBox(label: Text("")) {
                            Text("수거할 항목을 선택해주세요.")
                                .font(.caption)
                                .padding(.horizontal)
                            HStack {
                                if group.trashList[0] == true {
                                    Button (action: {
                                        self.cans.toggle()
                                    }) {
                                        Image(systemName: cans ? "checkmark.square.fill" : "square")
                                            .font(.caption)
                                        Text("캔")
                                            .frame(width: 25.0)
                                    }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                }
                                if group.trashList[1] == true {
                                    Button (action: {
                                        self.papers.toggle()
                                    }) {
                                        Image(systemName: papers ? "checkmark.square.fill" : "square")
                                            .font(.caption)
                                        Text("종이")
                                            .frame(width: 30.0)
                                    }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                }
                                if group.trashList[2] == true {
                                    Button (action: {
                                        self.bags.toggle()
                                    }) {
                                        Image(systemName: bags ? "checkmark.square.fill" : "square")
                                            .font(.caption)
                                        Text("비닐")
                                            .frame(width: 30.0)
                                    }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                }
                                if group.trashList[3] == true {
                                    Button (action: {
                                        self.plastics.toggle()
                                    }) {
                                        Image(systemName: plastics ? "checkmark.square.fill" : "square")
                                            .font(.caption)
                                        Text("플라스틱")
                                            .frame(width: 60.0)
                                    }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                }
                                if group.trashList[4] == true {
                                    Button (action: {
                                        self.etcs.toggle()
                                    }) {
                                        Image(systemName: etcs ? "checkmark.square.fill" : "square")
                                            .font(.caption)
                                        Text("일반")
                                            .frame(width: 30.0)
                                    }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                }
                            }
                            .padding(.vertical, 10.0)
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
            
            HStack {
                Spacer()
                
                Button{
                    if(group.capacity == group.member.count){
                        showingAlert = true
                    } else {
                        //카카오계정 아이디 불러옴
                        UserApi.shared.me() {(user, error) in
                            if let error = error {
                                print(error)
                            }
                            else {
                                _ = user
                                let nickname = user?.kakaoAccount?.profile?.nickname
                                Firestore.firestore().collection("group").document(group.id).collection("member").document(String(userId)).setData(["id" : userId, "name" : String(nickname ?? "닉네임"), "trashList" : [cans, papers, bags, plastics, etcs]])
                                dismiss()
                            }
                        }
                    }
                } label: {
                    Text("참여")
                }.disabled(disableJ)
                .foregroundColor(disableJ ? .gray : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                .frame(width: 60.0, height: 40.0)
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(disableJ ? .gray : .black, lineWidth: 2))
                .alert("인원 초과", isPresented: $showingAlert) {
                    Button("확인") {}
                } message: {
                    Text("그룹 정원이 초과되어 참여하실 수 없습니다.")
                }

                Spacer()
                
                Button{
                    dismiss()
                } label: {
                    Text("취소")
                }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                    .frame(width: 60.0, height: 40.0)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                
                Spacer()
            }
        }
        .refreshable{}
    }
    
    //그룹 생성 조건
    var disableJ: Bool {
        var check = true
        
        //장소 입력, 요일 1개 이상 선택, 인원 입력, 목록 1개 이상 선택, 설명 입력
        if (cans || papers || bags || plastics || etcs) {
            check = false
        }
        
        return check
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
}

struct JoinGroupView_Previews: PreviewProvider {
    static var previews: some View {
        JoinGroupView(group: Groups(id: UUID().uuidString, place: "장소 정보", cycle: "주기 정보", days: [true,true,true,true,true,true,true], startTime: "시작 시간", endTime: "종료 시간", capacity: 1, member: [GroupMember(id: 1, name: "닉네임1", trashList: [false, false, false, false, true])], trashList: [true, true, true, true, false], comment: "그룹 설명"), userId: 0)
            .previewInterfaceOrientation(.portrait)
    }
}
