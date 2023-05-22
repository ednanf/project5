//
//  ViewController.swift
//  project5
//
//  Created by Ednan R. Frizzera Filho on 19/05/23.
//

import UIKit

class ViewController: UITableViewController {

// MARK: - Properties
    
    var allWords: [String] = []
    var usedWords: [String] = []
    
// MARK: - Setup
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        
        // Checks, unwraps and adds to the array all start.txt contents.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {        // First we set the path of start.txt.
            if let startWords = try? String(contentsOf: startWordsURL) {                            // Then, we use "try" to call this code, and if it fails, it returns nil.
                allWords = startWords.components(separatedBy: "\n")                                 // Lastly, we add the words (which are separated by \n in start.txt) to the array.
            }
        }
        
        if allWords.isEmpty {                                                                       // If the array is empty,
            allWords = ["silkworm"]                                                                 // We use a word to know that.
        }
        
        startGame()
    }

// MARK: - Functions
    
    // Selects a new random word
    func startGame() {
        title = allWords.randomElement()                        // Sets the view controller's title to be a random word in the array.
        usedWords.removeAll(keepingCapacity: true)              // Removes all values from usedWords.
        tableView.reloadData()                                  // Calls numberOfRowsInSection and cellForRowAt repeatedly.
    }
    
    // Sets the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    // Sets the cell's content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)                  // The "Word" identifier that was set in the Interface Builder.
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // Answer prompt
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)           // First, we create an alert controller,
        ac.addTextField()                                                                                 // Then, a text field was added to the alert controller.

        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in                                                                // "action in" means it accepts 1 parameter, of type UIAlertAction.
            guard let answer = ac?.textFields?[0].text else { return }                                    // Declares a constant with the value of the text field created above.
            self?.submit(answer: answer)                                                                  // Execute the function with the parameter set to the constant created.
        }

        ac.addAction(submitAction)                                                                        // Adds an action to the alert controller.
        present(ac, animated: true)                                                                       // Presents the alert.
    }
    
    // Checks the validity of answers.
    func submit(answer: String) {
        let lowerAnswer = answer.lowercased()                                   // First we make a lowercased string to easily evaluate.

        if isPossible(word: lowerAnswer) {                                      // Then we pass through a nested statement. All conditions must be true to execute the code.
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    usedWords.insert(answer, at: 0)                             // If all conditions are true, insert the string in usedWords at index 0.
                    
                    let indexPath = IndexPath(row: 0, section: 0)               // Inserts a new row in the table view.
                    tableView.insertRows(at: [indexPath], with: .automatic)     // The row number matches the IndexPath above, position 0 in this case.

                    return
                } else {                                                        // Error message if the word is not real.
                    // ***CHALLENGE 2***
                    showErrorMessage("You can't just make them up, you know!", withTitle: "Word not recognised!")
                }
            } else {                                                            // Error message if the word is repeated.
                // ***CHALLENGE 2***
                showErrorMessage("Be more original!", withTitle: "Word used already!")
            }
        } else {                                                                // Error message if the word is not possible
            // ***CHALLENGE 2***
            showErrorMessage("You can't spell that word from \(title ?? "SHIT! IT'S BROKEN!")", withTitle: "Word not possible!")
        }
    }
    

    
    // Checks if the word is possible.
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
                                                                            // This loop ensures each letter in the word can only be used once.
        for letter in word {                                                // Loops through every letter in the word
                if let position = tempWord.firstIndex(of: letter) {         // If there's a match for the letter,
                    tempWord.remove(at: position)                           // remove it.
                } else {
                    return false
                }
            }

            return true
    }
    
    // Checks if the word was guessed previously.
    func isOriginal(word: String) -> Bool {
        // ***CHALLENGE 1*** - part 2: disallow entering the same word as the title.
        guard word != title else { return false }
        
        return !usedWords.contains(word)        // ATTENTION: !usedWords is necessary. It means userWords **does not** contain word.
    }
    
    // Checks if the word is real.
    func isReal(word: String) -> Bool {
        // ***CHALLENGE 1*** - part 1: disallow words shorter than 3 words.
        guard word.count > 3 else { return false }
        
        let checker = UITextChecker()                                       // iOS class designed to spot spelling errors.
            let range = NSRange(location: 0, length: word.utf16.count)      // Stores a string range. ATTENTION: user utf16.count when working with UIKit, SpriteKit or any other Apple framework!
            let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

            return misspelledRange.location == NSNotFound                   // Tells the word is spelled correctly. This will return either true or false.
    }

    // ***CHALLENGE 2***: Refactor the else statements using a function to show the error message
    func showErrorMessage(_ errorMessage: String, withTitle errorTitle: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
}

