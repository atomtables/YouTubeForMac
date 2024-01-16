//
//  ContentView.swift
//  YouTube for Mac
//
//  Created by Adithiya Venkatakrishnan on 26/7/2023.
//

import SwiftUI

enum TabOption: String, CaseIterable {
    case t = "Trending"
    case p = "Popular"
}

struct ContentView: View {
    @AppStorage("apiUrl") var apiUrl: String = "vid.puffyan.us"
    
    @State var textString = "Hello, world!"
    
    @State var urlString: String
    
    init() {
        _urlString = State(initialValue: "")
        _urlString = State(initialValue: "https://\(apiUrl)/api/v1/popular")
        apiUrl = "vid.puffyan.us"
    }
    
    @State var videoData: [VideoInformation]?
    @State var errorOccured = false
    
    @State private var sidebarDidLoad = false
    
    @State var searchString = ""
    
    @State private var selectedOption: TabOption = .p
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchString)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(1)
                        .background(RoundedRectangle(cornerRadius: 2).stroke(Color.white))
                    Button {
                        run()
                    } label: {
                        Image(systemName: "magnifyingglass")
                    }
                }
                .padding(.horizontal)
                Picker("", selection: $selectedOption) {
                    ForEach(TabOption.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                Spacer()
                if let videoData = videoData {
                    if selectedOption == .p {
                        PopularVideoView(videoData: videoData)
                    } else if selectedOption == .t {
                        TrendingVideoView(videoData: videoData)
                    }
                } else if errorOccured {
                    VStack {
                        Image(systemName: "exclamationmark.square.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                        Text("An error occured!")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.bottom, 5)
                        Text("The data failed to load. Please check your internet connection or make sure your Invidious instance is still running!")
                            .multilineTextAlignment(.center)
                            .padding([.bottom, .horizontal])
                    }
                    
                } else {
                    ProgressView()
                }
            }
            .onAppear {
                if sidebarDidLoad == false {
                    run()
                    sidebarDidLoad = true
                }
            }
            .onChange(of: selectedOption) { option in
                if option == .p {
                    urlString = "https://\(apiUrl)/api/v1/popular"
                    run()
                } else if option == .t {
                    urlString = "https://\(apiUrl)/api/v1/trending"
                    run()
                }
            }
            
            VStack {
                Text("Welcome to YouTube for Mac")
                    .font(.title)
                    .fontWeight(.heavy)
                HStack {
                    Image(systemName: "video.fill")
                        .frame(width: 25, height: 25)
                        .padding(5)
                        .background(.red)
                        .cornerRadius(5)
                    Text("Uses the Invidious API, allowing you to change the endpoint at will!")
                        .multilineTextAlignment(.leading)
                }
                HStack {
                    Image(systemName: "swift")
                        .frame(width: 25, height: 25)
                        .padding(5)
                        .background(.orange)
                        .cornerRadius(5)
                    Text("Built from the ground up with SwiftUI, maintaining a fast and native look!")
                        .multilineTextAlignment(.leading)
                }
                HStack {
                    Image(systemName: "shareplay")
                        .frame(width: 25, height: 25)
                        .padding(5)
                        .background(.blue)
                        .cornerRadius(5)
                    //.frame(width: 50, height: 50)
                    Text("Other random shiz that looks good bruh idfk")
                        .multilineTextAlignment(.leading)
                }
                // TODO: make sure to add a way to change the instance of Invidious being used.
            }
        }
    }
    
    func parse(json: Data) {
        let decoder = JSONDecoder()
        
        do {
            let videoDataJSON = try decoder.decode([VideoInformation].self, from: json)
            videoData = videoDataJSON
        } catch {
            print("Error decoding JSON:", error)
            errorOccured = true
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
}

struct TrendingVideoView: View {
    var videoData: [VideoInformation]
    
    var body: some View {
        List(videoData) { video in
            NavigationLink(destination: VideoMoreInfo(videoId: video.videoId)) {
                HStack(alignment: .top) {
                    AsyncImage(url: video.videoThumbnails[0].url) { image in
                        image.resizable()
                            .overlay(
                                {
                                    Text("\(video.lengthSecondsText)")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                        .padding(2)
                                        .background(.black)
                                        .cornerRadius(5.0)
                                }(), alignment: .bottomTrailing)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 120, height: 67.5)
                    VStack(alignment: .leading) {
                        Text(video.title)
                            .font(.subheadline)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        Text(video.author)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 300, maxWidth: .infinity)
    }
}

struct PopularVideoView: View {
    var videoData: [VideoInformation]
    
    var body: some View {
        List(videoData) { video in
            NavigationLink(destination: VideoMoreInfo(videoId: video.videoId)) {
                HStack(alignment: .top) {
                    AsyncImage(url: video.videoThumbnails[0].url) { image in
                        image.resizable()
                            .overlay({
                                    Text("\(video.lengthSecondsText)")
                                        .font(.caption)
                                        .foregroundStyle(.gray)
                                        .padding(2)
                                        .background(.black)
                                        .cornerRadius(5.0)
                                }(), alignment: .bottomTrailing)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 120, height: 67.5)
                    VStack(alignment: .leading) {
                        Text(video.title)
                            .font(.subheadline)
                            .lineLimit(3)
                            .multilineTextAlignment(.leading)
                        Text(video.author)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .listStyle(.sidebar)
        .frame(minWidth: 300, maxWidth: .infinity)
    }
}
