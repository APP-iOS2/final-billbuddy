//
//  AppStoreUpdateChecker.swift
//  BillBuddy
//
//  Created by 이승준 on 1/22/24.
//

import Foundation

private extension Bundle {
    var releaseVersionNumber: String? {
        infoDictionary?["CFBundleShortVersionString"] as? String
    }
}

struct AppStoreUpdateChecker {
    static func isNewVersionAvailable() async -> Bool {
        guard
            let bundleID = Bundle.main.bundleIdentifier,
            let currentVersionNumber = Bundle.main.releaseVersionNumber,
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)&country=kr")
        else { return false }
        print("---> url:", url)
        do {
            // Fetches and parses the response
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                  let results = json["results"] as? [[String: Any]],
                  let appStoreVersion = results[0]["version"] as? String else {
                return false
            }
                
            print("----> 최신 버전:", appStoreVersion)
            print("----> 현재 버전:", currentVersionNumber)
            // Checks if there's a mismatch in version numbers
            return currentVersionNumber != appStoreVersion
        } catch {
            // TODO: Handle Error
            return false
        }
    }
}
