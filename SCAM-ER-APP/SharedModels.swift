//
//  SharedModels.swift
//  SCAM-ER
//
//  Created by PANACEA-ECOSYSTEM-IA Team on 17/10/25.
//  Copyright © 2025 Inversiones y Servicios Eleusis Icono S.A. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: - Blockchain Enum
enum Blockchain: String, CaseIterable {
    case ethereum = "Ethereum"
    case bsc = "BSC"
    case polygon = "Polygon"
    case arbitrum = "Arbitrum"
    case optimism = "Optimism"
    case solana = "Solana"
    case ton = "TON"
    case avalanche = "Avalanche"
    
    var name: String {
        return rawValue
    }
    
    var color: Color {
        switch self {
        case .ethereum: return .purple
        case .bsc: return .yellow
        case .polygon: return .purple
        case .arbitrum: return .blue
        case .optimism: return .red
        case .solana: return .green
        case .ton: return .blue
        case .avalanche: return .red
        }
    }
    
    var explorerUrl: String {
        switch self {
        case .ethereum: return "https://etherscan.io"
        case .bsc: return "https://bscscan.com"
        case .polygon: return "https://polygonscan.com"
        case .arbitrum: return "https://arbiscan.io"
        case .optimism: return "https://optimistic.etherscan.io"
        case .solana: return "https://explorer.solana.com"
        case .ton: return "https://tonscan.org"
        case .avalanche: return "https://snowtrace.io"
        }
    }
}

// MARK: - Risk Level Enum
enum RiskLevel: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    case critical = "critical"
    
    var color: Color {
        switch self {
        case .low: return .green
        case .medium: return .yellow
        case .high: return .orange
        case .critical: return .red
        }
    }
    
    var description: String {
        switch self {
        case .low: return "Bajo riesgo"
        case .medium: return "Riesgo medio"
        case .high: return "Alto riesgo"
        case .critical: return "Riesgo crítico"
        }
    }
}

// MARK: - Fraud Type Enum
enum FraudType: String, CaseIterable {
    case phishing = "Phishing"
    case rugpull = "Rugpull"
    case fakeWallet = "Fake Wallet"
    case custodial = "Custodial Fraud"
    case staking = "Staking Fraud"
    case social = "Social Engineering"
    case mining = "Mining Scam"
    case email = "Email Scam"
    case nft = "Fake NFT"
    case impersonation = "Impersonation"
    case bot = "Bot Fraud"
    case ponzi = "Ponzi Scheme"
    case pumpAndDump = "Pump and Dump"
    case washTrading = "Wash Trading"
    case frontRunning = "Front Running"
    
    var name: String {
        return rawValue
    }
    
    var icon: String {
        switch self {
        case .phishing: return "link.badge.plus"
        case .rugpull: return "arrow.down.circle"
        case .fakeWallet: return "wallet.pass"
        case .custodial: return "person.badge.key"
        case .staking: return "percent"
        case .social: return "person.2"
        case .mining: return "hammer"
        case .email: return "envelope"
        case .nft: return "photo"
        case .impersonation: return "person.crop.circle.badge.exclamationmark"
        case .bot: return "robot"
        case .ponzi: return "arrow.triangle.2.circlepath"
        case .pumpAndDump: return "chart.line.uptrend.xyaxis"
        case .washTrading: return "arrow.triangle.2.circlepath.circle"
        case .frontRunning: return "arrow.forward.circle"
        }
    }
    
    var color: Color {
        switch self {
        case .phishing: return .red
        case .rugpull: return .orange
        case .fakeWallet: return .purple
        case .custodial: return .blue
        case .staking: return .green
        case .social: return .pink
        case .mining: return .brown
        case .email: return .cyan
        case .nft: return .mint
        case .impersonation: return .yellow
        case .bot: return .gray
        case .ponzi: return .red
        case .pumpAndDump: return .orange
        case .washTrading: return .purple
        case .frontRunning: return .blue
        }
    }
    
    var description: String {
        switch self {
        case .phishing: return "Sitios web falsos que imitan servicios legítimos"
        case .rugpull: return "Proyectos que desaparecen con los fondos de los inversores"
        case .fakeWallet: return "Aplicaciones de wallet falsas que roban claves privadas"
        case .custodial: return "Servicios de custodia que no devuelven los fondos"
        case .staking: return "Programas de staking falsos o con condiciones ocultas"
        case .social: return "Manipulación psicológica para obtener información"
        case .mining: return "Esquemas de minería falsos o con pagos inexistentes"
        case .email: return "Correos electrónicos falsos para obtener credenciales"
        case .nft: return "NFTs falsos o copias de obras originales"
        case .impersonation: return "Suplantación de identidad de personas o empresas"
        case .bot: return "Bots automatizados que realizan actividades fraudulentas"
        case .ponzi: return "Esquemas Ponzi que pagan con dinero de nuevos inversores"
        case .pumpAndDump: return "Manipulación artificial del precio de activos"
        case .washTrading: return "Trading ficticio para inflar volúmenes"
        case .frontRunning: return "Ejecución de órdenes con información privilegiada"
        }
    }
}

