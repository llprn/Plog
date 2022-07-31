//그룹 생성 페이지

import SwiftUI

struct ComposeGroupView: View {
    @Environment(\.dismiss) var dismiss
    //장소 입력 시 화면 높이 조정
    @FocusState var placeIsFocused: Bool
    @FocusState var commentIsFocused: Bool
    @StateObject private var keyboardHandler = KeyboardHandler()
    
    //update할 변수 선언, 초기화
    //장소
    @ObservedObject var place = TextLimiter(limit: 20)
    //날짜: 주기, 요일, 시작 시간, 종료 시간
    var cycles = ["매주", "격주", "매달"]
    @State private var cycle: String = "매주"
    @State var sunday = false
    @State var monday = false
    @State var tuesday = false
    @State var wednesday = false
    @State var thusday = false
    @State var friday = false
    @State var saturday = false
    @State private var startT = Date() - 3600
    @State private var endT = Date() + 3600
    //인원
    @State private var capacity: Int = 0
    //분리수거 목록
    @State var cans = false
    @State var papers = false
    @State var bags = false
    @State var plastics = false
    @State var etcs = false
    //그룹 설명
    @ObservedObject var comment = TextLimiter(limit: 100)
    
    var dateFormatter: DateFormatter {
        let df = DateFormatter()
        df.dateFormat = "HH:mm"
        return df
    }
    
