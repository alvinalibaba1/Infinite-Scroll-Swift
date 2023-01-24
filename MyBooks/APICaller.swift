//
//  APICaller.swift
//  MyBooks
//
//  Created by temp on 24/01/23.
//

import Foundation


final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    public private(set) var models = [String]()
    
    func fetchData(completion: @escaping () -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+2) { [weak self] in
            self?.models = Array(1...20).map { "Book \($0)" }
            completion()
        }
    }
    
    func loadMorePost(completion: @escaping ([String]) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+2) { [weak self] in
            guard let strongSelf = self, let last = strongSelf.models.last else { return }
            let number = Int(last.components(separatedBy: " ").last!)!
            let start = number + 1
            let end = start + 20
            let newData = Array(start...end).map { "Book \($0)" }
            strongSelf.models.append(contentsOf: newData)
            completion(newData)
        }
    }
}
