//선택한 값에 따라 다른 화면을 띄움

import SwiftUI

struct ChosenGroup: View {
    var selectedSide: SideOfTheForce
    var userId: Int64
    
    @ObservedObject var groupViewModel: GroupViewModel
    
    var body: some View {
        switch selectedSide {
        case .allG:
            AllGroupListView(text: "", groupViewModel: groupViewModel, userId: userId)
        case .myG:
            MyGroupListView(userId: userId, groupViewModel: groupViewModel)
        }
    }
}

struct ChosenHereView_Previews: PreviewProvider {
    static var previews: some View {
        ChosenGroup(selectedSide: .allG, userId: 0, groupViewModel: GroupViewModel())
    }
}
