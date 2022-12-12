import UIKit
import Kingfisher

extension UIImageView {
    
    func setImage(with urlString: String) {
        
        guard let url = URL.init(string: urlString) else {
            return
        }
        let resource = ImageResource(downloadURL: url, cacheKey: urlString)
        self.kf.setImage(with: resource, placeholder: UIImage(named: "Avatar"))
    }
}
