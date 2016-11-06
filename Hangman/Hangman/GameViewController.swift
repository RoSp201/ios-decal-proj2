//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    
    // MARK: Properties
    @IBOutlet var HangmanStatusImage: UIImageView!
    @IBOutlet var puzzelWordLabel: UILabel!
    @IBOutlet weak var guessTextField: UITextField!
    @IBOutlet weak var wrongLettersLabel: UILabel!
    
    var puzzleWord: String = ""
    var tries = 0
    var correct = false
    var hangman_imgs = [UIImage]()
    var word = ""
    var word_array = [Character]()
    var bad_letters = [Character]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        
        word = (phrase)! // to make comparisons easier
        word = word.lowercased()
        word_array = Array(word.characters)
        for i in 0..<word_array.count {
            if word_array[i] == " " {
                puzzleWord.append(" ")
            }
            else
            {
                puzzleWord.append("-")
            }
        }
        
        print(puzzleWord)
        print(phrase)
        for i in (1...7) {
            hangman_imgs.append(UIImage(named: "hangman" + String(i) + ".gif")!)
        }
        HangmanStatusImage.image = hangman_imgs[0]
        puzzelWordLabel.text = String(puzzleWord)
        wrongLettersLabel.text = String("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func replace(myString: String, _ index: Int, _ newChar: Character) -> String {
        var chars = Array(myString.characters)     // gets an array of characters
        chars[index] = newChar
        let modifiedString = String(chars)
        return modifiedString
    }
    
    func refresh() {
        correct = false
        tries = 0
        bad_letters = [Character]()
        puzzleWord = ""
        self.viewDidLoad()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: Actions
    @IBAction func GuessLetterButton(_ sender: UIButton) {
        if !correct {
            print("Button pressed.")
            sender.isHidden = true
            var c = 0
            if let letter = guessTextField.text {
                print(letter)
            }
            else {
                print("bad")
            }
            if (tries < 6) {
                if let letter = guessTextField.text
                {
                    let l: Character = letter.characters.first!
                    let count = letter.characters.count
                    if count == 1
                    {
                        var j = 0
                        while j < word_array.count
                        {
                            if l == word_array[j]
                            {
                                print("Guessed letter(s) correct. Show correct letter(s) in label.")
                                puzzleWord = replace(myString: puzzleWord, j, l)
                                c += 1
                            }
                            j += 1
                        }
                        if c != 0 {
                            puzzelWordLabel.text = puzzleWord
                            if puzzleWord == word {
                                correct = true
                                //display some popup message saying you won!
                                print("You win.")
                                let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                            
                                let alert = UIAlertController(title: "You Win!", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                                alert.addAction(UIAlertAction(title: "Start Over", style: .default, handler: {(action: UIAlertAction!) in
                                rootViewController.dismiss(animated: true, completion: nil)
                                print("win game")
                                }))
                                rootViewController.present(alert, animated: true, completion: nil)
                                self.refresh()
                            }
                        }
                        else {
                            if bad_letters.contains(l) {
                                print("you already picked this value before")
                            }
                            else {
                                bad_letters.append(l)
                                bad_letters.append(" ")
                                wrongLettersLabel.text = String(bad_letters)
                                tries += 1
                                HangmanStatusImage.image = hangman_imgs[tries]
                            }
                        }
                    }
                }
                else
                {
                    print("error. Nothing was entered in text field.")
                }
            }
            else {
                //display some popup message saying you lost.
                print("You Lose. Try Again")
                let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
            
                let alert = UIAlertController(title: "Game Over. Try Again.", message: nil, preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Start Over", style: .default, handler: {(action: UIAlertAction!) in
                rootViewController.dismiss(animated: true, completion: nil)
                print("restart game")
                self.refresh()
                }))
                rootViewController.present(alert, animated: true, completion: nil)
            }
        }
        else
        {
            print("you already won. Start a new game")
        }

    }
}
