//
//  LMHomeFeedViewModel.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 12/02/24.
//

import Foundation
import LikeMindsChat

public protocol LMHomeFeedViewModelProtocol: AnyObject {
    func reloadData()
    func updateHomeFeedChatroomsData()
    func updateHomeFeedExploreCountData()
}

public class LMHomeFeedViewModel {
    
    weak var delegate: LMHomeFeedViewModelProtocol?
    var chatrooms: [Chatroom] = []
    var exploreTabCountData: GetExploreTabCountResponse?
    
    init(_ viewController: LMHomeFeedViewModelProtocol) {
        self.delegate = viewController
    }
    
    public static func createModule() throws -> LMHomeFeedViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewController = LMCoreComponents.shared.homeFeedScreen.init()
        viewController.viewModel = LMHomeFeedViewModel(viewController)
        return viewController
    }
    
    func getChatrooms() {
        LMChatClient.shared.getChatrooms(withObserver: self)
    }
    
    func syncChatroom() {
        LMChatClient.shared.syncChatrooms()
    }
    
    func getExploreTabCount() {
        LMChatClient.shared.getExploreTabCount {[weak self] response in
            guard let exploreTabCountData = response.data else { return }
            self?.exploreTabCountData = exploreTabCountData
            self?.delegate?.updateHomeFeedExploreCountData()
        }
    }
}

extension LMHomeFeedViewModel: HomeFeedClientObserver {
    
    public func initial(_ chatrooms: [Chatroom]) {
        self.chatrooms = chatrooms
        self.delegate?.updateHomeFeedChatroomsData()
    }
    
    public func onChange(removed: [Int], inserted: [(Int, Chatroom)], updated: [(Int, Chatroom)]) {
        print("Chatrooms data changed")
        removed.forEach { index in
            chatrooms.remove(at: index)
        }
        updated.forEach { data in
            chatrooms[data.0] = data.1
        }
        inserted.forEach { data in
            chatrooms.insert(data.1, at: data.0)
        }
        self.delegate?.updateHomeFeedChatroomsData()
    }
}
