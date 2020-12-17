//
//  DetailsViewController.swift
//  TestWork
//
//  Created by Дмитрий Жучков on 12.12.2020.
//

import UIKit
import AVFoundation
class DetailsViewController: UIViewController {
    var albums:Album!
    var image: UIImage!
    @IBOutlet weak var songsList: UITableView!
    @IBOutlet weak var DetailsText: UILabel!
    var player:AVPlayer!
    var tracks = [Track]()
    @IBOutlet weak var DetailsImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        songsList.delegate = self
        songsList.dataSource = self
        loadAlbumInformation()
        loadTracks()
    }
    
    func loadAlbumInformation () {
        DetailsImage.image = image
        DetailsText.text = "Альбом:\(albums.collectionName),\nАртист:\(albums.artistName),\nЖанр:\(albums.primaryGenreName),\nСтрана:\(albums.country),\nДата:\(albums.releaseDate)."
    }
    
    func loadTracks() {
        DataService.service.getAlbumTracks(collectionId: albums.collectionId) { (requestedTracks) in
            self.tracks = requestedTracks
            DispatchQueue.main.async {
            self.songsList.reloadData()
            }
        }
    }
    
}


extension DetailsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as? TrackCell
        cell!.updateCell(track: tracks[indexPath.row])
        return cell!
    
}
    // Проигрование превью песен, при нажатии на строчку включется 30 секундное превью
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = NSURL(string:tracks[indexPath.row].previewUrl)
        do {
            let playerItem = AVPlayerItem(url:url! as URL )
            self.player = try AVPlayer(playerItem:playerItem)
                   player!.volume = 0.5
                   player!.play()
          } catch let error as NSError {
              //self.player = nil
              print(error.localizedDescription)
          } catch {
              print("AVAudioPlayer init failed")
          }
    }
}
