import UIKit

struct CovidData: Codable {
    var covidCountryDetails: All
    
    enum CodingKeys: String, CodingKey {
        case covidCountryDetails = "All"
    }
}

struct All: Codable {
    var confirmed: Int
    var deaths: Int
    var country: String
    var population: Int
    var capitalCity: String
    var continent: String
    var location: String
    var abbreviation: String
    var lat: String?
    var long: String?
    var updated: String?
    
    enum CodingKeys: String, CodingKey {
        case confirmed, deaths, country, population, continent, location, abbreviation, lat, long, updated
        case capitalCity = "capital_city"
    }
}
