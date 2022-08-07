//참여 그룹 목록을 띄우는 화면

import SwiftUI

struct MyGroupListView: View {
    var body: some View {
        //그룹 목록
        List {
            ForEach(Groups.dummyGroupList, id: \.id) { group in
                if (group.peopleList.contains{$0.name == "개설자"}) {
                    NavigationLink {
                        GroupDetailView(group: group)
                            .navigationBarHidden(true)
                    } label: {
                        GroupCell(group: group)
                    }
                }
            }
        }
    }
}

struct JoinListView_Previews: PreviewProvider {
    static var previews: some View {
        MyGroupListView()
            .previewInterfaceOrientation(.portrait)
    }
}

