import Foundation

enum NetworkingError: String, Error {
    case invalidURL = "The URL is invalid"
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidData = "The data received from the server was invalid. Please try agein"
    case invalidResponse = "Invalid responce from the server. Please try again"
}
