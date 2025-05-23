import Foundation
import AppKit

@MainActor
class JamfKillerService: ObservableObject {
    @Published var isUltraKillEnabled = false
    @Published var killCount = 0
    @Published var statusMessage = "Ready to eliminate Jamf!"
    @Published var isActive = false
    
    private var monitoringTask: Task<Void, Never>?
    private let killInterval: TimeInterval = 0.1 // 100ms for ultra-fast detection
    
    func toggleUltraKill() {
        isUltraKillEnabled.toggle()
        
        if isUltraKillEnabled {
            startUltraKill()
            statusMessage = "🔥 ULTRA KILL MODE ACTIVE"
            isActive = true
        } else {
            stopUltraKill()
            statusMessage = "💀 Ultra Kill Mode Stopped"
            isActive = false
            
            // Reset message after delay
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    if !self.isUltraKillEnabled {
                        self.statusMessage = "Ready to eliminate Jamf!"
                    }
                }
            }
        }
    }
    
    private func startUltraKill() {
        // Cancel any existing monitoring
        monitoringTask?.cancel()
        
        // Start completely background monitoring loop
        monitoringTask = Task.detached { [weak self] in
            while !Task.isCancelled {
                // All work happens in background
                await self?.performUltraKillBackground()
                
                // Sleep without blocking anything
                try? await Task.sleep(for: .milliseconds(100))
            }
        }
    }
    
    private func stopUltraKill() {
        monitoringTask?.cancel()
        monitoringTask = nil
    }
    
    private func performUltraKillBackground() async {
        // Everything happens on background thread
        let jamfProcesses = await findJamfProcessesBackground()
        
        if !jamfProcesses.isEmpty {
            var killedThisRound = 0
            
            // Kill processes in parallel for maximum speed
            await withTaskGroup(of: Bool.self) { group in
                for process in jamfProcesses {
                    group.addTask {
                        await self.killProcessBackground(pid: process.pid)
                    }
                }
                
                for await result in group {
                    if result {
                        killedThisRound += 1
                    }
                }
            }
            
            // Additional cleanup in parallel
            async let killJamfConnect = killAllByNameBackground("Jamf Connect")
            async let killJamfDaemon = killAllByNameBackground("JamfDaemon")
            async let killJamfAgent = killAllByNameBackground("JamfAgent")
            async let killJCDaemon = killAllByNameBackground("JCDaemon")
            
            // Wait for all kills to complete
            await killJamfConnect
            await killJamfDaemon
            await killJamfAgent
            await killJCDaemon
            
            // Update UI only if we actually killed something
            if killedThisRound > 0 {
                // Non-blocking UI update
                Task { @MainActor in
                    self.killCount += killedThisRound
                    self.statusMessage = "⚡ ELIMINATED \(killedThisRound) PROCESSES"
                }
            }
        }
    }
    
    private func findJamfProcessesBackground() async -> [JamfProcess] {
        return await withCheckedContinuation { continuation in
            // Run on background queue
            DispatchQueue.global(qos: .background).async {
                var processes: [JamfProcess] = []
                
                let task = Process()
                task.launchPath = "/bin/bash"
                task.arguments = ["-c", """
                    ps aux | grep -i jamf | grep -v grep | grep -v JamfKiller | awk '{print $2 ":" $11}'
                """]
                
                let pipe = Pipe()
                task.standardOutput = pipe
                
                do {
                    try task.run()
                    task.waitUntilExit()
                    
                    let data = pipe.fileHandleForReading.readDataToEndOfFile()
                    let output = String(data: data, encoding: .utf8) ?? ""
                    
                    for line in output.components(separatedBy: .newlines) {
                        if !line.isEmpty {
                            let components = line.components(separatedBy: ":")
                            if components.count >= 2,
                               let pid = Int32(components[0]) {
                                let name = components.dropFirst().joined(separator: ":")
                                processes.append(JamfProcess(pid: pid, name: name))
                            }
                        }
                    }
                } catch {
                    // Silently continue on error
                }
                
                continuation.resume(returning: processes)
            }
        }
    }
    
    private func killProcessBackground(pid: Int32) async -> Bool {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let result = kill(pid, SIGKILL) == 0
                continuation.resume(returning: result)
            }
        }
    }
    
    private func killAllByNameBackground(_ name: String) async {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .background).async {
                let task = Process()
                task.launchPath = "/usr/bin/killall"
                task.arguments = ["-9", name]
                
                do {
                    try task.run()
                    task.waitUntilExit()
                } catch {
                    // Silently continue - process might not exist
                }
                
                continuation.resume()
            }
        }
    }
    
    deinit {
        monitoringTask?.cancel()
        monitoringTask = nil
    }
}

struct JamfProcess {
    let pid: Int32
    let name: String
} 