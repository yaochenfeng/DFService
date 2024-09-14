

import SwiftUI

struct ErrorPage: View {
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            
            Image("pageError", bundle: .module)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .center) {
                Text("页面不存在")
                    .font(.title)
                
                Button(action: {
                    
                }) {
                    Text("返回".uppercased())
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .padding(.horizontal, 30)
                        .background(Capsule().foregroundColor(.blue))
                }
               

            }.padding(.bottom, 20)
            
        }
    }
}

struct ErrorPage_Previews: PreviewProvider {
    static var previews: some View {
        ErrorPage()
    }
}
