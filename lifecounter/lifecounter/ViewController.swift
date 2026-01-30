//
//  ViewController.swift
//  lifecounter
//
//  Created by Parshvi Balu on 1/29/26.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var player1LifeLabel: UILabel!
    @IBOutlet weak var player2LifeLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    
    private var player1Life = 20
    private var player2Life = 20

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        resultLabel.text = ""
    }

    private func updateUI() {
        player1LifeLabel.text = "\(player1Life)"
        player2LifeLabel.text = "\(player2Life)"
        checkForLoser()
    }

    private func checkForLoser() {
        if player1Life <= 0 {
            resultLabel.text = "Player 1 LOSES!"
        } else if player2Life <= 0 {
            resultLabel.text = "Player 2 LOSES!"
        } else {
            resultLabel.text = ""
        }
    }
    @IBAction func player1ButtonTapped(_ sender: UIButton) {
        handleButtonTap(forPlayer: 1, sender: sender)
    }

    @IBAction func player2ButtonTapped(_ sender: UIButton) {
        handleButtonTap(forPlayer: 2, sender: sender)
    }
    
    private func handleButtonTap(forPlayer player: Int, sender: UIButton) {

        let title = sender.currentTitle
            ?? sender.titleLabel?.text
            ?? sender.configuration?.title
            ?? ""

        let change: Int
        switch title {
        case "+":  change = 1
        case "-":  change = -1
        case "+5": change = 5
        case "-5": change = -5
        default:
            return
        }

        if player == 1 {
            player1Life += change
        } else {
            player2Life += change
        }

        updateUI()
    }


    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//    }


}

