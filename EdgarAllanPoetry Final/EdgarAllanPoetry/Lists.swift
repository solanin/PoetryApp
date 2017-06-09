//
//  Lists.swift
//  EdgarAllanPoetry
//
//  Created by Jacob Westerback (RIT Student) on 2/15/17.
//  Copyright © 2017 igmstu. All rights reserved.
//

import Foundation

final class Lists {
    
    // MARK: - Shared Instance -
    static let shared: Lists = Lists()
    
    // MARK: - Local Variables -
    
    var wordList:[String] = ["None","Random","Pronouns","Acessories","Symbols","1","2","3","4","5","6+"]
    
    var words:[String] = [] {
        didSet {
            DefaultsManager.sharedDefaultsManager.setCustomWordList(words: words)
        }
    }
    
    // Wordlist mostly taken from 3000-Original
    var startWords = ["&", "&", "a", "a", "a", "a", "a", "a", "about", "above", "ache", "ad", "after", "all", "am", "am", "an", "and", "and", "and", "and", "apparatus", "are", "are", "arm", "as", "as", "as", "as", "ask", "at", "at", "at", "away", "b", "bare", "be", "beat", "beauty", "bed", "beneath", "bitter", "black", "blood", "blow", "blue", "boil", "boy", "berast", "but", "but", "but", "but", "butt", "by", "by", "c", "can", "card", "chant", "chocolate", "cool", "cost", "could", "create", "crush", "cry", "d", "daddy", "day", "death", "delirious", "diamond", "did", "do", "do", "dream", "dress", "drive", "drool", "drunk", "e", "eat", "ed", "ed", "ed", "ed", "egg", "elaborate", "enormous", "er", "es", "est", "f", "fast", "feet", "fiddle", "finger", "fluff", "foe", "for", "forest", "frantic", "friend", "from", "from", "g", "garden", "girl", "go", "goddess", "gorgeous", "gown", "h", "hair", "has", "have", "have", "he", "he", "head", "heart", "heave", "her", "her", "here", "high", "him", "his", "his", "honey", "hot", "how", "i", "I", "I", "I", "if", "in", "in", "in", "ing", "ing", "ing", "ing", "ing", "ing", "is", "is", "is", "is", "is", "it", "it", "it", "j", "juice", "k", "kill", "l", "lake", "language", "languid", "lather", "lazy", "less", "let", "lick", "lie", "life", "light", "like", "like", "like", "live", "love", "luscious", "lust", "ly", "ly", "ly", "ly", "m", "mad", "man", "me", "me", "me", "mean", "meat", "men", "milk", "mist", "moan", "moon", "mother", "mommy", "music", "must", "my", "my", "my", "n", "never", "no", "no", "not", "not", "o", "of", "of", "of", "of", "on", "on", "one", "or", "our", "over", "out", "p", "pant", "peach", "petal", "picture", "pink", "play", "please", "pole", "pound", "power", "puppy", "purple", "put", "r", "r", "rain", "raw", "re", "recall", "red", "repulsive", "rip", "rock", "rose", "run", "rust", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "s", "sad", "said", "sausage", "say", "scream", "sea", "see", "shaddow", "she", "she", "shine", "ship", "shot", "show", "sing", "Sir", "sit", "skin", "sky", "sleep", "smear", "smell", "smooth", "so", "soar", "some", "sorid", "spray", "spring", "still", "stop", "storm", "suit", "summer", "sun", "sweat", "sweet", "swim", "symphony", "t", "the", "the", "the", "the", "the", "their", "there", "these", "they", "those", "though", "thousand", "through", "time", "tiny", "to", "to", "to", "together", "tounge", "trudge", "TV", "u", "ugly", "up", "urge", "us", "use", "v", "vice", "w", "want", "want", "was", "watch", "water", "wax", "we", "we", "were", "what", "when", "whisper", "who", "why", "will", "wind", "with", "with", "woman", "worship", "x", "y", "y", "y", "y", "yet", "you", "you", "you", "you", "z", ".", ".", ".", ".", ",", ",", ",", ",", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\"", "\'", "\'", "\'", "?", "?", "!", "!", "(", "(", ")", ")", "#", "$", "*", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"]

    // MARK: - Init (private) -
    private init() {}
    
}
