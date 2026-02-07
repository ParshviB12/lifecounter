//
//  Player.swift
//  lifecounter
//
//  Created by Parshvi Balu on 2/6/26.
//

import UIKit

class PlayerCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var lifeLabel: UILabel!

    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!

    @IBOutlet weak var chunkField: UITextField!
    @IBOutlet weak var plusChunkButton: UIButton!
    @IBOutlet weak var minusChunkButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        chunkField.keyboardType = .numberPad
    }
}

