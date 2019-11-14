import UIKit


class StoriesPersistedAlert {
    func getAlert() -> UIAlertController {
        let alert = UIAlertController(title: "Stories Saved!", message: "These stories can now be accessed offline", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        return alert
    }
}
