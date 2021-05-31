//
//  XKCDViewController.swift
//  XKCD
//
//  Created by Aritro Paul on 31/05/21.
//

import UIKit
import SafariServices

class XKCDViewController: UITableViewController {

    @IBOutlet weak var BLMButton: UIButton!
    @IBOutlet weak var comicView: UIImageView!
    @IBOutlet weak var altLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var lastButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var forwButton: UIButton!
    @IBOutlet weak var firstButton: UIButton!
    
    var currentComic = -1
    var comic: Comic?
    var height: CGFloat = 300.0
    
    var alert: UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        XKCD.shared.getLatest()
        XKCD.shared.delegate = self
        alert = UIAlertController(title: "Loading", message: "Getting the comic", preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    @IBAction func prevTapped(_ sender: Any) {
        if currentComic > 1 {
            XKCD.shared.getComic(withID: currentComic - 1)
            alert = UIAlertController(title: "Loading", message: "Getting the comic", preferredStyle: .alert)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func lastTapped(_ sender: Any) {
        XKCD.shared.getComic(withID: 1)
        alert = UIAlertController(title: "Loading", message: "Getting the comic", preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    @IBAction func randomTapped(_ sender: Any) {
        XKCD.shared.getRandom()
        alert = UIAlertController(title: "Loading", message: "Getting the comic", preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    @IBAction func forwTapped(_ sender: Any) {
        if currentComic < XKCD.latest {
            XKCD.shared.getComic(withID: currentComic + 1)
            alert = UIAlertController(title: "Loading", message: "Getting the comic", preferredStyle: .alert)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func firstTapped(_ sender: Any) {
        XKCD.shared.getComic(withID: XKCD.latest)
        alert = UIAlertController(title: "Loading", message: "Getting the comic", preferredStyle: .alert)
        self.present(alert, animated: true)
    }
    
    @IBAction func settingsTapped(_ sender: Any) {
        
        
    }
    
    @IBAction func BLMTapped(_ sender: Any) {
        if let url = URL(string: "https://www.blacklivesmatter.com") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @IBAction func explainTapped(_ sender: Any) {
        if let url = URL(string: "https://www.explainxkcd.com/wiki/index.php/\(currentComic)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        
        let image = comicView.image
        let text = comic?.alt
        let activityViewController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        if let url = URL(string: "https://www.xkcd.com/\(currentComic)") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2: return height
        case 3: return UITableView.automaticDimension
        case 4: return 80
        default:
            return 60
        }
    }
    
}

extension XKCDViewController : ComicDelegate {
    
    func didGetComic(comic: Comic) {
        print(comic)
        self.comic = comic
        DispatchQueue.main.async {
            self.alert.dismiss(animated: true) {
                self.comicView.downloaded(from: comic.img)
                self.height = getDim(urlString: comic.img).1
                print(self.height)
                self.altLabel.text = comic.alt
                self.titleLabel.text = comic.title
                self.currentComic = comic.num
                print(self.currentComic)
                self.tableView.reloadData()
            }
        }
        
    }
    
    func didFail(error: Error) {
        print(error.localizedDescription)
    }
    
}
