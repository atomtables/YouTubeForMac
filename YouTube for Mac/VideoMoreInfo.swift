//
//  VideoMoreInfo.swift
//  YouTube for Mac
//
//  Created by Adithiya Venkatakrishnan on 10/8/2023.
//

import SwiftUI
import AVKit
import AVFoundation

import IOKit
import IOKit.pwr_mgt

let reasonForActivity = "Reason for activity" as CFString
var assertionID: IOPMAssertionID = 0
/*if success == kIOReturnSuccess {
 // Add the work you need to do without the system sleeping here.
 
 success = IOPMAssertionRelease(assertionID);
 // The system will be able to sleep again.
 }*/

struct CaptionTimingInfo {
    var startingTime: Double
    var endingTime: Double
    var text: String
}

struct VideoMoreInfo: View {
    @Environment(\.openWindow) var openWindow
    
    @AppStorage("apiUrl") var apiUrl: String = "par1.iv.ggtyler.dev"
    
    var videoId: String
    var urlString: String {
        return "https://\(apiUrl)/api/v1/videos/\(videoId)"
    }
    
    @State var videoData: VideoExtendedInformation?
    @State var captionInfo: [CaptionTimingInfo]?
    @State var viewHasAppeared = false
    @State var thumbnailHovering = false
    @State var thumbnailClicked = false
    @State var currentTime = 0.0
    @State var timer: Timer?
    @State var isWindowFocused = true
    
    var player: AVPlayer {
        return AVPlayer(url: (videoData?.formatStreams.last!.url)!)
    }
    
    init(videoId: String) {
        self.videoId = videoId
        // self.videoId = "-OXdqXj9IbU"
        
        // self.apiUrl = "par1.iv.ggtyler.dev"
    }
    
