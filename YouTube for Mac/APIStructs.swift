//
//  APIStructs.swift
//  YouTube for Mac
//
//  Created by Adithiya Venkatakrishnan on 9/8/2023.
//

import Foundation

struct VideoThumbnailInfo: Codable {
    var quality: String
    var url: URL
    var width: Int
    var height: Int
}

struct VideoStreamInfo: Codable {
    var url: URL
    var quality: String
    var resolution: String
}

struct CaptionInfo: Codable {
    var label: String
    var language_code: String
    var url: String
}

struct RecommendedVideoInfo: Codable {
    var videoId: String
    var title: String
    var videoThumbnails: [VideoThumbnailInfo]
    var author: String
    var authorId: String
    var lengthSeconds: Double
    var viewCountText: String
    var viewCount: Double
}

/*struct VideoInformation: Codable, Identifiable {
    var id: String {videoId}
    var title: String
    var videoId: String
    var author: String
    var authorId: String
    var videoThumbnails: [VideoThumbnailInfo]
    var description: String
    var viewCount: Double
    var viewCountText: String
    var published: Double
    var publishedText: String
    var lengthSeconds: Double
    var lengthSecondsText: String {
        var hours = Int(floor(lengthSeconds / 3600))
        var minutes = Int(floor(lengthSeconds / 60))
        var seconds = Int(lengthSeconds.truncatingRemainder(dividingBy: 60))
        if seconds < 10 {
            var secondText = "0\(seconds)"
        } else {
            var secondText = "\(seconds)"
        }
        
        return hours == 0 ? "\(minutes):\(seconds)" : "\(hours):\(minutes):\(seconds)"
    }
    var liveNow: Bool
    var premium: Bool
    var isUpcoming: Bool
}*/

struct VideoInformation: Codable, Identifiable {
    var id: String {videoId}
    var title: String
    var videoId: String
    var author: String
    var authorId: String
    var videoThumbnails: [VideoThumbnailInfo]
    var published: Double
    var publishedText: String
    var viewCount: Double
    var viewCountText: String {
        if viewCount < 1000 {
            return "\(viewCount) views"
        } else if viewCount < 100000 {
            let vc = viewCount / 1000
            let vcs = String(format: "%.1f", vc)
            return "\(vcs)K views"
        } else if viewCount < 1000000 {
            let vc = Int(round(viewCount / 1000))
            return "\(vc)K views"
        } else if viewCount < 100000000 {
            let vc = viewCount / 1000000
            let vcs = String(format: "%.1f", vc)
            return "\(vcs)M views"
        } else if viewCount < 1000000000 {
            let vc = Int(round(viewCount / 1000000))
            return "\(vc)M views"
        } else if viewCount < 100000000000 {
            let vc = viewCount / 1000000000
            let vcs = String(format: "%.1f", vc)
            return "\(vcs)B views"
        } else if viewCount < 1000000000000 {
            let vc = viewCount / 1000000000
            return "\(vc)B views"
        } else {
            return "\(viewCount) views"
        }
    }
    var lengthSeconds: Double
    var lengthSecondsText: String {
        let hours: Int;
        if title == "Making purple gold" {
            print(title, lengthSeconds - 3600, Int(lengthSeconds) / 3600)
        }
        var seconds = Int(lengthSeconds)
        hours = seconds / 3600
        seconds -= hours * 3600
        let minutes = seconds / 60
        seconds -= minutes * 60
        if hours == 0 {
            if seconds < 10 {
                return "\(minutes):0\(seconds)"
            } else {
                return "\(minutes):\(seconds)"
            }
        } else {
            if minutes < 10 {
                if seconds < 10 {
                    return "\(hours):0\(minutes):0\(seconds)"
                } else {
                    return "\(hours):0\(minutes):\(seconds)"
                }
            } else {
                if seconds < 10 {
                    return "\(hours):\(minutes):0\(seconds)"
                } else {
                    return "\(hours):\(minutes):\(seconds)"
                }
            }
        }
    }
}

// Contains info from /API/V1/VIDEOS/:ID
struct VideoExtendedInformation: Codable {
    var title: String
    var videoId: String
    var videoThumbnails: [VideoThumbnailInfo]
    var description: String
    var published: Double
    var publishedText: String
    var viewCount: Double
    var likeCount: Double
    var genre: String
    var author: String
    var authorId: String
    var isListed: Bool
    var liveNow: Bool
    var isUpcoming: Bool
    var formatStreams: [VideoStreamInfo]
    var captions: [CaptionInfo]
    var recommendedVideos: [RecommendedVideoInfo]
}


