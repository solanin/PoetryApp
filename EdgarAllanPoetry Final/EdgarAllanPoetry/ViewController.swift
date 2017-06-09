//
//  ViewController.swift
//  EdgarAllanPoetry
//
//  Created by igmstu on 2/7/17.
//  Copyright © 2017 igmstu. All rights reserved.
//

import UIKit

let listChangedNotification = NSNotification.Name("listChangedNotification")
let removeWordNotification = NSNotification.Name("removeWordNotification")
let deletWordNotification = NSNotification.Name("deletWordNotification")
let loadPoemNotification = NSNotification.Name("loadPoemNotification")
let isPad = UIDevice.current.userInterfaceIdiom == .pad

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate { 
    
    // MARK: - Variables -
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var helpBtn: UIBarButtonItem!
    @IBOutlet weak var loadBtn: UIBarButtonItem!
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    @IBOutlet weak var bgBtn: UIBarButtonItem!
    @IBOutlet weak var clearBtn: UIBarButtonItem!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    @IBOutlet weak var listBtn: UIBarButtonItem!
    
    let picker = UIImagePickerController()
    var wordBank:[Magnet] = [] // all words
    var onScreen:[Magnet] = [] // all words in the bank
    var currPoem:[Magnet] = [] // all words in the current poem
    var amtToGenerate = 50 // bank cap
    var size:(width: CGFloat, height: CGFloat) = (width: 0, height: 0)
    var helpOn = false
    var currBG:UIImage?
    
    // MARK: - Initilization -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // BG
        picker.delegate = self
        backgroundImage.contentMode = .scaleAspectFit
        backgroundImage.backgroundColor = UIColor.gray
        
        // Load Data
        Lists.shared.words = DefaultsManager.sharedDefaultsManager.getCustomWordList()
        
        // Look for Notifications
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        NotificationCenter.default.addObserver(self, selector: #selector(listChanged), name: listChangedNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(loadPoem), name: loadPoemNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeWord), name: removeWordNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteWord), name: deletWordNotification, object: nil)
        
        // Check device to modify bank
        if (isPad) {
            amtToGenerate = amtToGenerate*2
        }
        
        // screen size for rotation adjustment
        size = (width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        
        // Make the magnets
        makeMagnetsFromMasterWordList()
        
        // Use last used list to generate starting words
        generateWords()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - Custom Words -
    
    // adds a word to the dicitonary and updates data
    func addWordToDictionary(word:String) {
        Lists.shared.words.append(word)
        
        let m = Magnet(word: word, bankRefID: wordBank.count, view: view)
        wordBank.append(m)
        
        DefaultsManager.sharedDefaultsManager.setCustomWordList(words: Lists.shared.words)
    }
    
    // removes a word from the dictionary and updates data
    func deleteWordFromDictionary(word:String) {
        
        while Lists.shared.words.contains(word) {
            if let wordToRemoveIndex = Lists.shared.words.index(of: word) {
                Lists.shared.words.remove(at: wordToRemoveIndex)
                wordBank.remove(at: wordToRemoveIndex)
            }
        }
        
        DefaultsManager.sharedDefaultsManager.setCustomWordList(words: Lists.shared.words)
    }
    
    // MARK: - Generation -

    func makeMagnetsFromMasterWordList() {
        for i in 0...Lists.shared.words.count-1 {
            let m = Magnet(word: Lists.shared.words[i], bankRefID: i, view: view)
            wordBank.append(m)
        }
    }
    
    // Makes new words
    func generateWords () {
        let list = DefaultsManager.sharedDefaultsManager.getSelectedWordList()
        generateWords(list:list)
    }
    
    // Makes new words in a catagory
    func generateWords (list:String) {
        if (list == Lists.shared.wordList[0]) { // None
            removeBankFromScreen()
        }
        else if (list == Lists.shared.wordList[1]) { // Random
            removeBankFromScreen()
            showNewWords(amt: amtToGenerate)
        }
        else { // Typed
            removeBankFromScreen()
            showNewWords(amt: amtToGenerate, type: list)
        }
    }
    
    // Gets a given amount of random words and gives you a list of that length populated with magnets
    func getRandomWords(amt:Int) -> [Magnet]
    {
        var randWords:[Magnet] = []
        var ids:[Int] = []
        for _ in 1...amt {
            var random = Int(arc4random_uniform(UInt32(wordBank.count)))
            while (ids.contains(random) && amt < wordBank.count){
                random = Int(arc4random_uniform(UInt32(wordBank.count)))
            }
            randWords.append(Magnet(word: wordBank[random].text, bankRefID: wordBank[random].bankRefID, view: view))
            ids.append(random)
        }
        return randWords
    }
    
    // Gets a given amount of words of a type and gives you a list of at least that length populated with magnets
    func getTypedWords(amount:Int, type:String) -> [Magnet]
    {
        var amt = amount
        var typedWordBank:[Magnet] = []
        for w in wordBank {
            if (w.pronoun && type == Lists.shared.wordList[2]) {
                typedWordBank.append(w)
            }
            if (w.accessory && type == Lists.shared.wordList[3]) {
                typedWordBank.append(w)
            }
            if (w.symobl && type == Lists.shared.wordList[4]) {
                typedWordBank.append(w)
            }
            if (w.length == 1 && type == Lists.shared.wordList[5]) {
                typedWordBank.append(w)
            }
            if (w.length == 2 && type == Lists.shared.wordList[6]) {
                typedWordBank.append(w)
            }
            if (w.length == 3 && type == Lists.shared.wordList[7]) {
                typedWordBank.append(w)
            }
            if (w.length == 4 && type == Lists.shared.wordList[8]) {
                typedWordBank.append(w)
            }
            if (w.length == 5 && type == Lists.shared.wordList[9]) {
                typedWordBank.append(w)
            }
            if (w.length > 5 && type == Lists.shared.wordList[10]) {
                typedWordBank.append(w)
            }
        }
        
        if (type == Lists.shared.wordList[10]) {
            // Words are longer, lets show less
            amt = Int(Double(amt)*0.6)
        }
        
        var randWords:[Magnet] = []
        
        if (typedWordBank.count > 0) {
            if (typedWordBank.count < amt) {
                for w in typedWordBank {
                    randWords.append(Magnet(word: w.text, bankRefID: w.bankRefID, view: view))
                }
            }
            else {
                var ids:[Int] = []
                for _ in 1...amt {
                    var random = Int(arc4random_uniform(UInt32(typedWordBank.count)))
                    while (ids.contains(random) && amt < typedWordBank.count){
                        random = Int(arc4random_uniform(UInt32(typedWordBank.count)))
                    }
                    randWords.append(Magnet(word: typedWordBank[random].text, bankRefID: typedWordBank[random].bankRefID, view: view))
                    ids.append(random)
                }
            }
        }
        return randWords
    }
    
    // organizes the wordbank on the screen
    func organizeWords (wordlabels:[Magnet] ) {
        if (wordlabels.count > 0) {
            let rowHeight = wordlabels[0].label.frame.size.height
            let rowWidth = size.width
            let rowBuff:CGFloat = 5
            let wordBuff:CGFloat = 8
            let Xmargin:CGFloat = 40
            let Ymargin:CGFloat = 70
            
            var currRow:CGFloat = 0
            var currX:CGFloat = Xmargin
            
            for word in wordlabels {
                
                if (currX+wordBuff + word.label.frame.size.width > rowWidth-Xmargin*2) {
                    currX = Xmargin
                    currRow = currRow+1
                }
                
                let x = currX+wordBuff + word.label.frame.size.width/2
                let y = Ymargin + rowBuff + (rowBuff + rowHeight) * currRow
                
                currX = x + word.label.frame.size.width/2
                
                word.label.center = CGPoint (x:x, y:y)
            }
        }
    }
    
    // sets up the bank with random
    func showNewWords(amt: Int) {
        let newWords = getRandomWords(amt: amt)
        organizeWords(wordlabels: newWords)
        for word in newWords{
            onScreen.append(word)
            view.addSubview(word.label)
        }
    }
    
    // sets up the bank with a type
    func showNewWords(amt: Int, type:String) {
        let newWords = getTypedWords(amount: amt, type:type)
        organizeWords(wordlabels: newWords)
        for word in newWords{
            onScreen.append(word)
            view.addSubview(word.label)
        }
    }
    
    // Looks at all the words on screen to determine if any are in the poem and need to be removed from the bank
    func sortWordsOnScreen () {
        var toRemove:[Int] = []
        
        if (onScreen.count > 0) {
            for i in 0...onScreen.count-1{
                if (onScreen[i].touched) {
                    let newWord = Magnet(word: onScreen[i].text, bankRefID: onScreen[i].bankRefID, view: view)
                    newWord.label.center = onScreen[i].label.center
                    view.addSubview(newWord.label)
                    currPoem.append(newWord)
                    toRemove.append(i)
                }
            }
        }
        
        if (toRemove.count > 0) {
            toRemove = toRemove.sorted(by: >)
            for rm in toRemove {
                onScreen[rm].label.removeFromSuperview()
                onScreen.remove(at: rm)
            }
        }
    }
    
    // MARK: - Controls -
    
    // Clears the bank
    func removeBankFromScreen () {
        sortWordsOnScreen()
        for m in onScreen{
            m.label.removeFromSuperview()
        }
        onScreen.removeAll()
    }
    
    // Clears the poem
    func clearCurrPoem() {
        sortWordsOnScreen()
        for m in currPoem{
            m.label.removeFromSuperview()
        }
        currPoem.removeAll()
    }
    
    
    // Clear button action
    @IBAction func clearPoem(_ sender: Any) {
        clearCurrPoem()
    }
    
    // Add word to dictionary button action
    @IBAction func addWordButton(_ sender: Any) {
        let alert = UIAlertController(title: "Custom Word", message: "Type a word and press 'Add' to add it to the dictionary", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Type a word here"
        }
        alert.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.destructive, handler: { action in
            // check input
            if let field = alert.textFields?[0] {
                // store your data
                self.addWordToDictionary(word: field.text!)
            } else {
                // user did not fill field
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // Takes a screenshot and returns it
    func takeScreenShot() -> UIImage{
        //Create the UIImage
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        //Save it to the camera roll
        UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil)
        
        return image!
    }
    
    // Share an image & text
    func socialShare(sender: Any, sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text as AnyObject)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        // set up activity view controller
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: [])
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard,UIActivityType.airDrop,UIActivityType.addToReadingList,UIActivityType.assignToContact,UIActivityType.postToTencentWeibo,UIActivityType.postToVimeo,UIActivityType.print,UIActivityType.saveToCameraRoll,UIActivityType.postToWeibo]
        // present the view controller
        if (isPad) {
            activityViewController.popoverPresentationController?.barButtonItem = saveBtn
            present(activityViewController, animated: true)
        }
        else {
            present(activityViewController, animated: true)
        }
    }
    
    // Save button action
    @IBAction func saveAndShare(_ sender: Any) {
        // image to share
        sortWordsOnScreen()
        let image = takeScreenShot()
        var title = "My Poem"
        
        let alert = UIAlertController(title: "Screenshot Taken", message: "A screenshot of your photo was taken. This can be viewed in your photo library.", preferredStyle: UIAlertControllerStyle.alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Title"
        }
        alert.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default, handler: { action in
            // check input
            if let field = alert.textFields?[0] {
                if (field.text! != "") {
                    title = field.text!
                }
            }
            if(self.currPoem.count > 0) {
                DefaultsManager.sharedDefaultsManager.addPoem(poem: Poem(poem: self.currPoem, title: title, bg: self.backgroundImage.image), view: self.view)
            }
            
        }))
        alert.addAction(UIAlertAction(title: "Share", style: UIAlertActionStyle.default, handler: { action in
            // check input
            if let field = alert.textFields?[0] {
                title = field.text!
            }
            if(self.currPoem.count > 0) {
                DefaultsManager.sharedDefaultsManager.addPoem(poem: Poem(poem: self.currPoem, title: title, bg: self.backgroundImage.image), view: self.view)
            }
            self.socialShare(sender: sender, sharingText: title, sharingImage: image, sharingURL: NSURL(string: "http://itunes.apple.com/app/"))
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    // selects an image from gallary
    func selectImage(sender: Any) {
        picker.allowsEditing = false
        picker.modalPresentationStyle = .popover
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(picker, animated: true, completion: nil)
        picker.popoverPresentationController?.barButtonItem = sender as? UIBarButtonItem
    }
    
    // Add Background image button action
    @IBAction func addBackgroundImage(_ sender: Any) {
        selectImage(sender: sender)
    }
    
    // ? button action
    @IBAction func help(_ sender: Any) {
        helpOn = !helpOn
        if (helpOn) {
            currBG = backgroundImage.image
            helpBtn.title = "X"
            backgroundImage.image = #imageLiteral(resourceName: "Help")
            //send to front
            removeBankFromScreen()
            
            // disable buttons
            loadBtn.isEnabled = false
            saveBtn.isEnabled = false
            bgBtn.isEnabled = false
            clearBtn.isEnabled = false
            addBtn.isEnabled = false
            listBtn.isEnabled = false
            
            // Remove current poem from screen
            for m in currPoem{
                m.label.removeFromSuperview()
            }
            
        }
        else {
            helpBtn.title = "?"
            backgroundImage.image = currBG
            //send to back
            generateWords()
            
            // enable buttons
            loadBtn.isEnabled = true
            saveBtn.isEnabled = true
            bgBtn.isEnabled = true
            clearBtn.isEnabled = true
            addBtn.isEnabled = true
            listBtn.isEnabled = true
            
            // Add current poem to screen
            for m in currPoem{
                view.addSubview(m.label)
            }
        }
    }
    
    // MARK: - UIImagePickerControllerDelegate Methods -
    
    // Sets choses image to the bg
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        dismiss(animated:true, completion: nil)
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.image = chosenImage
        }
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated:true, completion: nil)
        if let chosenImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            backgroundImage.contentMode = .scaleAspectFit
            backgroundImage.image = chosenImage
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Storyboard Actions -
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showListSegue" {
            let wordListVC = segue.destination.childViewControllers[0] as! WordListVC
            wordListVC.title = "Choose a word list"
        }
    }
    
    // MARK: - Notifcations -
    
    // A new word list has been selected
    func listChanged(n:Notification) {
        let d = n.userInfo!
        let list = d["list"] as! String
        
        generateWords(list: list)
    }
    
    // The screen has been rotated
    func rotated() {
        if (UIDevice.current.orientation.isPortrait) {
            if (size.width > size.height) {
                size = (width: size.height, height:size.width)
            }
        }
        else if (UIDevice.current.orientation.isLandscape) {
            if (size.height > size.width) {
                size = (width: size.height, height:size.width)
            }
        }
        
        sortWordsOnScreen()
        organizeWords(wordlabels: onScreen)
    }
    
    // finds the index of a word based on its id in given list
    func findIndexForWordInList (list:[Magnet], hash:String) -> Int {
        var index:Int = -1
        
        if (list.count > 1) {
            for i in 0...list.count-1 {
                if (list[i].id == hash) {
                    index = i
                }
            }
        }
        else if (list.count == 1 && list[0].id == hash) {
            index = 0
        }
        return index
    }
    
    // removes a word from a poem
    func removeWord (n:Notification) {
        sortWordsOnScreen()
        let d = n.userInfo!
        let hash = d["hash"] as! String
        
        let toRemove = findIndexForWordInList(list: currPoem, hash: hash)
        
        if (toRemove != -1) {
            currPoem[toRemove].touched = false
            currPoem[toRemove].label.removeFromSuperview()
            currPoem.remove(at: toRemove)
        }
    }
    
    // delete a word from the dictionary
    func deleteWord (n:Notification) {
        sortWordsOnScreen()
        
        let d = n.userInfo!
        let word = d["word"] as! String
        
        let alert = UIAlertController(title: "Delete Word", message: "Are you sure you would like to remove all instances of the word \(word) from the dictionary?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: { action in
            
            self.deleteWordFromDictionary(word: word)
            
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    // load a poem
    func loadPoem (n:Notification) {
        let d = n.userInfo!
        let poemIndex = d["poemIndex"] as! Int
        let savedPoems = DefaultsManager.sharedDefaultsManager.getPoemList(view: view)
        var poem:Poem?
        if (savedPoems.count >= poemIndex) {
            poem = savedPoems[poemIndex]
        }
        
        if (poem != nil) {
            removeBankFromScreen()
            clearCurrPoem()
            backgroundImage.image = poem?.background
            currPoem = (poem?.poem)!
            for p in currPoem {
                view.addSubview(p.label)
            }
        } else {
            let alert = UIAlertController(title: "Not Found", message: "The poem you are looking for could not be found", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Cleanup -
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

