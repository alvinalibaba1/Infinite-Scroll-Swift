//
//  ViewController.swift
//  MyBooks
//
//  Created by temp on 23/01/23.
//

import UIScrollView_InfiniteScroll
import UIKit

final class ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{

    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let sercive = APICaller.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTable()
        fetchData()
    }

    
    private func fetchData() {
        sercive.fetchData { [weak self] in
            DispatchQueue.main.async {
                self?.table.reloadData()
            }
        }
        
        table.infiniteScrollDirection = .vertical
        table.addInfiniteScroll { [weak self] table in
            //FETCH MORE DATA
            self?.sercive.loadMorePost(completion: { [weak self] moreData in
                DispatchQueue.main.async {
                    print(moreData)
                    let startIndex = Int(moreData.first!.components(separatedBy: " ").last!)!
                    let start = startIndex-1
                    let end = start + moreData.count
                    print(start)
                    print(end)
                    let indices = Array(start..<end).compactMap({
                        return IndexPath(row: $0, section: 0)
                    })
                    self?.table.insertRows(at: indices, with: .automatic)
                    table.finishInfiniteScroll()
                }
            })
            //ADD CELLS ACCORDINGLY
            
            //FINIS
            //table.finishInfiniteScroll()
        }
    }
    
    private func setUpTable() {
        view.addSubview(table)
        table.delegate = self
        table.dataSource = self
        
        NSLayoutConstraint.activate([
            table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }

  

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sercive.models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let models = sercive.models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = models
        return cell
    }


}

