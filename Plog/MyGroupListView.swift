//참여 그룹 목록을 띄우는 화면

import SwiftUI

struct MyGroupListView: View {
    var userId: Int64
    @ObservedObject var groupViewModel: GroupViewModel
    
    var body: some View {
        //그룹 목록
        List {
            ForEach(groupViewModel.groups, id: \.id) { group in
                if (group.member.contains{$0.id == userId}) {
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
        MyGroupListView(userId: 0, groupViewModel: GroupViewModel())
            .previewInterfaceOrientation(.portrait)
    }
}

