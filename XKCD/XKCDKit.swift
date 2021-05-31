//
//  XKCDKit.swift
//  XKCD
//
//  Created by Aritro Paul on 30/05/21.
//

import Foundation

protocol ComicDelegate: AnyObject {
    func didGetComic(comic: Comic)
    func didFail(error: Error)
}

class XKCD {
    
    static let shared = XKCD()
    weak var delegate: ComicDelegate?
    
    static var host = "https://xkcd.com"
    static var info = "/info.0.json"
    
    static var latest = -1
    
    func getLatest() {
        let url = URL(string: XKCD.host + XKCD.info)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                self.delegate?.didFail(error: error!)
                return
            }
            do {
                let comic = try JSONDecoder().decode(Comic.self, from: data)
                XKCD.latest = comic.num
                self.delegate?.didGetComic(comic: comic)
            }
            catch(let error) {
                self.delegate?.didFail(error: error)
            }
        }
        task.resume()   
    }
    
    
    func getComic(withID id: Int) {
        let url = URL(string: XKCD.host + "/\(id)" + XKCD.info)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, _, error in
            guard let data = data else {
                self.delegate?.didFail(error: error!)
                return
            }
            do {
                let comic = try JSONDecoder().decode(Comic.self, from: data)
                self.delegate?.didGetComic(comic: comic)
            }
            catch(let error) {
                self.delegate?.didFail(error: error)
            }
        }
        task.resume()
    }
    
    func getRandom() {
        if XKCD.latest > 1 {
            let random = Int.random(in: 1..<XKCD.latest)
            let url = URL(string: XKCD.host + "/\(random)" + XKCD.info)!
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, _, error in
                guard let data = data else {
                    self.delegate?.didFail(error: error!)
                    return
                }
                do {
                    let comic = try JSONDecoder().decode(Comic.self, from: data)
                    self.delegate?.didGetComic(comic: comic)
                }
                catch(let error) {
                    self.delegate?.didFail(error: error)
                }
            }
            task.resume()
        }
        else {
            self.delegate?.didFail(error: NSError(domain: "Whoops", code: -1, userInfo: ["desc" : "Obtain latest first"]))
        }
        
    }
    
}
