//
//  StoriesTableViewController.swift
//  Wattpad Assessment
//
//  Created by Saim Zahid on 2019-11-13.
//

import UIKit
import Alamofire

class StoriesTableViewController: UITableViewController {
    private let operations = ImageDownloadOperations()
    private var viewModel: StoriesViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = StoriesViewModel(delegate: self)
        viewModel.fetchStories()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.storiesCount
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 218.0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! StoryTableViewCell
        
        let story = viewModel.story(at: indexPath.row)
        cell.configure(with: story)
        
        if story.shouldDownloadImage {
            startDownloadOperation(for: story, at: indexPath)
        }
        
        return cell
    }
    
    private func startDownloadOperation(for story: StoryViewModelProtocol, at indexPath: IndexPath) {
        guard operations.downloadsInProgress[indexPath] == nil else { return }

        let downloadOperation = DownloadOperation(story)

        downloadOperation.completionBlock = {
            if downloadOperation.isCancelled { return }

            DispatchQueue.main.async {
                self.operations.downloadsInProgress.removeValue(forKey: indexPath)
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }

        operations.downloadsInProgress[indexPath] = downloadOperation
        operations.operationQueue.addOperation(downloadOperation)
    }
}

extension StoriesTableViewController: StoriesViewModelDelegate {
    func fetchComplete() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func showAlert() {
        DispatchQueue.main.async {
            let alert = StoriesPersistedAlert().getAlert()
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    func fetchFailed(_ error: AFError) {
        print("Error: \(error)")
    }
}