// MARK: - Supported Wallet Enum
enum SupportedWallet: String, CaseIterable {
    case metamask = "MetaMask"
    case trustWallet = "Trust Wallet"
    case coinbase = "Coinbase Wallet"
    case rainbow = "Rainbow"
    case phantom = "Phantom"
    case tonkeeper = "Tonkeeper"
    case walletConnect = "WalletConnect"
    
    var name: String {
        return rawValue
    }
    
    var icon: String {
        switch self {
        case .metamask: return "wallet.pass.fill"
        case .trustWallet: return "shield.fill"
        case .coinbase: return "dollarsign.circle.fill"
        case .rainbow: return "cloud.rain.fill"
        case .phantom: return "ghost.fill"
        case .tonkeeper: return "key.fill"
        case .walletConnect: return "qrcode"
        }
    }
    
    var color: Color {
        switch self {
        case .metamask: return .orange
        case .trustWallet: return .blue
        case .coinbase: return .blue
        case .rainbow: return .purple
        case .phantom: return .purple
        case .tonkeeper: return .blue
        case .walletConnect: return .green
        }
    }
    
    var description: String {
        switch self {
        case .metamask: return "Ethereum & EVM chains"
        case .trustWallet: return "Multi-chain wallet"
        case .coinbase: return "Ethereum & L2s"
        case .rainbow: return "Ethereum wallet"
        case .phantom: return "Solana wallet"
        case .tonkeeper: return "TON blockchain"
        case .walletConnect: return "Universal connector"
        }
    }
    
    var supportedChains: [Blockchain] {
        switch self {
        case .metamask:
            return [.ethereum, .polygon, .arbitrum, .optimism, .avalanche]
        case .trustWallet:
            return [.ethereum, .bsc, .polygon, .solana]
        case .coinbase:
            return [.ethereum, .arbitrum, .optimism]
        case .rainbow:
            return [.ethereum, .polygon]
        case .phantom:
            return [.solana]
        case .tonkeeper:
            return [.ton]
        case .walletConnect:
            return Blockchain.allCases
        }
    }
}

// MARK: - Data Models
struct ConnectedWallet {
    let name: String
    let address: String
    let icon: String
    let color: Color
    let supportedChains: [Blockchain]
}

struct TransactionVerification {
    let hash: String
    let isValid: Bool
    let riskLevel: RiskLevel
    let details: String
}

struct FraudDetectionResult {
    let transactionHash: String
    let riskScore: Double
    let riskLevel: RiskLevel
    let fraudType: FraudType
    let confidence: Double
    let details: String
    let recommendations: [String]
    let timestamp: Date
}

struct ContractAnalysis {
    let contractAddress: String
    let isVerified: Bool
    let riskScore: Double
    let riskLevel: RiskLevel
    let sourceCode: String
    let functions: [String]
    let vulnerabilities: [String]
    let timestamp: Date
}

struct WalletAnalysis {
    let walletAddress: String
    let riskScore: Double
    let riskLevel: RiskLevel
    let transactionCount: Int
    let totalVolume: Double
    let firstSeen: Date
    let lastSeen: Date
    let associatedAddresses: [String]
    let flags: [String]
    let timestamp: Date
}

struct SecurityAlert {
    let id = UUID()
    let title: String
    let message: String
    let severity: String
    let createdAt = Date()
    
    var severityColor: Color {
        switch severity {
        case "high": return .red
        case "medium": return .orange
        case "low": return .green
        default: return .gray
        }
    }
    
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}

struct FeaturedCase {
    let id = UUID()
    let title: String
    let reports: Int
    let status: String
    
    var statusColor: Color {
        switch status {
        case "Investigando": return .orange
        case "Verificado": return .red
        case "Resuelto": return .green
        default: return .gray
        }
    }
}

struct DashboardStats {
    var todayReports: Int = 0
    var detectedFrauds: Int = 0
    var avoidedLosses: Double = 0.0
    var aiAccuracy: Int = 0
    var reportsTrend: Int = 0
    var detectionTrend: Int = 0
    var savingsTrend: Int = 0
    var accuracyTrend: Int = 0
    var unreadAlerts: Int = 0
    var recentAlerts: [SecurityAlert] = []
    var featuredCases: [FeaturedCase] = []
    
    static func sample() -> DashboardStats {
        var stats = DashboardStats()
        stats.todayReports = 47
        stats.detectedFrauds = 23
        stats.avoidedLosses = 2.4
        stats.aiAccuracy = 89
        stats.reportsTrend = 12
        stats.detectionTrend = 8
        stats.savingsTrend = 23
        stats.accuracyTrend = 2
        stats.unreadAlerts = 3
        
        stats.recentAlerts = [
            SecurityAlert(title: "Fake Tonkeeper v2.0", message: "156 reportes en 2 horas", severity: "high"),
            SecurityAlert(title: "CryptoBot Scam", message: "89 reportes confirmados", severity: "medium"),
            SecurityAlert(title: "Binance Phishing", message: "23 reportes verificados", severity: "low")
        ]
        
        stats.featuredCases = [
            FeaturedCase(title: "Tonkeeper Fake Wallet", reports: 156, status: "Investigando"),
            FeaturedCase(title: "CryptoBot Scam Campaign", reports: 89, status: "Verificado"),
            FeaturedCase(title: "Binance Phishing Site", reports: 23, status: "Resuelto")
        ]
        
        return stats
    }
}

// MARK: - Analytics Models
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
