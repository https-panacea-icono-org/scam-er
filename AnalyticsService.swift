//
//  AnalyticsService.swift
//  SCAM-ER
//
//  Created by PANACEA-ECOSYSTEM-IA Team on 17/10/25.
//  Copyright © 2025 Inversiones y Servicios Eleusis Icono S.A. All rights reserved.
//

import Foundation
import Combine

// MARK: - Analytics Service
class AnalyticsService: ObservableObject {
    @Published var isConfigured = false
    @Published var analyticsData: AnalyticsData = AnalyticsData()
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService()
    
    // MARK: - Initialization
    func configure() {
        print("📊 Analytics Service configured")
        isConfigured = true
    }
    
    // MARK: - Event Tracking
    func trackEvent(_ event: AnalyticsEvent) {
        guard isConfigured else { return }
        
        print("📊 Tracking event: \(event.name)")
        
        // Send to analytics service
        apiService.trackEvent(event)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("❌ Failed to track event: \(error)")
                    }
                },
                receiveValue: { success in
                    if success {
                        print("✅ Event tracked successfully")
                    }
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - User Actions
    func trackUserAction(_ action: UserAction) {
        let event = AnalyticsEvent(
            name: action.rawValue,
            properties: [
                "timestamp": Date().timeIntervalSince1970,
                "action_type": action.rawValue
            ]
        )
        trackEvent(event)
    }
    
    // MARK: - Fraud Detection Events
    func trackFraudDetection(_ result: FraudDetectionResult) {
        let event = AnalyticsEvent(
            name: "fraud_detection",
            properties: [
                "transaction_hash": result.transactionHash,
                "risk_score": result.riskScore,
                "risk_level": result.riskLevel.rawValue,
                "fraud_type": result.fraudType.rawValue,
                "confidence": result.confidence,
                "timestamp": result.timestamp.timeIntervalSince1970
            ]
        )
        trackEvent(event)
    }
    
    // MARK: - Wallet Events
    func trackWalletConnection(_ wallet: ConnectedWallet, isConnected: Bool) {
        let event = AnalyticsEvent(
            name: isConnected ? "wallet_connected" : "wallet_disconnected",
            properties: [
                "wallet_name": wallet.name,
                "wallet_address": wallet.address,
                "supported_chains": wallet.supportedChains.map { $0.rawValue },
                "timestamp": Date().timeIntervalSince1970
            ]
        )
        trackEvent(event)
    }
    
    // MARK: - Report Events
    func trackReportSubmission(_ report: FraudReport) {
        let event = AnalyticsEvent(
            name: "report_submitted",
            properties: [
                "report_id": report.id.uuidString,
                "fraud_type": report.fraudType,
                "blockchain": report.blockchain,
                "has_evidence": !report.evidenceImages.isEmpty,
                "timestamp": report.createdAt.timeIntervalSince1970
            ]
        )
        trackEvent(event)
    }
    
    // MARK: - Error Tracking
    func trackError(_ error: Error, context: String) {
        let event = AnalyticsEvent(
            name: "error_occurred",
            properties: [
                "error_description": error.localizedDescription,
                "context": context,
                "timestamp": Date().timeIntervalSince1970
            ]
        )
        trackEvent(event)
    }
    
    // MARK: - Performance Tracking
    func trackPerformance(_ metric: PerformanceMetric) {
        let event = AnalyticsEvent(
            name: "performance_metric",
            properties: [
                "metric_name": metric.name,
                "value": metric.value,
                "unit": metric.unit,
                "timestamp": metric.timestamp.timeIntervalSince1970
            ]
        )
        trackEvent(event)
    }
    
    // MARK: - Get Analytics Data
    func getAnalyticsData() -> AnyPublisher<AnalyticsData, Error> {
        return apiService.getAnalyticsData()
            .map { [weak self] data in
                DispatchQueue.main.async {
                    self?.analyticsData = data
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}

// MARK: - Data Models
struct AnalyticsEvent {
    let name: String
    let properties: [String: Any]
    let timestamp: Date
    
    init(name: String, properties: [String: Any]) {
        self.name = name
        self.properties = properties
        self.timestamp = Date()
    }
}

enum UserAction: String, CaseIterable {
    case appOpened = "app_opened"
    case dashboardViewed = "dashboard_viewed"
    case fraudDetectionStarted = "fraud_detection_started"
    case fraudDetectionCompleted = "fraud_detection_completed"
    case reportSubmitted = "report_submitted"
    case walletConnected = "wallet_connected"
    case walletDisconnected = "wallet_disconnected"
    case settingsOpened = "settings_opened"
    case profileViewed = "profile_viewed"
    case statisticsViewed = "statistics_viewed"
    case notificationReceived = "notification_received"
    case notificationTapped = "notification_tapped"
    case errorOccurred = "error_occurred"
    case performanceMetric = "performance_metric"
}

struct AnalyticsData {
    var totalUsers: Int = 0
    var activeUsers: Int = 0
    var totalReports: Int = 0
    var fraudsDetected: Int = 0
    var walletsConnected: Int = 0
    var averageRiskScore: Double = 0.0
    var mostCommonFraudType: String = ""
    var detectionAccuracy: Double = 0.0
    var userRetention: Double = 0.0
    var averageSessionDuration: Double = 0.0
    var crashRate: Double = 0.0
    var errorRate: Double = 0.0
    var lastUpdated: Date = Date()
    
    static func sample() -> AnalyticsData {
        var data = AnalyticsData()
        data.totalUsers = 1250
        data.activeUsers = 890
        data.totalReports = 3420
        data.fraudsDetected = 156
        data.walletsConnected = 567
        data.averageRiskScore = 45.2
        data.mostCommonFraudType = "Phishing"
        data.detectionAccuracy = 89.5
        data.userRetention = 78.3
        data.averageSessionDuration = 420.0
        data.crashRate = 0.02
        data.errorRate = 0.05
        return data
    }
}

struct PerformanceMetric {
    let name: String
    let value: Double
    let unit: String
    let timestamp: Date
    
    static func appLaunchTime(_ time: Double) -> PerformanceMetric {
        return PerformanceMetric(
            name: "app_launch_time",
            value: time,
            unit: "seconds",
            timestamp: Date()
        )
    }
    
    static func fraudDetectionTime(_ time: Double) -> PerformanceMetric {
        return PerformanceMetric(
            name: "fraud_detection_time",
            value: time,
            unit: "seconds",
            timestamp: Date()
        )
    }
    
    static func apiResponseTime(_ time: Double) -> PerformanceMetric {
        return PerformanceMetric(
            name: "api_response_time",
            value: time,
            unit: "milliseconds",
            timestamp: Date()
        )
    }
    
    static func memoryUsage(_ usage: Double) -> PerformanceMetric {
        return PerformanceMetric(
            name: "memory_usage",
            value: usage,
            unit: "MB",
            timestamp: Date()
        )
    }
}

// MARK: - API Service Extension
extension APIService {
    func trackEvent(_ event: AnalyticsEvent) -> AnyPublisher<Bool, Error> {
        return Future<Bool, Error> { promise in
            // Simulate API call
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                print("📊 Event sent to analytics: \(event.name)")
                promise(.success(true))
            }
        }
        .eraseToAnyPublisher()
    }
    
    func getAnalyticsData() -> AnyPublisher<AnalyticsData, Error> {
        return Future<AnalyticsData, Error> { promise in
            // Simulate API call
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let data = AnalyticsData.sample()
                promise(.success(data))
            }
        }
        .eraseToAnyPublisher()
    }
}