    var body: some View {
        ScrollView {
            VStack {
                if videoData != nil {
                    if !thumbnailClicked {
                        AsyncImage(url: videoData?.videoThumbnails[1].url) { image in
                            ZStack {
                                image.resizable()
                                    .overlay {
                                        if thumbnailHovering {
                                            Color.black.opacity(0.3)
                                        }
                                    }
                                if thumbnailHovering {
                                    Image(systemName: "play.square.fill")
                                        .resizable()
                                        .foregroundColor(.accentColor)
                                        .background(.white)
                                        .frame(width: 50, height: 50)
                                        .onTapGesture {
                                            if let captionsURL = videoData?.captions.first?.url {
                                                let session = URLSession.shared
                                                let task = session.dataTask(with: URL(string: "https://" + apiUrl + captionsURL)!) { data, response, error in
                                                    if let data = data {
                                                        DispatchQueue.main.async {
                                                            print(apiUrl)
                                                            print("https://" + apiUrl + captionsURL)
                                                            captionInfo = parseWebVTTSubtitles(data: data)
                                                            print(captionInfo as Any)
                                                            
                                                            /*var timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { timer in
                                                             currentTime = player.currentTime().seconds
                                                             }*/
                                                            
                                                            // print(String(data: data, encoding: .utf8)!)
                                                            if let captionInfo = captionInfo {
                                                                /*ExternalEvents.open = AnyView(
                                                                 
                                                                 )*/
                                                            }
                                                        }
                                                    } else {
                                                        print("Error fetching caption data:", error ?? "Unknown error")
                                                        thumbnailClicked = true
                                                    }
                                                }
                                                task.resume()
                                                thumbnailClicked = true
                                            } else {
                                                /*ExternalEvents.open = AnyView(
                                                 VideoPlayer(player: player) /*{
                                                                              VStack {
                                                                              ForEach(captionInfo, id: \.text) { subtitle in
                                                                              if subtitle.startingTime <= currentTime && currentTime <= subtitle.endingTime {
                                                                              SubtitleOverlay(subtitle: subtitle)
                                                                              }
                                                                              }
                                                                              }
                                                                              .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                                              .aspectRatio(contentMode: .fit)
                                                                              }*/
                                                 .onAppear {
                                                 timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [self] timer in
                                                 self.currentTime = player.currentTime().seconds
                                                 print(self.currentTime)
                                                 }
                                                 
                                                 /*NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: nil, queue: nil) { [self] notification in
                                                  self.timer?.invalidate()
                                                  self.timer = nil
                                                  }*/
                                                 }
                                                 .onDisappear {
                                                 timer?.invalidate()
                                                 }
                                                 )*/
                                                thumbnailClicked = true
                                            }
                                        }
                                }
                            }
                            .onHover { hover in
                                thumbnailHovering = hover
                            }
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(maxWidth: .infinity)
                        .aspectRatio(16/9, contentMode: .fit)
                    } else {
                        if let captionInfo = captionInfo {
                            VideoPlayer(player: player) {
                                VStack {
                                    ForEach(captionInfo, id: \.text) { subtitle in
                                        if subtitle.startingTime <= currentTime && currentTime <= subtitle.endingTime {
                                            SubtitleOverlay(subtitle: subtitle)
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .aspectRatio(contentMode: .fit)
                            }
                            .onAppear {
                                timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [self] timer in
                                    self.currentTime = player.currentTime().seconds
                                    print(player.currentTime().seconds)
                                    //print(self.currentTime)
                                }
                                
                                /*NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: nil, queue: nil) { [self] notification in
                                 self.timer?.invalidate()
                                 self.timer = nil
                                 }*/
                            }
                            .onDisappear {
                                timer?.invalidate()
                                timer = nil
                            }
                            .frame(maxWidth: .infinity)
                            .aspectRatio(16/9, contentMode: .fit)
                        } else {
                            VideoPlayer(player: player)/* {
                                                        VStack {
                                                        ForEach(captionInfo, id: \.text) { subtitle in
                                                        if subtitle.startingTime <= currentTime && currentTime <= subtitle.endingTime {
                                                        SubtitleOverlay(subtitle: subtitle)
                                                        }
                                                        }
                                                        }
                                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                                        .aspectRatio(contentMode: .fit)
                                                        }*/
                                .onAppear {
                                    print("appeared")
                                    player.play()
                                    timer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: true) { [self] timer in
                                        self.currentTime = player.currentTime().seconds
                                        print(self.currentTime)
                                    }
                                    
                                    IOPMAssertionCreateWithName( kIOPMAssertionTypeNoDisplaySleep as CFString,
                                                                 IOPMAssertionLevel(kIOPMAssertionLevelOn),
                                                                 reasonForActivity,
                                                                 &assertionID )
                                    
                                    /*NotificationCenter.default.addObserver(forName: NSWindow.willCloseNotification, object: nil, queue: nil) { [self] notification in
                                     self.timer?.invalidate()
                                     self.timer = nil
                                     }*/
                                }
                                .onDisappear {
                                    print("disappeared")
                                    player.pause()
                                    player.replaceCurrentItem(with: nil)
                                    timer?.invalidate()
                                    timer = nil
                                    IOPMAssertionRelease(assertionID);
                                }
                                .frame(maxWidth: .infinity)
                                .aspectRatio(16/9, contentMode: .fit)
                        }
                    }
                    Text(videoData!.title)
                        .font(.title)
                        .fontWeight(.bold)
                } else {
                    ProgressView()
                }
            }
        }
        .onAppear {
            if viewHasAppeared == false {
                run()
                viewHasAppeared = true
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let videoDataJSON = try decoder.decode(VideoExtendedInformation.self, from: json)
            videoData = videoDataJSON
        } catch {
            print("Error decoding JSON:", error)
        }
    }
    
    func run() {
        videoData = nil
        
        if let url = URL(string: urlString) {
            let session = URLSession.shared
            let task = session.dataTask(with: url) { data, response, error in
                if let data = data {
                    DispatchQueue.main.async {
                        parse(json: data)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseWebVTTSubtitles(data: Data) -> [CaptionTimingInfo] {
        guard let subtitleString = String(data: data, encoding: .utf8) else {
            print("Error decoding subtitle data into a string.")
            return []
        }
        
        return parseWebVTTSubtitles(subtitleString: subtitleString)
    }
    
    func parseWebVTTSubtitles(subtitleString: String) -> [CaptionTimingInfo] {
        
        func removeElementAndReturnArray<T: Equatable>(_ element: T, from array: [T]) -> [T] {
            return array.filter { $0 != element }
        }
        
        var captionInfos: [CaptionTimingInfo] = []
        
        // Split the subtitleString into individual subtitle blocks
        let subtitleBlocks = subtitleString.components(separatedBy: "\n\n")
        
        for block in subtitleBlocks {
            // Split each block into lines
            let lines = block.components(separatedBy: .newlines)
            
            // Extract timing information from the first line (e.g., "00:00:00.000 --> 00:00:05.000")
            if let timingLine = lines.first, timingLine.contains(" --> ") {
                //print("timing information extracted")
                let timingComponents = timingLine.split(separator: " ")
                
                if timingComponents.count >= 3 {
                    //print("timingComponents: \(timingComponents)")
                    let timingRange = timingComponents[1]
                    let timeComponents = removeElementAndReturnArray(timingRange, from: timingComponents)
                    //print("timeComponents: \(timeComponents)")
                    
                    if timeComponents.count == 2,
                       let startTime = parseTime(timeString: String(timeComponents[0])),
                       let endTime = parseTime(timeString: String(timeComponents[1])) {
                        
                        // Join the rest of the lines as the subtitle text
                        let subtitleText = lines.dropFirst().joined(separator: "\n")
                        
                        // Append the caption info
                        let captionInfo = CaptionTimingInfo(startingTime: startTime, endingTime: endTime, text: subtitleText)
                        captionInfos.append(captionInfo)
                    }
                } else {
                    print("captions are corrupt")
                    return []
                }
            }
        }
        
        return captionInfos
    }
    
    func parseTime(timeString: String) -> Double? {
        let components = timeString.trimmingCharacters(in: .whitespaces).split(separator: ":")
        let secondsAndMilliseconds = components[2].split(separator: ".")
        if components.count == 3,
           let hours = Double(components[0]),
           let minutes = Double(components[1]),
           secondsAndMilliseconds.count == 2,
           let seconds = Double(secondsAndMilliseconds[0]),
           let milliseconds = Double(secondsAndMilliseconds[1]) {
            let totalSeconds = hours * 3600 + minutes * 60 + seconds
            let totalMilliseconds = milliseconds / 1000.0
            return totalSeconds + totalMilliseconds
        }
        return nil
    }
}


struct VideoPlayerView: View {
    var body: some View {
        ExternalEvents.open
    }
}

public struct ExternalEvents {
    /// - warning: Don't use it, it's used internally.
    /// ==============================================
    public static var open: AnyView? = AnyView(
        VStack {
            Text("If you see this, you need to close this window, and restart the App. Next time, make sure you close out the player window before quitting the application.")
        }
    )
}

struct SubtitleOverlay: View {
    let subtitle: CaptionTimingInfo
    
    var body: some View {
        Text(subtitle.text)
            .font(.caption)
            .foregroundColor(.white)
            .background(Color.black.opacity(0.7))
            .padding(5)
            .frame(maxWidth: .infinity, alignment: .center)
            .minimumScaleFactor(0.5)
            .lineLimit(2)
        // .offset(x: 0, y: -20) // Adjust the y offset here
    }
}

import Combine

class PlayerTimeObserver {
    let publisher = PassthroughSubject<TimeInterval, Never>()
    private var timeObservation: Any?
    
    init(player: AVPlayer) {
        // Periodically observe the player's current time, whilst playing
        timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 0.5, preferredTimescale: 600), queue: nil) { [weak self] time in
            guard let self = self else { return }
            // Publish the new player time
            self.publisher.send(time.seconds)
        }
    }
}

