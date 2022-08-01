import Foundation

enum CovidAPI: String, CaseIterable, API {
    case Albania
    case Andorra
    case Austria
    case Belarus
    case Belgium
    case BosniaAndHerzegovina = "Bosnia and Herzegovina"
    case Bulgaria
    case Croatia
    case Czechia
    case Denmark
    case Estonia
    case Finland
    case France
    case Germany
    case Greece
    case HolySee = "Holy See"
    case Hungary
    case Iceland
    case Ireland
    case Italy
    case Latvia
    case Liechtenstein
    case Lithuania
    case Luxembourg
    case Malta
    case Moldova
    case Monaco
    case Netherlands
    case NorthMacedonia = "North Macedonia"
    case Norway
    case Poland
    case Portugal
    case Romania
    case Russia
    case SanMarino = "San Marino"
    case Slovakia
    case Slovenia
    case Spain
    case Sweden
    case Switzerland
    case Ukraine
    case UnitedKingdom = "United Kingdom"
    
    var scheme: HTTPScheme {
            return .https
    }
    
    var method: HTTPMethod {
            return .get
    }
    
    var baseURL: String {
            return "covid-api.mmediagroup.fr"
    }
    
    var path: String {
            return "/v1/cases"
    }
    
    var queryItem: URLQueryItem {
        return URLQueryItem(name: "country", value: "\(self.rawValue)")
    }
}
