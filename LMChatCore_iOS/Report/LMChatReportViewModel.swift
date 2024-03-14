//
//  LMChatReportViewModel.swift
//  LMChatCore_iOS
//
//  Created by Pushpendra Singh on 06/03/24.
//

import Foundation
import LikeMindsChat

public typealias ReportContentID = (chatroomId: String?, messageId: String?, memberId: String?)

public final class LMChatReportViewModel {
    
    weak var delegate: LMChatReportViewModelProtocol?
    let chatroomId: String?
    let messageId: String?
    let memberId: String?
    let contentType: ReportEntityType
    var reportTags: [(String, Int)]
    var selectedTag: Int
    let otherTagID: Int
    
    var entityID: String {
        chatroomId ?? messageId ?? memberId ?? ""
    }
    
    init(delegate: LMChatReportViewModelProtocol?, reportContentId: ReportContentID) {
        self.delegate = delegate
        self.reportTags = []
        self.selectedTag = -1
        self.otherTagID = 11
        
        self.chatroomId = reportContentId.chatroomId
        self.messageId = reportContentId.memberId
        self.memberId = reportContentId.memberId
        
        if self.chatroomId != nil {
            self.contentType = .chatroom
        } else if messageId != nil {
            self.contentType = .message
        } else {
            self.contentType = .member
        }
    }
    
    public static func createModule(reportContentId: ReportContentID) throws -> LMChatReportViewController {
        guard LMChatMain.isInitialized else { throw LMChatError.chatNotInitialized }
        
        let viewcontroller = LMCoreComponents.shared.reportScreen.init()
        let viewmodel = Self.init(delegate: viewcontroller, reportContentId: (nil,nil,nil))
        
        viewcontroller.viewmodel = viewmodel
        return viewcontroller
    }
    
    func fetchReportTags() {
        delegate?.showHideLoaderView(isShow: true)
        
        let request = GetReportTagsRequest.builder()
            .type(3)
            .build()
        
        LMChatClient.shared.getReportTags(request: request) { [weak self] response in
            guard let self, let tags = response.data?.tags else { return }
            delegate?.showHideLoaderView(isShow: false)
            
            if tags.isEmpty {
                delegate?.showError(with: response.errorMessage ?? LMStringConstant.shared.genericErrorMessage, isPopVC: true)
                return
            }
            
            reportTags = tags.compactMap({ tag in
                (tag.name ?? "NA", tag.id ?? 0)
            })
            delegate?.updateView(with: reportTags, selectedTag: selectedTag, showTextView: selectedTag == otherTagID)
        }
    }
    
    func updateSelectedTag(with id: Int) {
        selectedTag = id
        delegate?.updateView(with: reportTags, selectedTag: selectedTag, showTextView: selectedTag == otherTagID)
    }
    
    func reportContent(reason: String?) {
        guard let tagName = reportTags.first(where: { $0.1 == selectedTag }) else { return }
        
        let reasonName = reason ?? tagName.0
        
        delegate?.showHideLoaderView(isShow: true)
        let request = PostReportRequest.builder(tagId: selectedTag)
            .reason(reason)
            .reportedLink(nil)
            .reportedChatroomId(chatroomId)
            .reportedConversationId(messageId)
            .uuid(memberId)
            .build()
        
        LMChatClient.shared.postReport(request: request) { [weak self] response in
            self?.delegate?.showHideLoaderView(isShow: false)
            guard let self, response.success else {
                self?.delegate?.showError(with: response.errorMessage ?? "", isPopVC: true)
                return
            }
            
            let title = "\(contentType.rawValue) is reported for review"
            let message = "Our team will look into your feedback and will take appropriate action on this \(contentType.rawValue)"
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
                self?.delegate?.popViewController(animated: true)
            })
        }
    }

}
