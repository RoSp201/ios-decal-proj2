//
//  GameViewController.swift
//  Hangman
//
//  Created by Shawn D'Souza on 3/3/16.
//  Modified by Robert Spark on 11/5/16.
//  Copyright © 2016 Shawn D'Souza. All rights reserved.
//  Copyright © 2016 Robert Spark. All rights reserved.

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
    var c = 0
    var hangman_imgs = [UIImage]()
    var word = ""
    var word_array = [Character]()
    var bad_letters = [Character]()
    var buttons_pushed = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let hangmanPhrases = HangmanPhrases()
        let phrase = hangmanPhrases.getRandomPhrase()
        
        word = (phrase)! // to make comparisons easier
        word = word.uppercased()
        word_array = Array(word.characters)
        for i in 0..<word_array.count {
            if word_array[i] == " " {
                puzzleWord.append(" ")
                c += 1
            }
            else
            {
                puzzleWord.append("₋")
            }
        }
        print(String(describing: phrase))
        print(String(c))
        print(word_array.count)
        for i in (1...7) {
            hangman_imgs.append(UIImage(named: "hangman" + String(i) + ".gif")!)
        }
        HangmanStatusImage.image = hangman_imgs[0]
        puzzelWordLabel.text = String(puzzleWord)
        wrongLettersLabel.text = String("")
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "hangman_background.jpeg")
        self.view.insertSubview(backgroundImage, at: 0)
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
        c = 0
        bad_letters = [Character]()
        puzzleWord = ""
        for i in 0..<buttons_pushed.count {
            buttons_pushed[i].isEnabled = true
            buttons_pushed[i].backgroundColor = UIColor.cyan
        }
        self.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func startOverButton(_ sender: UIBarButtonItem) {
        print("New game navigation button pressed.")
        self.refresh()
    
    }
    @IBAction func GuessLetterButton(_ sender: UIButton) {
        if !correct {
            var counter = 0
            if let letter = sender.titleLabel?.text {
                print(letter + " pressed")
            }
            if (tries < 6)
            {
                if let letter = sender.titleLabel?.text
                {
                    buttons_pushed.append(sender)
                    sender.isEnabled = false
                    sender.backgroundColor = UIColor.darkGray
                    let l: Character = letter.characters.first!
                    
                    var j = 0
                    while j < word_array.count
                    {
                        if l == word_array[j]
                        {
                            print("Guessed letter(s) correct. Show correct letter(s) in label.")
                            puzzleWord = replace(myString: puzzleWord, j, l)
                            counter += 1
                            c += 1
                            print("letter "+String(counter) + " found")
                        }
                        j += 1
                    }
                    if counter != 0 {
                        puzzelWordLabel.text = puzzleWord
                        if c == word.characters.count
                        {
                            //display some popup message saying you won!
                            correct = true
                            print("You win.")
                            let rootViewController: UIViewController = UIApplication.shared.windows[0].rootViewController!
                            
                            let alert = UIAlertController(title: "You Win!\n The phrase was: \n"+word, message: nil, preferredStyle: UIAlertControllerStyle.alert)
                            alert.addAction(UIAlertAction(title: "Start Over", style: .default, handler: {(action: UIAlertAction!) in
                            rootViewController.dismiss(animated: true, completion: nil)
                            print("win game")
                            }))
                            rootViewController.present(alert, animated: true, completion: nil)
                            self.refresh()
                        }
                    }
                    else
                    {
                        bad_letters.append(l)
                        bad_letters.append(" ")
                        wrongLettersLabel.text = String(bad_letters)
                        wrongLettersLabel.textColor = UIColor.red
                        tries += 1
                        HangmanStatusImage.image = hangman_imgs[tries]
                        if tries >= 6
                        {
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
                }
            }
        }
    }
}