    var body: some View {
        VStack {
            //장소 텍스트로 입력
            HStack {
                Text("장소")
                    .padding()
                    .font(.headline)
                ZStack {
                    Text(place.value)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .overlay(
                            TextEditor(text: $place.value)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))
                                .textInputAutocapitalization(.never)
                                .focused($placeIsFocused)
                        )
                    if place.value.isEmpty {
                        VStack {
                            Text("장소를 입력해주세요. (1~20자)")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.leading)
                        }
                    }
                }
            }
            .padding(.trailing)
            .padding(.top, placeIsFocused ? keyboardHandler.keyboardHeight : 10.0)
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
                
            //날짜 입력
            VStack{
                HStack {
                    Text("날짜")
                        .padding(.leading)
                        .font(.headline)
                    Spacer()
                }
                GroupBox (label: Text("")) {
                    Text("플로깅 활동 주기, 요일, 시간을 선택해주세요.")
                        .font(.caption)
                        .padding(.bottom, 10.0)
                    HStack {
                        //주기 선택
                        Picker(selection: $cycle, label: Text("주기")) {
                                ForEach(cycles, id: \.self) {
                                    Text($0)
                                }
                        }.pickerStyle(MenuPickerStyle())
                            .accentColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                        //요일 선택
                        Button(action: {
                            self.sunday.toggle()
                        }) {
                            Text("일")
                                .frame(width: 30.0, height: 25.0)
                                .background(sunday ? .green : Color(hue: 0.397, saturation: 0.0, brightness: 0.85))
                                .foregroundColor(sunday ? .black : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                .cornerRadius(5.0)
                        }
                        Button(action: {
                            self.monday.toggle()
                        }) {
                            Text("월")
                                .frame(width: 30.0, height: 25.0)
                                .background(monday ? .green : Color(hue: 0.397, saturation: 0.0, brightness: 0.85))
                                .foregroundColor(monday ? .black : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                .cornerRadius(5.0)
                        }
                        Button(action: {
                            self.tuesday.toggle()
                        }) {
                            Text("화")
                                .frame(width: 30.0, height: 25.0)
                                .background(tuesday ? .green : Color(hue: 0.397, saturation: 0.0, brightness: 0.85))
                                .foregroundColor(tuesday ? .black : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                .cornerRadius(5.0)
                        }
                        Button(action: {
                            self.wednesday.toggle()
                        }) {
                            Text("수")
                                .frame(width: 30.0, height: 25.0)
                                .background(wednesday ? .green : Color(hue: 0.397, saturation: 0.0, brightness: 0.85))
                                .foregroundColor(wednesday ? .black : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                .cornerRadius(5.0)
                        }
                        Button(action: {
                            self.thusday.toggle()
                        }) {
                            Text("목")
                                .frame(width: 30.0, height: 25.0)
                                .background(thusday ? .green : Color(hue: 0.397, saturation: 0.0, brightness: 0.85))
                                .foregroundColor(thusday ? .black : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                .cornerRadius(5.0)
                        }
                        Button(action: {
                            self.friday.toggle()
                        }) {
                            Text("금")
                                .frame(width: 30.0, height: 25.0)
                                .background(friday ? .green : Color(hue: 0.397, saturation: 0.0, brightness: 0.85))
                                .foregroundColor(friday ? .black : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                .cornerRadius(5.0)
                        }
                        Button(action: {
                            self.saturday.toggle()
                        }) {
                            Text("토")
                                .frame(width: 30.0, height: 25.0)
                                .background(saturday ? .green : Color(hue: 0.397, saturation: 0.0, brightness: 0.85))
                                .foregroundColor(saturday ? .black : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                                .cornerRadius(5.0)
                        }
                    }
                        
                    HStack(alignment: .center) {
                        //시간 선택
                        DatePicker(selection: $startT, displayedComponents: .hourAndMinute, label: { })
                            .labelsHidden()
                        Text("~")
                        DatePicker(selection: $endT, displayedComponents: .hourAndMinute, label: { })
                            .labelsHidden()
                    }
                    .padding(.top)
                }
                .padding(.horizontal)
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
                    
            //모집 인원
            HStack {
                Text("모집 인원")
                    .padding()
                    .font(.headline)
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                Stepper(value: $capacity, in: 0...20) {
                    Text("\t\t"+String(capacity))
                        .foregroundColor((capacity == 0) ? .gray : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                }
                .padding(.horizontal)
            }
                
            //분리수거 목록
            VStack {
                HStack {
                    Text("생성할 분리수거 목록")
                        .font(.headline)
                        .padding(.leading)
                    Spacer()
                }
                GroupBox (label: Text("")) {
                    Text("생성할 목록을(본인이 수거할 것 이외의 항목) 선택해주세요.")
                        .font(.caption)
                    HStack {
                        Button (action: {
                            self.cans.toggle()
                        }) {
                            Image(systemName: cans ? "checkmark.square.fill" : "square")
                                .font(.caption)
                            Text("캔")
                                .frame(width: 25.0)
                        }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                        Button (action: {
                            self.papers.toggle()
                        }) {
                            Image(systemName: papers ? "checkmark.square.fill" : "square")
                                .font(.caption)
                            Text("종이")
                                .frame(width: 30.0)
                        }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                        Button (action: {
                            self.bags.toggle()
                        }) {
                            Image(systemName: bags ? "checkmark.square.fill" : "square")
                                .font(.caption)
                            Text("비닐")
                                .frame(width: 30.0)
                        }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                        Button (action: {
                            self.plastics.toggle()
                        }) {
                            Image(systemName: plastics ? "checkmark.square.fill" : "square")
                                .font(.caption)
                            Text("플라스틱")
                                .frame(width: 60.0)
                        }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                        Button (action: {
                            self.etcs.toggle()
                        }) {
                            Image(systemName: etcs ? "checkmark.square.fill" : "square")
                                .font(.caption)
                            Text("일반")
                                .frame(width: 30.0)
                        }.foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                    }
                    .padding(.vertical, 10.0)
                }
                .padding([.leading, .bottom, .trailing])
            }
            .onTapGesture {
                UIApplication.shared.endEditing()
            }
                
            //그룹 설명
            VStack(alignment: .leading) {
                Text("그룹 설명")
                    .font(.headline)
                    .padding(.leading)
                ZStack {
                    Text(comment.value)
                        .padding(10)
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .overlay(
                            TextEditor(text: $comment.value)
                                .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 1))
                                .textInputAutocapitalization(.never)
                                .focused($commentIsFocused)
                        )
                    //placeholder기능. 글자 입력 시 사라짐
                    if comment.value.isEmpty {
                        VStack {
                            Text("그룹 설명을 입력해주세요.(100자 이내)\nex) 시작 날짜, 기타 공지사항 등")
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding()
                        }
                    }
                }.padding(.horizontal)
            }
                
                //생성, 취소 버튼
            HStack {
                Spacer()
                Button (action: {
                    Groups.dummyGroupList.insert(Groups(place: place.value.replacingOccurrences(of: "\n", with: " "), cycle: cycle, days: [sunday, monday, tuesday, wednesday, thusday, friday, saturday], startTime: dateFormatter.string(from: startT), endTime: dateFormatter.string(from: endT), capacity: capacity, peopleList: [GroupMember(name: "개설자", trash: [!cans, !papers, !bags, !plastics, !etcs])], trashList: [cans, papers, bags, plastics, etcs], comment: comment.value), at: 0)
                    dismiss()
                }) {
                    Text("생성")
                }
                .disabled(disableC)
                .frame(width: 60.0, height: 40.0)
                .foregroundColor(disableC ? .gray : Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                .overlay(RoundedRectangle(cornerRadius: 5).stroke(disableC ? .gray : .black, lineWidth: 2))
                    
                Spacer()
                    
                Button (action: {
                    dismiss()
                }) {
                    Text("취소")
                        .foregroundColor(Color(hue: 0.397, saturation: 0.87, brightness: 0.509))
                }.frame(width: 60.0, height: 40.0)
                    .overlay(RoundedRectangle(cornerRadius: 5).stroke(.black, lineWidth: 2))
                Spacer()
            }.padding(.top, 40)
                .padding(.bottom, commentIsFocused ? 100.0 : 0.0)
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
        }
    }
    
    //그룹 생성 조건
    var disableC: Bool {
        var check = true
        
        //장소 입력, 요일 1개 이상 선택, 인원 입력, 목록 1개 이상 선택, 설명 입력
        if (!place.value.isEmpty && (sunday || monday || tuesday || wednesday || thusday || friday || saturday) && (capacity != 0) && (cans || papers || bags || plastics || etcs) && !comment.value.isEmpty) {
            check = false
        }
        
        return check
    }
}

//화면 클릭 시 키보드 내리도록 확장
extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}

//프리뷰
struct ComposeView_Previews: PreviewProvider {
    static var previews: some View {
        ComposeGroupView()
            .previewInterfaceOrientation(.portrait)
    }
}
