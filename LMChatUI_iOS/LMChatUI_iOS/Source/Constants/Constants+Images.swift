//
//  Constants+Images.swift
//  LMFramework
//
//  Created by Devansh Mohata on 12/12/23.
//

import UIKit

extension UIImage {
    convenience init?(named name: String, in bundle: Bundle) {
        self.init(named: name, in: bundle, compatibleWith: nil)
    }
}

public extension Constants {
    struct Images {
        private init() { }
        
        /// Need For These Methods - A Develeoper can also set custom images in these variables we need to make sure that dev is not setting these images as nil, so get non-optional value of UIImage without force unwrapping.
        static func loadImage(with imageName: String) -> UIImage {
            UIImage(named: imageName, in: Bundle.LMBundleIdentifier) ?? .circleImage
        }
        
        static func loadSystemImage(with imageName: String) -> UIImage {
            UIImage(systemName: imageName) ?? .circleImage
        }
        
        // Shared Instance
        public static var shared = Images()
        
        // Images
        public var heart = loadSystemImage(with: "heart")
        public var heartFilled = loadSystemImage(with: "heart.fill")
        public var commentIcon = loadSystemImage(with: "message")
        public var bookmark = loadSystemImage(with: "bookmark")
        public var bookmarkFilled = loadSystemImage(with: "bookmark.fill")
        public var shareIcon = loadSystemImage(with: "arrowshape.turn.up.right")
        public var xmarkIcon = loadSystemImage(with: "xmark")
        public var crossIcon = loadSystemImage(with: "xmark.circle")
        public var ellipsisIcon = loadSystemImage(with: "ellipsis")
        public var paperplaneFilled = loadSystemImage(with: "paperplane.fill")
        public var paperplaneIcon = loadSystemImage(with: "paperplane")
        public var pencilIcon = loadSystemImage(with: "pencil")
        public var downArrow = loadSystemImage(with: "arrow.down")
        public var menuIcon = loadSystemImage(with: "line.3.horizontal")
        public var personIcon = loadSystemImage(with: "person")
        public var checkmarkIconFilled = loadSystemImage(with: "checkmark.circle.fill")
        public var plusIcon = loadSystemImage(with: "plus")
        public var notificationBell = loadSystemImage(with: "bell.fill")
        public var documentsIcon = loadSystemImage(with: "doc.fill")
        public var galleryIcon = loadSystemImage(with: "photo")
        
        public var pdfIcon = loadImage(with: "pdfIcon")
        public var placeholderImage = loadImage(with: "placeholderImage")
        public var brokenLink = loadImage(with: "brokenLink")
        public var videoIcon = loadImage(with: "videoIcon")
        public var paperclipIcon = loadImage(with: "paperclip")
        public var createPostIcon = loadImage(with: "createPostIcon")
        
        public var lockFillIcon = loadSystemImage(with: "lock.fill")
        public var annoucementIcon = loadSystemImage(with: "speaker.zzz.fill")
        public var personCircleFillIcon = loadSystemImage(with: "person.circle.fill")
        public var muteFillIcon = loadSystemImage(with: "speaker.slash.fill")
        public var tagFillIcon = loadSystemImage(with: "tag.fill")
        public var rightArrowIcon = loadSystemImage(with: "chevron.right")
        public var checkmarkCircleIcon = loadSystemImage(with: "checkmark.circle")
        public var leftArrowIcon = loadSystemImage(with: "chevron.left")
    }
}
