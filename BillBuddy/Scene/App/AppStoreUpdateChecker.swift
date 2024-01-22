//
//  AppStoreUpdateChecker.swift
//  BillBuddy
//
//  Created by 이승준 on 1/22/24.
//

import Foundation

//MARK: - AppStoreResponse
struct AppStoreResponse: Codable {
    let resultCount: Int
    let results: [AppStoreResult]
}

//MARK: - Result
struct AppStoreResult: Codable {
    let releaseNotes: String
    let releaseDate: String
    let version: String
}

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
            let url = URL(string: "https://itunes.apple.com/lookup?bundleId=\(bundleID)")
        else { return false }
        print("---> url:", url)
        do {
            // Fetches and parses the response
            let (data, response) = try await URLSession.shared.data(from: url)
            guard (response as? HTTPURLResponse)?.statusCode == 200 else { throw URLError(.badServerResponse) }
            let appStoreResponse = try JSONDecoder().decode(AppStoreResponse.self, from: data)
            
            // Retrieves the version number
            guard let latestVersionNumber = appStoreResponse.results.first?.version else {
                // Error: no app with matching bundle ID found
                
                return false
            }
            print("----> 최신 버전:", latestVersionNumber)
            print("----> 현재 버전:", currentVersionNumber)
            // Checks if there's a mismatch in version numbers
            return currentVersionNumber != latestVersionNumber
        } catch {
            // TODO: Handle Error
            return false
        }
    }
}
