import Foundation

struct WeatherData: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let description: String
}
