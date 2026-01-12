import Foundation
import SwiftUI

@MainActor
final class MetaDataViewModel: ObservableObject {

    @Published var videoId: String = ""
    @Published var videoMetadata: VideoMetadata?
    @Published var shouldUseWebView: Bool = true
    @Published var isLoading: Bool = false
    @Published var error: NetworkError?

    private let api: NetflixAPIProtocol
    var lastFetchedId: String?

    init(api: NetflixAPIProtocol = NetflixAPI()) {
        self.api = api
    }

    func fetchVideoMetadata(videoId: String) {
        guard lastFetchedId != videoId else { return }
        lastFetchedId = videoId

        isLoading = true
        error = nil

        Task {
            do {
                let metadata = try await api.fetchMetadata(videoId: videoId)
                self.videoMetadata = metadata
            } catch let networkError as NetworkError {
                self.error = networkError
            } catch {
                self.error = .underlying(error)
            }
            self.isLoading = false
        }
    }
}
