//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests

import Foundation
import Combine

protocol BitcoinRateService: AnyObject {
    var ratePublisher: AnyPublisher<Double, Never> { get }
    
    func startFetching()
}

final class BitcoinRateServiceImpl {
    
    private let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
    private let cacheKey = "BitcoinRateCache"
    private let userDefaults = UserDefaults.standard
    private let analyticsService: AnalyticsService
    private var timer: AnyCancellable?
    private let updateInterval: TimeInterval = 120
    private let rateSubject = CurrentValueSubject<Double, Never>(0.0)
    private var cancellables = Set<AnyCancellable>()
    
//    var onRateUpdate: ((Double) -> Void)?
    var ratePublisher: AnyPublisher<Double, Never> { rateSubject.eraseToAnyPublisher() }
    
    // MARK: - Init
    
    init(analyticsService: AnalyticsService = AnalyticsServiceImpl()) {
        
        self.analyticsService = analyticsService
        loadCachedRate()
    }
    
    func startFetching() {
        fetchRate()
        scheduleTimer()
    }
}

extension BitcoinRateServiceImpl: BitcoinRateService {
    
}

// MARK: - Private methods
private extension BitcoinRateServiceImpl {
    func fetchRate() {
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: BitcoinRateResponseEntity.self, decoder: JSONDecoder())
            .map { $0.bpi.usd.rateFloat }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Failed to fetch Bitcoin rate: \(error)")
                }
            }, receiveValue: { [weak self] rate in
                self?.cacheRate(rate)
                self?.rateSubject.send(rate)
                self?.analyticsService.trackEvent(name: "btc-rate-update", parameters: ["rate": "\(rate)"])
            })
            .store(in: &cancellables)
    }
    
    func scheduleTimer() {
        timer = Timer.publish(every: updateInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchRate()
            }
    }
    
    func cacheRate(_ rate: Double) {
        userDefaults.set(rate, forKey: cacheKey)
        userDefaults.synchronize()
    }
    
    func loadCachedRate() {
        if let cachedRate = userDefaults.value(forKey: cacheKey) as? Double {
            rateSubject.send(cachedRate)
        }
    }
}
