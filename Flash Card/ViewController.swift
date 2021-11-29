//
//  ViewController.swift
//  Flash Card
//
//  Created by Jacob Nguyen on 2/13/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var backLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var card: UIView!
    
    
    
    var flashcards = [Flashcard]()
    var currentIndex = 0
    
    
    struct Flashcard {
        var question: String
        var answer: String
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        frontLabel.layer.cornerRadius = 20
        
        readSavedFlashcards()
        
        if flashcards.count == 0 {
            updateFlashcard(question: "What's the capital of Brazil", answer: "Brasilia")
        } else {
            updateLabels()
            updateNextPrevButtons()
        }
    }
    
    @IBAction func didTapFlashCard(_ sender: Any) {
        UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {
            self.flipFlashCard()
        })
    }
    
    func flipFlashCard() {
        if frontLabel.isHidden {
            frontLabel.isHidden = false
        } else {
            frontLabel.isHidden = true
        }
    }
    
    func animateCardOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: -300.0, y: 0.0)
        }, completion: { finished in
            self.updateLabels()
            self.animateCardIn()
        })
    }
    
    func animateCardIn() {
        card.transform = CGAffineTransform.identity.translatedBy(x: 300.0, y: 0.0)
        UIView.animate(withDuration: 0.3) {
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex -= 1
        updateLabels()
        updateNextPrevButtons()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex += 1
        updateLabels()
        updateNextPrevButtons()
        animateCardOut()
    }
    
    func updateNextPrevButtons() {
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
        
        if currentIndex == 0 {
            prevButton.isEnabled = false
        } else {
            prevButton.isEnabled = true
        }
    }
    
    func updateLabels() {
        let currentFlashcard = flashcards[currentIndex]
        frontLabel.text = currentFlashcard.question
        backLabel.text = currentFlashcard.answer
    }
    
    func updateFlashcard(question: String, answer: String) {
        let flashcard = Flashcard(question: question, answer: answer)
        frontLabel.text = flashcard.question
        backLabel.text = flashcard.answer
        flashcards.append(flashcard)
        currentIndex = flashcards.count - 1
        print("Added new flashcard 🃏")
        print("We now have \(flashcards.count) flashcards")
        print("Current Index is \(currentIndex)")
        updateNextPrevButtons()
        saveAllCardsToDisk()
    }
    
    func saveAllCardsToDisk(){
        let dictionaryArray = flashcards.map{(card) -> [String:String] in
            return["question": card.question, "answer": card.answer]
        }
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
    }
    
    func readSavedFlashcards(){
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String:String]]{
            let savedCards = dictionaryArray.map { dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: savedCards)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        
        let creationController = navigationController.topViewController as! CreationViewController
        
        creationController.flashcardsController = self
    }
   

}

