//
//  PlayerViewModel.swift
//  iTunesChallenge
//
//  Created by Danilo Henrique on 10/05/26.
//

import AVFoundation

@Observable
class PlayerViewModel {
    
    var progress: Double = 0
    var totalDuration: TimeInterval = 0
    var currentTime: TimeInterval {
        progress * totalDuration
    }
    var remainingTime: TimeInterval {
        (totalDuration - currentTime) * -1
    }
    var isRepeating = false
    var isPlaying = false {
        didSet {
            isPlaying ? play() : pause()
        }
    }
    var isScrubbing = false {
        didSet {
            if !isScrubbing {
                seek(to: progress)
            }
        }
    }

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var endObserver: Any?
    private var isSeeking = false
    private var url: URL?
    
    deinit {
        if let observer = timeObserver {
            player?.removeTimeObserver(observer)
        }
        if let observer = endObserver {
            NotificationCenter.default.removeObserver(observer)
        }
        player?.pause()
    }
    
    func load(url: URL) {
        self.url = url
    }
    
    func play() {
        guard let url = url else {
            debugPrint("URL not loaded")
            return
        }
        if player == nil {
            player = AVPlayer(url: url)
            observeProgress()
            observeEnd()
        }
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.pause()
        player = nil
    }
    
    func seek(to progress: Double) {
        guard let duration = player?.currentItem?.duration else { return }
        let seconds = duration.seconds * progress
        let time = CMTime(seconds: seconds, preferredTimescale: 600)
        isSeeking = true
        player?.seek(to: time) { _ in
            self.progress = progress
            self.isSeeking = false
        }
    }
    
    private func observeProgress() {
        let interval = CMTime(seconds: 0.2, preferredTimescale: 600)
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            guard let duration = self.player?.currentItem?.duration.seconds,
                  duration > 0 else { return }
            
            self.totalDuration = duration
            
            if !isScrubbing && !isSeeking {
                self.progress = time.seconds / duration
            }
        }
    }
    
    private func observeEnd() {
        endObserver = NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: player?.currentItem,
            queue: .main
        ) { [weak self] _ in
            guard let self else { return }
            self.player?.seek(to: .zero)
            if isRepeating {
                self.player?.play()
            } else {
                isPlaying = false
            }
        }
    }
}
