//
//  Service.swift
//  TestWork
//
//  Created by Дмитрий Жучков on 14.12.2020.
//

import Foundation

let BASE_URL = "https://itunes.apple.com/search?entity=album&attribute=albumTerm&offset=0&limit=100&term="
let ALBUM_SONGS_URL = "https://itunes.apple.com/lookup?entity=song&id="
class DataService {
    
    static let service = DataService()
    // Получение списка альбомов
    func getAlbums (searchRequest: String, complition: @escaping ([Album])->()) {
        var albums = [Album]()
        let searchString = searchRequest.replacingOccurrences(of: " ", with: "+")
        let url = URL(string: "\(BASE_URL)\(searchString)")
        let session = URLSession.shared
        // Оператор  ?? для того, чтобы не вылетало при ненахождении альбома состоящий из русских букв
        session.dataTask(with: url ?? URL(string:(BASE_URL+"AVVCCWWQQ"))!) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let albumsResults = json["results"] as? NSArray {
                        for album in albumsResults {
                            if let albumInfo = album as? [String: AnyObject] {
                                guard let artistName = albumInfo["artistName"] as? String else {return}
                                guard let artworkUrl100 = albumInfo["artworkUrl100"] as? String else {return}
                                guard let collectionId = albumInfo["collectionId"] as? Int else {return}
                                guard let collectionName = albumInfo["collectionName"] as? String else {return}
                                guard let country = albumInfo["country"] as? String else {return}
                                guard let primaryGenreName = albumInfo["primaryGenreName"] as? String else {return}
                                guard let releaseDate = albumInfo["releaseDate"] as? String else {return}
                                let releaseDateFormatted = releaseDate.prefix(4)
                                let albumInstance = Album(artistName: artistName, artworkUrl100: artworkUrl100, collectionId: collectionId, collectionName: collectionName, country: country, primaryGenreName: primaryGenreName, releaseDate: String(releaseDateFormatted))
                                albums.append(albumInstance)
                            }
                        }
                        complition(albums)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            if error != nil {
                print(error!.localizedDescription)
                
            }
        }.resume()
    }
// Получения списка песен
    func getAlbumTracks (collectionId: Int, complition: @escaping ([Track]) -> ()) {
        var tracks = [Track]()
        let url = URL(string: "\(ALBUM_SONGS_URL)\(collectionId)")
        let session = URLSession.shared
        session.dataTask(with: url!) { (data, response, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    if let trackResults = json["results"] as? NSArray {
                        for song in trackResults {
                            if trackResults.index(of: song) != 0 {
                                if let songInfo = song as? [String: AnyObject] {
                                    guard let trackName = songInfo["trackName"] as? String else {return}
                                    guard let trackNumber = songInfo["trackNumber"] as? Int else {return}
                                    guard let previewUrl = songInfo["previewUrl"] as? String else {return}
                                    let track = Track(trackName: trackName, trackNumber: trackNumber, previewUrl: previewUrl)
                                    tracks.append(track)
                                }
                            }
                        }
                        complition(tracks)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            if error != nil {
                print(error!.localizedDescription)
            }
        }.resume()
    }
    
}
