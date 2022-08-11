//선택한 값에 따라 다른 화면을 띄움

import SwiftUI

struct ChosenGroup: View {
    var selectedSide: SideOfTheForce
    var userId: Int64
    
    var body: some View {
        switch selectedSide {
        case .allG:
            AllGroupListView(text: "", userId: userId)
        case .myG:
            MyGroupListView(userId: userId)
        }
    }
}

struct ChosenHereView_Previews: PreviewProvider {
    static var previews: some View {
        ChosenGroup(selectedSide: .allG, userId: 0)
    }
}
