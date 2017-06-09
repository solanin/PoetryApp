//
//  word.swift
//  EdgarAllanPoetry
//
//  Created by igmstu on 2/8/17.
//  Copyright © 2017 igmstu. All rights reserved.
//

import Foundation
import UIKit

class Magnet {
    
    // MARK: - Variables -
    
    let view:UIView
    var label:UILabel
    var text:String
    var bankRefID:Int
    var id:String
    var touched:Bool
    let buffer:CGFloat = 3
    var pronoun:Bool = false
    var symobl:Bool = false
    var accessory:Bool = false
    var length:Int = 0
    
    var fontSize:CGFloat {
        if isPad { return CGFloat(26) }
        else { return CGFloat(16) }
    }
    
    // MARK: - Initilization -
    
    init (word:String, bankRefID:Int,  view:UIView) {
        self.view = view
        text = word.lowercased()
        length = text.characters.count
        touched = false
        self.bankRefID = bankRefID
        id = "null" // set below
        label = UILabel() // set below
        setTags()
        
        let l = UILabel()
        l.backgroundColor = UIColor.white
        l.text = word
        l.font = l.font.withSize(fontSize)
        l.sizeToFit()
        l.textAlignment = .center
        l.frame.size.width = l.frame.width + buffer*2
        l.isUserInteractionEnabled = true
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(doPanGesture))
        l.addGestureRecognizer(panGesture)
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeWord))
        doubleTapGesture.numberOfTapsRequired = 2
        l.addGestureRecognizer(doubleTapGesture)
        let trippleTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteWord))
        trippleTapGesture.numberOfTapsRequired = 3
        l.addGestureRecognizer(trippleTapGesture)
        label = l
        id = randomString(length: 12)
        
    }
    
    // MARK: - Helper Methods -
    
    // deterime if the word belongs in one of the word sets
    func setTags() {
        if (text == "he" || text == "his" || text == "him" || text == "she" || text == "her" || text == "hers" || text == "they" || text == "them" || text == "theirs" || text == "it" || text == "its" || text == "I" || text == "me" || text == "you" || text == "we" || text == "mine" || text == "yours") {
            pronoun = true
        }
        if (text == "." || text == "," || text == "<" || text == ">" || text == "?" || text == "!" || text == "@" || text == "#" || text == "$" || text == "%" || text == "^" || text == "&" || text == "*" || text == "(" || text == ")" || text == "-" || text == "_" || text == "=" || text == "+" || text == "{" || text == "}" || text == "[" || text == "]" || text == "|" || text == "\"" || text == "\'" || text == ":" || text == ";" || text == "`" || text == "~" || text == "/" || text == "\\" || Int(text) != nil) {
            symobl = true
        }
        if (text == "re" || text == "ed" || text == "ly" || text == "y" || text == "d" || text == "ing" || text == "s"  || text == "ful" || text == "less" || text == "est" || text == "er" || text == "un" || text == "pre" || text == "pro" || text == "dis" || text == "be" || text == "mis" || text == "sub" || text == "co" || text == "ex" || text == "able" || text == "non" || text == "im" || text == "over" || text == "under") {
            accessory = true
        }
    }
    
    
    // Creates a random string used as an identifier
    func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }

    
    // MARK: - GestureRecognizer -
    
    // Movement of magenets
    @objc func doPanGesture(panGestrue: UIPanGestureRecognizer) {
        self.touched = true
        let position = panGestrue.location(in: view)
        self.label.center = position
    }
    
    // Notifies VC to remove word
    @objc func removeWord (tapGestrure: UITapGestureRecognizer) {
        let data = ["hash":id]
        NotificationCenter.default.post(name:removeWordNotification, object: self, userInfo: data)
    }
    
    // Notifies VC to remove from dictionary
    @objc func deleteWord (tapGestrure: UITapGestureRecognizer) {
        let data = ["word":text, "hash":id]
        NotificationCenter.default.post(name:deletWordNotification, object: self, userInfo: data)
    }
}
