//
//  NotificationService.swift
//  SCAM-ER
//
//  Created by PANACEA-ECOSYSTEM-IA Team on 17/10/25.
//  Copyright © 2025 Inversiones y Servicios Eleusis Icono S.A. All rights reserved.
//

import Foundation
import UserNotifications
import Combine

// MARK: - Notification Service
class NotificationService: ObservableObject {
    @Published var isAuthorized = false
    @Published var pendingNotifications: [UNNotificationRequest] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    init() {
        checkAuthorizationStatus()
    }
    
    // MARK: - Permission Request
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            DispatchQueue.main.async {
                self?.isAuthorized = granted
                if let error = error {
                    print("❌ Notification permission error: \(error)")
                } else {
                    print("✅ Notification permission granted: \(granted)")
                }
            }
        }
    }
    
    // MARK: - Check Authorization Status
    private func checkAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                self?.isAuthorized = settings.authorizationStatus == .authorized
            }
        }
    }
    
    // MARK: - Send Notifications
    func sendFraudAlert(_ alert: SecurityAlert) {
        guard isAuthorized else {
            print("❌ Notifications not authorized")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = alert.title
        content.body = alert.message
        content.sound = .default
        content.badge = 1
        
        // Add custom data
        content.userInfo = [
            "alertId": alert.id.uuidString,
            "severity": alert.severity,
            "timestamp": alert.createdAt.timeIntervalSince1970
        ]
        
        let request = UNNotificationRequest(
            identifier: alert.id.uuidString,
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send notification: \(error)")
            } else {
                print("✅ Fraud alert sent successfully")
            }
        }
    }
    
    func sendTransactionAlert(_ transactionHash: String, riskLevel: RiskLevel) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "⚠️ Transacción de Alto Riesgo Detectada"
        content.body = "Hash: \(transactionHash.prefix(10))... - Nivel: \(riskLevel.description)"
        content.sound = .default
        content.badge = 1
        
        let request = UNNotificationRequest(
            identifier: "transaction_\(transactionHash)",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send transaction alert: \(error)")
            }
        }
    }
    
    func sendWalletConnectionAlert(_ walletName: String, isConnected: Bool) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = isConnected ? "✅ Wallet Conectado" : "❌ Wallet Desconectado"
        content.body = "\(walletName) \(isConnected ? "conectado exitosamente" : "desconectado")"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "wallet_\(walletName)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send wallet alert: \(error)")
            }
        }
    }
    
    func sendReportStatusUpdate(_ reportId: String, status: String) {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "📋 Actualización de Reporte"
        content.body = "Tu reporte #\(reportId) ha sido actualizado: \(status)"
        content.sound = .default
        
        let request = UNNotificationRequest(
            identifier: "report_\(reportId)_\(Date().timeIntervalSince1970)",
            content: content,
            trigger: nil
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to send report update: \(error)")
            }
        }
    }
    
    // MARK: - Scheduled Notifications
    func scheduleDailyReport() {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "📊 Reporte Diario SCAM-ER"
        content.body = "Revisa las estadísticas de fraudes detectados hoy"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.hour = 9
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "daily_report",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule daily report: \(error)")
            } else {
                print("✅ Daily report scheduled")
            }
        }
    }
    
    func scheduleWeeklySummary() {
        guard isAuthorized else { return }
        
        let content = UNMutableNotificationContent()
        content.title = "📈 Resumen Semanal"
        content.body = "Consulta el resumen de actividad de la semana"
        content.sound = .default
        
        var dateComponents = DateComponents()
        dateComponents.weekday = 1 // Sunday
        dateComponents.hour = 10
        dateComponents.minute = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(
            identifier: "weekly_summary",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("❌ Failed to schedule weekly summary: \(error)")
            } else {
                print("✅ Weekly summary scheduled")
            }
        }
    }
    
    // MARK: - Cancel Notifications
    func cancelNotification(withIdentifier identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [identifier])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    // MARK: - Get Pending Notifications
    func getPendingNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] requests in
            DispatchQueue.main.async {
                self?.pendingNotifications = requests
            }
        }
    }
    
    // MARK: - Get Delivered Notifications
    func getDeliveredNotifications() {
        UNUserNotificationCenter.current().getDeliveredNotifications { notifications in
            print("📱 Delivered notifications: \(notifications.count)")
        }
    }
}

// MARK: - Notification Categories
extension NotificationService {
    func setupNotificationCategories() {
        let fraudAlertCategory = UNNotificationCategory(
            identifier: "FRAUD_ALERT",
            actions: [
                UNNotificationAction(
                    identifier: "VIEW_DETAILS",
                    title: "Ver Detalles",
                    options: [.foreground]
                ),
                UNNotificationAction(
                    identifier: "REPORT_FRAUD",
                    title: "Reportar",
                    options: [.foreground]
                )
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let transactionAlertCategory = UNNotificationCategory(
            identifier: "TRANSACTION_ALERT",
            actions: [
                UNNotificationAction(
                    identifier: "VERIFY_TRANSACTION",
                    title: "Verificar",
                    options: [.foreground]
                ),
                UNNotificationAction(
                    identifier: "BLOCK_TRANSACTION",
                    title: "Bloquear",
                    options: [.destructive]
                )
            ],
            intentIdentifiers: [],
            options: []
        )
        
        let walletCategory = UNNotificationCategory(
            identifier: "WALLET_ALERT",
            actions: [
                UNNotificationAction(
                    identifier: "VIEW_WALLET",
                    title: "Ver Wallet",
                    options: [.foreground]
                )
            ],
            intentIdentifiers: [],
            options: []
        )
        
        UNUserNotificationCenter.current().setNotificationCategories([
            fraudAlertCategory,
            transactionAlertCategory,
            walletCategory
        ])
    }
}

// MARK: - Notification Delegate
class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        
        switch response.actionIdentifier {
        case "VIEW_DETAILS":
            print("📱 User tapped 'View Details'")
            // Handle view details action
        case "REPORT_FRAUD":
            print("📱 User tapped 'Report Fraud'")
            // Handle report fraud action
        case "VERIFY_TRANSACTION":
            print("📱 User tapped 'Verify Transaction'")
            // Handle verify transaction action
        case "BLOCK_TRANSACTION":
            print("📱 User tapped 'Block Transaction'")
            // Handle block transaction action
        case "VIEW_WALLET":
            print("📱 User tapped 'View Wallet'")
            // Handle view wallet action
        default:
            print("📱 User tapped notification")
            // Handle default notification tap
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Show notification even when app is in foreground
        completionHandler([.alert, .badge, .sound])
    }
}
