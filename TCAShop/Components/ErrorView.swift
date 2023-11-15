//
//  ErrorView.swift
//  TCAPedro
//
//  Created by User on 14.11.2023.
//

import SwiftUI

struct ErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text(":(")
            Text("")
            Text(self.message)
                .font(.custom("AmericanTypewriter", size: 25))
            Button {
                self.retryAction()
            } label: {
                Text("Retry")
                    .font(.custom("AmericanTypewriter", size: 25))
                    .foregroundColor(.white)
            }
            .frame(width: 100, height: 60)
            .background(.blue)
            .cornerRadius(10)
            .padding()
        }
        
    }
}

#Preview {
    ErrorView(message: "un call pourri", retryAction: {} )
}
