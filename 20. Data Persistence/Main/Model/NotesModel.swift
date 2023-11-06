//
//  File.swift
//  20. Data Persistence
//
//  Created by Sesili Tsikaridze on 06.11.23.
//

import Foundation
import UIKit

class Note {
    let title: UITextView
    let body: UITextView
    
    init(title: UITextView, body: UITextView) {
        self.title = title
        self.body = body
    }
}

var notes = [Note]()
