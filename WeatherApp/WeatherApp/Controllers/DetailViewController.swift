//
//  DetailViewController.swift
//  WeatherApp
//
//  Created by Ahad Islam on 2/5/20.
//  Copyright © 2020 David Rifkin. All rights reserved.
//

import UIKit
import ImageKit


class DetailViewController: UIViewController {
    
    private lazy var forecastLabel: UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        return l
    }()
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    private lazy var detailLabel: UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        return l
    }()
    
    private let forecast: DailyDatum
    private let placename: String
    
    public init(_ forecast: DailyDatum, placename: String) {
        self.forecast = forecast
        self.placename = placename
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        configureView()
        
    }
    
    private func loadData() {
        let date = Date(timeIntervalSince1970: forecast.time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        forecastLabel.text = "Weather forecast for \(placename) on \(dateFormatter.string(from: date))"
        
        imageView.image = UIImage(systemName: "heart")
        
        detailLabel.text = "OK"
        
        getPix(placename)
    }
    
    private func getPix(_ place: String) {
        let query = place.lowercased().addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let endpointURL = "https://pixabay.com/api/?key=\(APIKey.pixabayKey)&q=\(query ?? "")"
        
        GenericCoderAPI.manager.getJSON(objectType: PixWrapper.self, with: endpointURL) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let wrapper):
                DispatchQueue.main.async {
                    self.getImage(wrapper.hits.randomElement()?.webformatURL ?? wrapper.hits[0].webformatURL)
                }
            }
        }
    }
    
    private func getImage(_ string: String) {
        imageView.getImage(with: string) { result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let image):
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }
    
    private func configureView() {
        title = "Forecast"
        view.backgroundColor = .systemRed
        setupForecastLabel()
        setupImageView()
        setupDetailLabel()
    }
    
    private func setupForecastLabel() {
        view.addSubview(forecastLabel)
        forecastLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            forecastLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            forecastLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)])
    }
    
    private func setupImageView() {
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.heightAnchor.constraint(equalToConstant: view.frame.width),
            imageView.widthAnchor.constraint(equalToConstant: view.frame.width)])
    }
    
    private func setupDetailLabel() {
        view.addSubview(detailLabel)
        detailLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            detailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            detailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)])
    }
    
    
}
