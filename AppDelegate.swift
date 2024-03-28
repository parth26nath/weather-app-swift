import UIKit

class ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var weatherLabel: UILabel!

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getWeatherButtonTapped(_ sender: UIButton) {
        guard let city = cityTextField.text, !city.isEmpty else {
            showAlert(message: "Please enter a city name.")
            return
        }
        fetchWeather(city: city)
    }

    func fetchWeather(city: String) {
        let apiKey = "YOUR_API_KEY" // OpenWeatherMap API key
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            showAlert(message: "Invalid URL.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.showAlert(message: error.localizedDescription)
                return
            }
            
            if let data = data {
                do {
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(WeatherData.self, from: data)
                    DispatchQueue.main.async {
                        self.weatherLabel.text = "Weather: \(weatherData.weather[0].description)"
                    }
                } catch let error {
                    self.showAlert(message: error.localizedDescription)
                }
            }
        }.resume()
    }

    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

struct WeatherData: Codable {
    let weather: [Weather]
}

struct Weather: Codable {
    let description: String
}
