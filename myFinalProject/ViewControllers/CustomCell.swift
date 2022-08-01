import UIKit

class CustomCell: UITableViewCell {
    
    var name = UILabel()
    var capital = UILabel()
    var continent = UILabel()
    var location = UILabel()
    var abbreviation = UILabel()
    var lat = UILabel()
    var updated = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with CovidData: CovidData) {
        name.text = "Country - \(CovidData.covidCountryDetails.country)"
        capital.text = "Capital city - \(CovidData.covidCountryDetails.capitalCity)"
        continent.text = "Location - \(CovidData.covidCountryDetails.continent) continent"
        location.text = "Detailed location - \(CovidData.covidCountryDetails.location)"
        abbreviation.text = "Country abbreviation is - \(CovidData.covidCountryDetails.abbreviation)"
        lat.text = "Coordinates - \(CovidData.covidCountryDetails.lat ?? "undefined") lat and \(CovidData.covidCountryDetails.long ?? "undefined") long"
        updated.text = "Last update - \(CovidData.covidCountryDetails.updated ?? "undefined")"
        
        [name, capital, continent, location, abbreviation, lat, updated].forEach {
            $0.textColor = .black
            $0.textAlignment = .left
            $0.backgroundColor = .white
        }
    }
    
    private func setUpLayout() {
        contentView.backgroundColor = .white
        
        [name, capital, continent, location, abbreviation, lat, updated].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([
                $0.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                $0.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                $0.heightAnchor.constraint(equalToConstant: 50)
            ])
        }
        
        NSLayoutConstraint.activate([
            name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            capital.topAnchor.constraint(equalTo: name.bottomAnchor),
            continent.topAnchor.constraint(equalTo: capital.bottomAnchor),
            location.topAnchor.constraint(equalTo: continent.bottomAnchor),
            abbreviation.topAnchor.constraint(equalTo: location.bottomAnchor),
            lat.topAnchor.constraint(equalTo: abbreviation.bottomAnchor),
            updated.topAnchor.constraint(equalTo: lat.bottomAnchor)
        ])
    }
}
