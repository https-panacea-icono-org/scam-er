//
//  AnalyticsService.swift
//  SCAM-ER
//
//  Created by PANACEA-ECOSYSTEM-IA Team on 17/10/25.
//  Copyright © 2025 Inversiones y Servicios Eleusis Icono S.A. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

// MARK: - Analytics Service
class AnalyticsService: ObservableObject {
    @Published var analyticsData: AnalyticsData = AnalyticsData()
    @Published var isTrackingEnabled = true
    
    private let apiService = APIService()
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        configure()
    }
    
    // MARK: - Configuration
    func configure() {
        print("📊 Analytics Service configured")
    }
    
    // MARK: - Event Tracking
    func trackEvent(_ event: AnalyticsEvent) {
        guard isTrackingEnabled else { return }
        
        analyticsData.totalReports += 1
        
        // Send to API
        apiService.trackEvent(event)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ Failed to track event: \(error.localizedDescription)")
                    }
                },
                receiveValue: { success in
                    if success {
                        print("✅ Event tracked: \(event.name)")
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    func trackUserAction(_ action: UserAction) {
        let event = AnalyticsEvent(
            name: action.rawValue,
            properties: ["action": action.rawValue]
        )
        trackEvent(event)
    }
    
    func trackFraudDetection(_ result: FraudDetectionResult) {
        let event = AnalyticsEvent(
            name: "fraud_detection",
            properties: [
                "risk_level": result.riskLevel.rawValue,
                "fraud_type": result.fraudType.rawValue,
                "confidence": result.confidence,
                "transaction_hash": result.transactionHash
            ]
        )
        trackEvent(event)
    }
    
    func trackWalletConnection(_ wallet: ConnectedWallet, isConnected: Bool) {
        let event = AnalyticsEvent(
            name: isConnected ? "wallet_connected" : "wallet_disconnected",
            properties: [
                "wallet_name": wallet.name,
                "wallet_address": wallet.address,
                "blockchain": wallet.supportedChains.first?.rawValue ?? "unknown"
            ]
        )
        trackEvent(event)
    }
    
    func trackPerformance(_ metric: PerformanceMetric) {
        let event = AnalyticsEvent(
            name: "performance_metric",
            properties: [
                "metric_name": metric.name,
                "value": metric.value,
                "unit": metric.unit
            ]
        )
        trackEvent(event)
    }
    
    // MARK: - Data Retrieval
    func getAnalyticsData() -> AnyPublisher<AnalyticsData, Error> {
        return apiService.getAnalyticsData()
            .map { [weak self] data in
                self?.analyticsData = data
                return data
            }
            .eraseToAnyPublisher()
    }
    
    func getPerformanceMetrics() -> [PerformanceMetric] {
        return []
    }
    
    func getUserActions() -> [UserAction] {
        return []
    }
    
    // MARK: - Settings
    func enableTracking() {
        isTrackingEnabled = true
        print("✅ Analytics tracking enabled")
    }
    
    func disableTracking() {
        isTrackingEnabled = false
        print("❌ Analytics tracking disabled")
    }
    
    func clearData() {
        analyticsData = AnalyticsData()
        print("🗑️ Analytics data cleared")
    }
}

// MARK: - Computed Properties
extension AnalyticsService {
    var totalEvents: Int {
        return analyticsData.totalReports
    }
    
    var uniqueUsers: Int {
        return analyticsData.totalUsers
    }
    
    var averageSessionDuration: TimeInterval {
        return analyticsData.averageSessionDuration
    }
    
    var mostUsedFeature: String? {
        return "fraud_detection"
    }
}