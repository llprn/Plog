//참여 그룹 목록을 띄우는 화면

import SwiftUI

struct MyGroupListView: View {
    var userId: Int64
    
    var body: some View {
        //그룹 목록
        List {
            ForEach(Groups.dummyGroupList, id: \.id) { group in
                if (group.peopleList.contains{$0.id == userId}) {
                    NavigationLink {
                        GroupDetailView(group: group, userId: userId)
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
        MyGroupListView(userId: 0)
            .previewInterfaceOrientation(.portrait)
    }
}

