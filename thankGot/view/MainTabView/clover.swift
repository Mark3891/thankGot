//
//  clover.swift
//  thankGot
//
//  Created by Woody on 4/19/25.
//

import SwiftUI

struct clover: View {
    let letter: Letter
    
    var body: some View {
        Image("clover")
            .frame(width: 100, height: 100)
    }
}

#Preview {
    clover(letter: dummySentLetters[0])
}
