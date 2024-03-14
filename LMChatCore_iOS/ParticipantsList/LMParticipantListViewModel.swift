//
//  LMParticipantListViewModel.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 16/02/24.
//

import Foundation
import LikeMindsChat

public protocol LMParticipantListViewModelProtocol: AnyObject {
    func reloadData()
}

public class LMParticipantListViewModel {
    
    weak var delegate: LMParticipantListViewModelProtocol?
    var participants: [Member] = []
    var pageNo: Int = 1
    var pageSize: Int = 20
    var chatroomId: String
    var isSecretChatroom: Bool = false
    var participantsContentModels: [LMParticipantCell.ContentModel] = []
    var totalParticipantCount: Int = 0
    var isParticipantLoading: Bool = false
    var isAllParticipantLoaded: Bool = false
    
    init(_ viewController: LMParticipantListViewModelProtocol, chatroomId: String, isSecret: Bool) {
        self.delegate = viewController
        self.chatroomId = chatroomId
        self.isSecretChatroom = isSecret
    }
    
    public static func createModule(withChatroomId chatroomId: String, isSecretChatroom isSecret: Bool = false) throws -> LMParticipantListViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        let viewController = LMCoreComponents.shared.participantListScreen.init()
        viewController.viewModel = LMParticipantListViewModel(viewController, chatroomId: chatroomId, isSecret: isSecret)
        return viewController
    }
    
    func getParticipants() {
        guard !isParticipantLoading else { return }
        let request = GetParticipantsRequest.builder()
            .chatroomId(chatroomId)
            .page(pageNo)
            .pageSize(pageSize)
            .isChatroomSecret(isSecretChatroom)
            .build()
        isParticipantLoading = true
        LMChatClient.shared.getParticipants(request: request) {[weak self] response in
            guard let self, let participantsData = response.data?.participants, !participantsData.isEmpty else { return }
            totalParticipantCount = response.data?.totalParticipantsCount ?? 0
            pageNo += 1
            participants.append(contentsOf: participantsData)
            participantsContentModels.append(contentsOf: participantsData.compactMap({
                .init(name: $0.name ?? "", designationDetail: nil, profileImageUrl: $0.imageUrl, customTitle: $0.customTitle)
            }))
            delegate?.reloadData()
            isAllParticipantLoaded = (totalParticipantCount == participants.count)
            isParticipantLoading = false
        }
    }
    
}
