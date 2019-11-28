//
//  DataViewController.swift
//  Chiyao
//
//  Created by Andy Uyeda on 10/22/19.
//  Copyright © 2019 AndyUyeda. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var wordTextView: UITextView!
    @IBOutlet weak var translationTextView: UITextView!
    var dataObject: String = ""
    var translationObject: String = ""
    var dataIndex: Int = 0
    var topShown: Bool = true


    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.hideKeyboardWhenTappedAround() 
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.wordTextView!.text = dataObject
        self.translationTextView!.text = translationObject
        self.topShown = UserDefaults.standard.bool(forKey: "english_switch")
        print(dataObject)
        
        if(topShown)
        {
            wordTextView.isHidden = false
            translationTextView.isHidden = true
        }
        else
        {
            wordTextView.isHidden = true
            translationTextView.isHidden = false
        }
        
        if(translationObject == "Translation")
        {
            wordTextView.isHidden = false
            translationTextView.isHidden = false
        }
        
        self.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        wordTextView.isHidden = false
        translationTextView.isHidden = false
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if translationTextView.isFirstResponder
        {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height / 2
                }
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        get {
            return true
        }
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            shuffle()
        }
    }
    
    func shuffle()
    {
        var list = UserDefaults.standard.stringArray(forKey: "vocab_words") ?? ["Add Word"]
        list.shuffle()
        list.swapAt(list.firstIndex(of: "Add Word")!, list.count - 1)
        UserDefaults.standard.set(0, forKey: "current_page")
        UserDefaults.standard.set(list, forKey: "vocab_words")
    }
    
    @IBAction func save(_ sender: Any) {
        var word_array = UserDefaults.standard.stringArray(forKey: "vocab_words") ?? ["Add Word"]
        let word = wordTextView.text
        let translation = translationTextView.text
        
        if(word!.count > 0 && word != "Add Word" && !word_array.contains(word!)){
            if(translation!.count > 0 && translation != "Translation"){
                word_array[dataIndex] = word!
            
                let key = word! + "_translated"
            
                UserDefaults.standard.set(dataIndex, forKey: "current_page");
                UserDefaults.standard.set(translation, forKey: key)
            
                if(word_array.count - 1 == dataIndex)
                {
                    word_array.append("Add Word")
                }
            }
            else
            {
                //Translation is invalid
            }
        }
        else{
            //Word is not valid
        }
        
        UserDefaults.standard.set(word_array, forKey: "vocab_words")
    }
    
    @IBAction func record(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "vocab_words")
    }
    
    @IBAction func play(_ sender: Any) {
        
    }
    
    @IBAction func loop(_ sender: Any) {
        let loop = UserDefaults.standard.bool(forKey: "loop")
        UserDefaults.standard.set(!loop, forKey: "loop")
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
