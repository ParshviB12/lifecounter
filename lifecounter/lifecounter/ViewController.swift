//
//  ViewController.swift
//  lifecounter
//
//  Created by Parshvi Balu on 1/29/26.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addPlayerButton: UIButton!

    private var players: [Player] = [
        Player(name: "Player 1", life: 20),
        Player(name: "Player 2", life: 20),
        Player(name: "Player 3", life: 20),
        Player(name: "Player 4", life: 20),
    ]

    private var history: [String] = []
    private var gameStarted = false

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        // helps self-sizing if your constraints are good
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
    }

    // MARK: - Buttons

    @IBAction func addPlayerTapped(_ sender: UIButton) {
        guard !gameStarted else { return }
        guard players.count < 8 else { return }

        let newIndex = players.count + 1
        players.append(Player(name: "Player \(newIndex)", life: 20))

        if players.count >= 8 {
            addPlayerButton.isEnabled = false
        }

        tableView.reloadData()
    }

    @IBAction func resetTapped(_ sender: UIButton) {
        resetGame()
    }

    @IBAction func historyTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "ShowHistory", sender: self)
    }

    // MARK: - Table Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as? PlayerCell else {
            return UITableViewCell()
        }

        let p = players[indexPath.row]
        cell.nameLabel.text = p.name
        cell.lifeLabel.text = "\(p.life)"

        // default chunk if empty
        if (cell.chunkField.text ?? "").isEmpty {
            cell.chunkField.text = "5"
        }

        // tag buttons with the row index
        cell.plusButton.tag = indexPath.row
        cell.minusButton.tag = indexPath.row
        cell.plusChunkButton.tag = indexPath.row
        cell.minusChunkButton.tag = indexPath.row

        // remove old targets (prevents duplicate firing when cells reuse)
        cell.plusButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.minusButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.plusChunkButton.removeTarget(nil, action: nil, for: .allEvents)
        cell.minusChunkButton.removeTarget(nil, action: nil, for: .allEvents)

        // add targets
        cell.plusButton.addTarget(self, action: #selector(plusTapped(_:)), for: .touchUpInside)
        cell.minusButton.addTarget(self, action: #selector(minusTapped(_:)), for: .touchUpInside)
        cell.plusChunkButton.addTarget(self, action: #selector(plusChunkTapped(_:)), for: .touchUpInside)
        cell.minusChunkButton.addTarget(self, action: #selector(minusChunkTapped(_:)), for: .touchUpInside)

        return cell
    }

    // MARK: - Rename player (BONUS)
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        promptRename(playerIndex: indexPath.row)
    }

    // MARK: - Button Handlers

    @objc private func plusTapped(_ sender: UIButton) {
        applyLifeChange(playerIndex: sender.tag, delta: 1)
    }

    @objc private func minusTapped(_ sender: UIButton) {
        applyLifeChange(playerIndex: sender.tag, delta: -1)
    }

    @objc private func plusChunkTapped(_ sender: UIButton) {
        let chunk = chunkValue(forRow: sender.tag)
        applyLifeChange(playerIndex: sender.tag, delta: chunk)
    }

    @objc private func minusChunkTapped(_ sender: UIButton) {
        let chunk = chunkValue(forRow: sender.tag)
        applyLifeChange(playerIndex: sender.tag, delta: -chunk)
    }

    private func chunkValue(forRow row: Int) -> Int {
        let indexPath = IndexPath(row: row, section: 0)
        guard let cell = tableView.cellForRow(at: indexPath) as? PlayerCell else { return 5 }
        return Int(cell.chunkField.text ?? "") ?? 5
    }

    // MARK: - Core game logic + history

    private func applyLifeChange(playerIndex: Int, delta: Int) {
        guard players.indices.contains(playerIndex) else { return }

        players[playerIndex].life += delta

        if !gameStarted {
            gameStarted = true
            addPlayerButton.isEnabled = false
        }

        let name = players[playerIndex].name
        let amount = abs(delta)
        let verb = (delta < 0) ? "lost" : "gained"
        history.append("\(name) \(verb) \(amount) life.")

        tableView.reloadData()

        // BONUS: game over when only one alive remains
        if aliveCount() <= 1 {
            showGameOverAndReset()
        }
    }

    private func aliveCount() -> Int {
        return players.filter { $0.life > 0 }.count
    }

    private func showGameOverAndReset() {
        let alert = UIAlertController(title: "Game over!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.resetGame()
        })
        present(alert, animated: true)
    }

    private func resetGame() {
        players = [
            Player(name: "Player 1", life: 20),
            Player(name: "Player 2", life: 20),
            Player(name: "Player 3", life: 20),
            Player(name: "Player 4", life: 20),
        ]
        history.removeAll()
        gameStarted = false
        addPlayerButton.isEnabled = true
        tableView.reloadData()
    }

    // MARK: - BONUS rename prompt

    private func promptRename(playerIndex: Int) {
        let alert = UIAlertController(title: "Rename Player", message: nil, preferredStyle: .alert)
        alert.addTextField { tf in
            tf.text = self.players[playerIndex].name
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Save", style: .default) { _ in
            let newName = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            if !newName.isEmpty {
                self.players[playerIndex].name = newName
                self.tableView.reloadData()
            }
        })
        present(alert, animated: true)
    }

    // MARK: - Segue to History

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowHistory",
           let dest = segue.destination as? HistoryViewController {
            dest.history = history
        }
    }

}




