import UIKit
import Alamofire

class StoriesTableViewController: UITableViewController {
    private let operations = ImageDownloadOperations()
    private var viewModel: StoriesViewModelProtocol!
    var hasLoaded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = StoriesViewModel(delegate: self)
        viewModel.fetchStories(offset: "0")
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "storyCell", for: indexPath) as! StoryTableViewCell
        
        let story = viewModel.story(at: indexPath.row)
        cell.configure(with: story)
        
//        if story.shouldDownloadImage {
//            startDownloadOperation(for: story, at: indexPath)
//        }

        if indexPath.row == 9 && hasLoaded {
            hasLoaded = false
            print(viewModel.storiesCount)
            viewModel.fetchStories(offset: "\(viewModel.storiesCount)")
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
            self.hasLoaded = true
        }
    }
    
    func showOfflineUsageAlert() {
        DispatchQueue.main.async {
            let alert = StoriesPersistedAlert().getAlert()
            self.present(alert, animated: true, completion: nil)
        }
    }

    
    func fetchFailed(_ error: AFError) {
        // This is where one could show another alert informing the user the fetch has failed
        // I could also implement pull to refresh to allow the user to fetch the list again after failure
        print("Error: \(error)")
    }
}
//
//extension StoriesTableViewController: UITableViewDataSourcePrefetching {
//    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        print(indexPaths)
//        if indexPaths.contains(IndexPath(row: 8, section: 0)) {
//            print("Fetch next list")
//        }
//    }
//}
