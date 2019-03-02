//
//  DetailTableViewCell.swift
//  inspirio
//
//  Created by woo song on 2/2/19.
//  Copyright © 2019 Woo Song. All rights reserved.
//

import UIKit
import AVFoundation

class DetailTableViewCell: UITableViewCell {

    @IBOutlet weak var picItem: UIImageView!
    @IBOutlet weak var noteItem: UITextView!
    @IBOutlet weak var noteItemHC: NSLayoutConstraint!
    @IBOutlet weak var starButton: UIButton!
    
    var audioPlayerObj = AVAudioPlayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let starButtonSound = Bundle.main.path(forResource: "star_button_sound_short", ofType: "mp3")
        do {
            audioPlayerObj = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: starButtonSound!))
            audioPlayerObj.prepareToPlay()
        }catch {
            print(error)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func starToggle(_ sender: Any) {
        if starButton.tintColor == UIColor.white {
            starButton.tintColor = UIColor.init(named: "starInactiveColor")
        }else{
            starButton.tintColor = UIColor.white
        }
        
        audioPlayerObj.play()
    }
}
