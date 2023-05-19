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
        title = allWords.randomElement()                    // Sets the view controller's title to be a random word in the array.
        usedWords.removeAll(keepingCapacity: true)          // Removes all values from usedWords.
        tableView.reloadData()                              // Calls numberOfRowsInSection and cellForRowAt repeatedly.
    }
    
    // Sets the number of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    // Sets the cell's content
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)        // The "Word" identifier that was set in the Interface Builder.
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // Answer prompt
    @objc func promptForAnswer() {
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)                     // First, we create an alert controller,
        ac.addTextField()                                                                                           // Then, a text field was added to the alert controller.

        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            [weak self, weak ac] action in                                                                          // "action in" means it accepts 1 parameter, of type UIAlertAction.
            guard let answer = ac?.textFields?[0].text else { return }                                              // declares a constant with the value of the text field created above.
            self?.submit(answer)
        }

        ac.addAction(submitAction)                                                                                  // Adds an action to the alert controller.
        present(ac, animated: true)                                                                                 // Presents the alert.
    }
    
    func submit(_ answer: String) {
        
    }
    
    
    
    
    
    
    
}

