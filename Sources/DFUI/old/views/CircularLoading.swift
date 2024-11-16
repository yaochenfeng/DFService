import SwiftUI

public struct CircularLoading: View {
    let color: Color
    public init(_ color: Color = .accentColor) {
        self.color = color
    }
    public var body: some View {
        ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: color))
    }
}

struct CircularLoading_Previews: PreviewProvider {
    static var previews: some View {
        CircularLoading()
    }
}
