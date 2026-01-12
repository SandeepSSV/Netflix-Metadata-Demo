//
//  MetaDataModel.swift
//  TelepartyDemoApp
//
//  Created by Sandeep S on 11/01/26.
//

import Foundation

// MARK: - VideoMetadata
struct VideoMetadata: Codable {
    let version: String
    let trackIDS: TrackIDS
    let video: Video

    enum CodingKeys: String, CodingKey {
        case version
        case trackIDS = "trackIds"
        case video
    }
}

// MARK: - TrackIDS
struct TrackIDS: Codable {
    let nextEpisode, episodeSelector: Int
}

// MARK: - Video
struct Video: Codable {
    let title, synopsis: String
    let matchScore: MatchScore
    let rating: String
    let artwork, boxart, storyart: [Artwork]
    let type, unifiedEntityID: String
    let id: Int
    let skipMarkers: SkipMarkers
    let seasons: [Season]?
    let start, end, year: Int?
    let requiresAdultVerification, requiresPin, requiresPreReleasePin: Bool
    let creditsOffset, runtime, displayRuntime: Int?
    let autoplayable: Bool?
    let liveEvent: LiveEvent?
    let taglineMessages: TaglineMessages?
    let bookmark: Bookmark?
    let hd: Bool?
    let stills: [Artwork]?
    let hiddenEpisodeNumbers: Bool
    let merchedVideoID: JSONNull?
    let cinematch: Cinematch
    
    var runTime: String {
        if let runtime = self.runtime {
            let hours = runtime / 3600
            let minutes = (runtime % 3600) / 60
            if hours == 0 {
                return String(format: "%02dm", minutes)
            }
            return String(format: "%02dh %02dm", hours, minutes)
        }
        return "N/A"
    }
    
    var releaseDate: String {
        if let start = self.start {
            let date = Date(timeIntervalSince1970: TimeInterval(start) / 1000)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        } else if let start = self.seasons?.first?.episodes.first?.start {
            let date = Date(timeIntervalSince1970: TimeInterval(start) / 1000)
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        }
        return "N/A"
        
    }

    enum CodingKeys: String, CodingKey {
        case title, synopsis, matchScore, rating, artwork, boxart, storyart, type
        case unifiedEntityID = "unifiedEntityId"
        case id, skipMarkers, start, end, year, requiresAdultVerification, requiresPin, requiresPreReleasePin, creditsOffset, runtime, displayRuntime, autoplayable, liveEvent, taglineMessages, bookmark, hd, stills, hiddenEpisodeNumbers
        case merchedVideoID = "merchedVideoId"
        case cinematch
        case seasons
    }
}

// MARK: - Season
struct Season: Codable {
    let year: Int
    let shortName, longName: String
    let hiddenEpisodeNumbers: Bool
    let title: String
    let id, seq: Int
    let episodes: [Episode]
}

// MARK: - Episode
struct Episode: Codable {
    let start, end: Int
    let synopsis: String
    let episodeID: Int
    let liveEvent: LiveEvent
    let taglineMessages: TaglineMessages
    let requiresAdultVerification, requiresPin, requiresPreReleasePin: Bool
    let creditsOffset, runtime, displayRuntime, watchedToEndOffset: Int
    let autoplayable: Bool
    let title: String
    let id: Int
    let bookmark: Bookmark
    let skipMarkers: SkipMarkers
    let hd: Bool
    let thumbs, stills: [Artwork]
    let seq: Int
    let hiddenEpisodeNumbers: Bool

    enum CodingKeys: String, CodingKey {
        case start, end, synopsis
        case episodeID = "episodeId"
        case liveEvent, taglineMessages, requiresAdultVerification, requiresPin, requiresPreReleasePin, creditsOffset, runtime, displayRuntime, watchedToEndOffset, autoplayable, title, id, bookmark, skipMarkers, hd, thumbs, stills, seq, hiddenEpisodeNumbers
    }
}


// MARK: - Artwork
struct Artwork: Codable {
    let w, h: Int
    let url: String
}

// MARK: - Bookmark
struct Bookmark: Codable {
    let watchedDate, offset: Int
}

// MARK: - Cinematch
struct Cinematch: Codable {
    let type, value: String
}

// MARK: - LiveEvent
struct LiveEvent: Codable {
    let hasLiveEvent: Bool
}

// MARK: - MatchScore
struct MatchScore: Codable {
    let isNewForPVR: Bool
    let computeID: String
    let trackingInfo: TrackingInfo

    enum CodingKeys: String, CodingKey {
        case isNewForPVR = "isNewForPvr"
        case computeID = "computeId"
        case trackingInfo
    }
}

// MARK: - TrackingInfo
struct TrackingInfo: Codable {
    let matchScore, tooNewForMatchScore, matchRequestID: String

    enum CodingKeys: String, CodingKey {
        case matchScore, tooNewForMatchScore
        case matchRequestID = "matchRequestId"
    }
}

// MARK: - SkipMarkers
struct SkipMarkers: Codable {
    let credit, recap: Credit
}

// MARK: - Credit
struct Credit: Codable {
    let start, end: Int?
}

// MARK: - TaglineMessages
struct TaglineMessages: Codable {
    let tagline, classification: String
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
    }

    public var hashValue: Int {
            return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                    throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
    }

    public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
    }
}

