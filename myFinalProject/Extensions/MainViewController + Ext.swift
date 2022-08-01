import Foundation
import UIKit

extension MainViewController: MainViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITableViewDataSource, UITableViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return CovidAPI.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return CovidAPI.allCases[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {

        chooseCountryTextField.text = CovidAPI.allCases[row].rawValue
        chooseCountryTextField.resignFirstResponder()
        presenter.getData(endpoind: CovidAPI.allCases[row])
        loadActivityIndicator.startAnimating()
    }
    
    func updateUI(with model: CovidData) {
        DispatchQueue.main.async {
            self.capitalLabel.text = "Capital: \n\(model.covidCountryDetails.capitalCity)"
            self.populationLabel.text = "Population: \n\(model.covidCountryDetails.population)"
            self.confirmedLabel.text = "Confirmed cases: \n\(model.covidCountryDetails.confirmed)"
            self.deathsLabel.text = "Deaths: \n\(model.covidCountryDetails.deaths)"
            self.countries = [model]
            self.loadActivityIndicator.stopAnimating()
        }
    }
    
    func fillTableView(with model: CovidData) {
        DispatchQueue.main.async {
            self.countries = [model]
            self.loadActivityIndicator.stopAnimating()
        }
    }
    
    func showAlert(title: String) {
        DispatchQueue.main.async {
        let alert = UIAlertController(title: "Something went wrong", message: "Check internet connection or try again later", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in return }
        
            alert.addAction(okAction)
            self.present(alert, animated: true)
            self.loadActivityIndicator.stopAnimating()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as? CustomCell else { return UITableViewCell()}
        let country = countries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.frame.height + 10
    }
}
