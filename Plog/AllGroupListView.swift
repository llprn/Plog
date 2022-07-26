//그룹 목록을 띄우는 화면

import SwiftUI

struct AllGroupListView: View {
    var body: some View {
        //그룹 목록
        List(Groups.dummyGroupList, id: \.id) { group in
            NavigationLink {
                if(group.peopleList.contains{$0.name == "개설자"}) {
                    GroupDetailView(group: group)
                        .navigationBarHidden(true)
                } else {
                    JoinGroupView(group: group)
                        .navigationBarHidden(true)
                }
            } label: {
                GroupCell(group: group)
            }
        }
    }
}

struct AllGroupListView_Previews: PreviewProvider {
    static var previews: some View {
        AllGroupListView()
            .previewInterfaceOrientation(.portrait)
    }
}
