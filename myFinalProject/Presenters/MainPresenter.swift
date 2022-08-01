
import Foundation
import UIKit

class MainPresenter {
    
    var networkingManager = NetworkingManager()
    
    init(networkingManager: NetworkingManager) {
        self.networkingManager = networkingManager
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    weak var viewDelegate: MainViewDelegate?
    
    func getData(endpoind: API) {
        networkingManager.request(endpoint: endpoind) { (result: Result<CovidData, NetworkingError>) in
            switch result {
            case .success(let loadedData):
                self.viewDelegate?.updateUI(with: loadedData)
            case .failure(let error):
                print(result)
                self.viewDelegate?.showAlert(title: error.localizedDescription)
            }
        }
    }
    
    func getDataForTableView(endpoind: API) {
        networkingManager.request(endpoint: endpoind) { (result: Result<CovidData, NetworkingError>) in
            switch result {
            case .success(let loadedData):
                self.viewDelegate?.fillTableView(with: loadedData)
            case .failure(let error):
                print(result)
                self.viewDelegate?.showAlert(title: error.localizedDescription)
            }
        }
    }
}
