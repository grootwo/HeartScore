//
//  GameCenterManager.swift
//  HeartScore
//
//  Created by Groo on 10/23/24.
//

import Foundation
import GameKit

//
//  GameCenterManager.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import GameKit

class GameCenterManager: NSObject, GKGameCenterControllerDelegate, ObservableObject {
    let leaderboardID: String = "leaderboard"
    
    // MARK: 게임 센터 계정 인증하기
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
        print("game center: authenticated user")
    }
    
    // MARK: 순위표 점수 업데이트 하기
    func submitPoint(point: Int) async {
        let formerPoint = await loadFormerPoint()
        if formerPoint == -1 {
            print("Error: cannot load former point from leaderboard.")
            GKLeaderboard.submitScore(Int(point), context: 0, player: GKLocalPlayer.local,
                                      leaderboardIDs: [leaderboardID]) { error in
                if error != nil {
                    print("Error: \(error!.localizedDescription).")
                }
            }
        } else {
            GKLeaderboard.submitScore(formerPoint + Int(point), context: 0, player: GKLocalPlayer.local,
                                      leaderboardIDs: [leaderboardID]) { error in
                if error != nil {
                    print("Error: \(error!.localizedDescription).")
                }
            }
        }
        print("game center: updated leaderboard")
        // TODO: 78계단 이외 계단이 생길 때 수정하기
        reportFirstAchievement(achievementID: "firstheart")
        report10Achievement(achievementID: "heart10")
        report30Achievement(achievementID: "heart30")
    }
    
    func loadFormerPoint() async -> Int {
        let leaderboards = try? await GKLeaderboard.loadLeaderboards(IDs: [leaderboardID])
        guard let leaderboard = leaderboards?.first else { return -1 }
        let entries = try? await leaderboard.loadEntries(for: [GKLocalPlayer.local],
                                                         timeScope: GKLeaderboard.TimeScope.today)
        guard let entry = entries?.1.first else { return -1 }
        print("former point: \(entry.score)")
        return entry.score
    }
    
    // MARK: 성취 업데이트하기
    // TODO: 기존 completion을 불러오질 못하는 중~!
    func reportFirstAchievement(achievementID: String) {
        let achievement = GKAchievement(identifier: achievementID)
        if !achievement.isCompleted {
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
        }
        reportAchievement(achievement: achievement)
    }
    
    func report10Achievement(achievementID: String) {
        let achievement = GKAchievement(identifier: achievementID)
        print("\(achievementID): \(achievement.percentComplete)")
        achievement.percentComplete = achievement.percentComplete + 10.0
        achievement.showsCompletionBanner = true
        reportAchievement(achievement: achievement)
    }
    
    func report30Achievement(achievementID: String) {
        let achievement = GKAchievement(identifier: achievementID)
        print("\(achievementID): \(achievement.percentComplete)")
        achievement.percentComplete = achievement.percentComplete + 3.0
        achievement.showsCompletionBanner = true
        reportAchievement(achievement: achievement)
    }
    
    func reportAchievement(achievement: GKAchievement) {
        GKAchievement.report([achievement], withCompletionHandler: {(error: Error?) in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
        })
        print("game center: updated achievement")
    }
    
    // MARK: 순위표 보기
    func showLeaderboard() {
        let viewController = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .friendsOnly, timeScope: .allTime)
        viewController.gameCenterDelegate = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }

    // MARK: 성취 보기
    func showAchievements() {
        let viewController = GKGameCenterViewController(state: .achievements)
        viewController.gameCenterDelegate = self

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }

    // MARK: Game Center 뷰 컨트롤러 닫기 핸들러
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
