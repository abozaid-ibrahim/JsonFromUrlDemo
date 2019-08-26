//
//  ViewController.swift
//  DataFromUrl
//
//  Created by abuzeid on 8/26/19.
//  Copyright © 2019 abuzeid. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet private var tableView: UITableView!
    private let cellId = "LanguageCell"
    ///
    var languagesList: [LanguageModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        /// static data
        getDataFromServer()
    }

    func getDataFromServer() {
        let url = URL(string: "https://restcountries.eu/rest/v2/lang/es")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let error = error {
                print(error)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                print(response)
                /// self.handleServerError(response)
                return
            }
            if let data = data {
                let string = String(data: data, encoding: .utf8)
                do {
                    let jsonDecoder = JSONDecoder()
                    let jsonData = try jsonDecoder.decode([LanguageModel].self, from: data)
                    self.languagesList = jsonData
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch {
                    print(error)
                }
            }
        }
        task.resume()
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languagesList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId) as! LanguageCell
        cell.titleLbl.text = languagesList[indexPath.row].name
        return cell
    }
}

class LanguageCell: UITableViewCell {
    @IBOutlet var titleLbl: UILabel!
}

struct LanguageModel: Codable {
    var name: String
    var topLevelDomain: [String]
    let alpha2Code: String
}
