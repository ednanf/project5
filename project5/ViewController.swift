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
        
        // Checks, unwraps and adds to the array all start.txt contents.
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {        // First, we locate the .txt file.
            if let startWords = try? String(contentsOf: startWordsURL) {                            // We use "try" to call this code, and if it fails, it returns nil.
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        if allWords.isEmpty {
            allWords = ["silkworm"]
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
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}

