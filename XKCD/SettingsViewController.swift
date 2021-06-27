//
//  SettingsViewController.swift
//  XKCD
//
//  Created by Aritro Paul on 6/27/21.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func viewRepoTapped(_ sender: Any) {
        if let url = URL(string: "https://github.com/aritropaul/xkcd-app") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
    
    @IBAction func BMCTapped(_ sender: Any) {
        if let url = URL(string: "https://www.buymeacoffee.com/aritropaul") {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
    }
}
