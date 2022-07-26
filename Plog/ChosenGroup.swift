//선택한 값에 따라 다른 화면을 띄움

import SwiftUI

struct ChosenGroup: View {
    var selectedSide: SideOfTheForce
    
    var body: some View {
        switch selectedSide {
        case .allG:
            AllGroupListView()
        case .myG:
            MyGroupListView()
        }
    }
}

struct ChosenHereView_Previews: PreviewProvider {
    static var previews: some View {
        ChosenGroup(selectedSide: .allG)
    }
}
