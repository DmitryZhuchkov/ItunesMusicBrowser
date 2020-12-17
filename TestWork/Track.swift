//
//  Track.swift
//  TestWork
//
//  Created by Дмитрий Жучков on 14.12.2020.
//

import Foundation

class Track {
    
    var trackName: String
    var trackNumber: Int
    var previewUrl:String
    
    init(trackName: String, trackNumber: Int,previewUrl:String) {
        self.trackName = trackName
        self.trackNumber = trackNumber
        self.previewUrl = previewUrl
    }
    
}
