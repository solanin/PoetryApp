//
//  Poem.swift
//  EdgarAllanPoetry
//
//  Created by igmstu on 2/21/17.
//  Copyright © 2017 igmstu. All rights reserved.
//

import Foundation
import UIKit

class Poem {
    // MARK: - Variables -
    var poem:[Magnet]
    var title:String
    var background:UIImage?
    
    // MARK: - Initialization -
    init(poem:[Magnet], title:String, bg:UIImage?) {
        self.poem = poem
        self.title = title
        background = bg
    }
    
    convenience init(poem:[Magnet], title:String) {
        self.init(poem: poem, title: title, bg: nil)
    }
    
    convenience init(poem:[Magnet], bg:UIImage?) {
        self.init(poem: poem, title: "My Poem", bg: bg)
    }
    
    convenience init(poem:[Magnet]) {
        self.init(poem: poem, title: "My Poem", bg: nil)
    }
    
}
