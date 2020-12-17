//
//  TrackCell.swift
//  TestWork
//
//  Created by Дмитрий Жучков on 15.12.2020.
//

import UIKit

class TrackCell: UITableViewCell {
    
    @IBOutlet weak var trackNumber: UILabel!
    @IBOutlet weak var trackName: UILabel!
    var previewUrl:String!
    func updateCell (track: Track) {
        trackNumber.text = String(track.trackNumber)
        trackName.text = track.trackName
        previewUrl = String(track.previewUrl)
    }
    
}
