//
//  DefautsManager.swift
//  EdgarAllanPoetry
//
//  Created by Jacob Westerback (RIT Student) on 2/20/17.
//  Copyright © 2017 igmstu. All rights reserved.
//

import Foundation
import UIKit

class DefaultsManager{
    
    // MARK: - Variables -
    
    // MARK: Shared Instance
    static let sharedDefaultsManager = DefaultsManager() // single instance
    let defaults = UserDefaults.standard
    
    // MARK: Keys
    let CUSTOM_WORD_LIST = "custom_word_list"
    let SELECTED_WORD_LIST = "selected_word_list"
    let POEMS = "poem_list"
    let IS_POEMS = "is_there_any_poems"
    
    // MARK: PoemArrarys
    var poemTitles:[String] = []
    let POEMS_TITLE = "poem_title"
    var poemBG:[UIImage?] = []
    var poemBGData:[NSData?] = []
    let POEMS_BG = "poem_bg"
    var poemCount:[Int] = []
    let POEMS_COUNT = "poem_count"
    var magWord:[String] = []
    let MAGNET_WORD = "mag_word"
    var magIndexID:[Int] = []
    let MAGNET_ID = "poem_id"
    var magXPos:[Int] = []
    let MAGNET_X = "mag_x"
    var magYPos:[Int] = []
    let MAGNET_Y = "mag_y"
    // TODO: TO DO : Fix Location
    
    // MARK: - Init (private) -
    // This prevents others from using the default initializer for this class.
    private init() {}
    
    
    // MARK: - Getters -
    
    func getPoemList(view:UIView)->[Poem]{
        if defaults.bool(forKey: IS_POEMS) {
            //print("value for POEMS")
            let poems:[Poem] = loadPoems(view: view)
            return poems
        } else {
            //print("no value for saved poems found, default to Starting List")
            let empty:[Poem] = []
            return empty
        }
    }
    
    func getTitles()->[String]{
        if defaults.bool(forKey: IS_POEMS) {
            //print("value for POEMS")
            poemTitles = defaults.array(forKey: POEMS_TITLE) as! [String]
            return poemTitles
        } else {
            //print("no value for custom words found, default to Starting List")
            let empty:[String] = []
            return empty
        }
    }

    func getCustomWordList()->[String]{
        if let customWords:[String] = defaults.array(forKey: CUSTOM_WORD_LIST) as! [String]? {
            //print("value for CUSTOM_WORD_LIST")
            return customWords
        }else{
            //print("no value for custom words found, default to Starting List")
            return Lists.shared.startWords
        }
    }
    
    func getSelectedWordList()->String{
        if let selectedList:String = defaults.string(forKey: SELECTED_WORD_LIST){
            //print("value for CUSTOM_WORD_LIST")
            return selectedList
        }else{
            //print("no value for custom words found, default to Random")
            return "Random"
        }
    }
    
    // MARK: - Setters -
    
    func addPoem(poem:Poem, view:UIView){
        var poems:[Poem] = loadPoems(view: view)
        poems.append(poem)
        
        savePoem(poems: poems)
        
        //print("adding value for POEMS")
    }
    
    func setCustomWordList(words:[String]){
        defaults.set(words, forKey: CUSTOM_WORD_LIST)
        defaults.synchronize()
        //print("setting value for CUSTOM_WORD_LIST")
    }
    
    func setSelectedWordList(selection:String){
        defaults.set(selection, forKey: SELECTED_WORD_LIST)
        defaults.synchronize()
        //print("setting value for SELECTED_WORD_LIST to /(selection)")
    }
    
    // MARK: - Decode and Encode for Poem Objects -
    func loadPoems(view:UIView) -> [Poem] {
        var actualPoems:[Poem] = []
        
        if defaults.bool(forKey: IS_POEMS) {
            poemTitles = defaults.array(forKey: POEMS_TITLE) as! [String]
            poemBGData = defaults.array(forKey: POEMS_BG) as! [NSData?]
            for p in poemBGData {
                if (p != nil) {
                    poemBG.append(UIImage(data: p as! Data))
                } else if (p == NSData()) {
                    poemBG.append(nil)
                }
            }
            poemCount = defaults.array(forKey: POEMS_COUNT) as! [Int]
            magWord = defaults.array(forKey: MAGNET_WORD) as! [String]
            magIndexID = defaults.array(forKey: MAGNET_ID) as! [Int]
            magXPos = defaults.array(forKey: MAGNET_X) as! [Int]
            magYPos = defaults.array(forKey: MAGNET_Y) as! [Int]
            
            var currIndex = 0
            for i in 0...poemCount.count-1 {
                var magnets:[Magnet] = []
                for _ in 0...poemCount[i]-1 {
                    let newMagnet = Magnet(word: magWord[currIndex], bankRefID: magIndexID[currIndex], view: view)
                    newMagnet.label.center = CGPoint(x: magXPos[currIndex], y: magYPos[currIndex])
                    magnets.append(newMagnet)
                    
                    currIndex = currIndex + 1;
                }
                
                actualPoems.append(Poem(poem: magnets, title: poemTitles[i], bg: poemBG[i]))
            }
        } else {
            poemTitles = []
            poemBG = []
            poemBGData = []
            poemCount = []
            magWord = []
            magIndexID = []
            magXPos = []
            magYPos = []
        }
        
        //print("Load Poems")
        return actualPoems
    }
    
    func savePoem(poems:[Poem]) {
        poemTitles = []
        poemBG = []
        poemBGData = []
        poemCount = []
        magWord = []
        magIndexID = []
        magXPos = []
        magYPos = []
        
        if poems.count > 0 {
            for p in poems {
                poemTitles.append(p.title)
                poemBG.append(p.background)
                if (p.background != nil) {
                    let dataImage = UIImagePNGRepresentation(p.background!) as NSData?
                    poemBGData.append(dataImage)
                } else {
                    poemBGData.append(NSData())
                }
                poemCount.append(p.poem.count)
                for m in p.poem {
                    magWord.append(m.text)
                    magIndexID.append(m.bankRefID)
                    magXPos.append(Int(m.label.center.x))
                    magYPos.append(Int(m.label.center.y))
                }
            }
            
            
            defaults.set(poemTitles, forKey: POEMS_TITLE)
            defaults.set(poemBGData, forKey: POEMS_BG)
            defaults.set(poemCount, forKey: POEMS_COUNT)
            defaults.set(magWord, forKey: MAGNET_WORD)
            defaults.set(magIndexID, forKey: MAGNET_ID)
            defaults.set(magXPos, forKey: MAGNET_X)
            defaults.set(magYPos, forKey: MAGNET_Y)
            defaults.set(true, forKey: IS_POEMS)
            defaults.synchronize()
            //print("Save Poems")
        }
    }
    
}
