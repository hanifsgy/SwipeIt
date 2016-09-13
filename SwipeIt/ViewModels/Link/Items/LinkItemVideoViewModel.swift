//
//  LinkVideoViewModel.swift
//  Reddit
//
//  Created by Ivan Bruel on 10/05/16.
//  Copyright © 2016 Faber Ventures. All rights reserved.
//

import Foundation
import RxSwift

// MARK: Properties and initializer
class LinkItemVideoViewModel: LinkItemViewModel {

  private static let webMetaTag =
  "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1, maximum-scale=1\">"

  // MARK: Public Properties
  let imageURL: NSURL?
  let videoURL: NSURL
  let videoHTML: String?

  override init(user: User, accessToken: AccessToken, link: Link, showSubreddit: Bool) {
    imageURL = link.imageURL
    videoURL = link.url
    if let embeddedMedia = link.secureEmbeddedMedia {
      let iFrame = embeddedMedia.content.stringByDecodingHTMLEntities
      let videoHTML = iFrame
        .stringByReplacingOccurrencesOfString("\"\(embeddedMedia.width)\"", withString: "\"100%\"")
        .stringByReplacingOccurrencesOfString("\"\(embeddedMedia.height)\"", withString: "\"100%\"")
      self.videoHTML = "<head>\(LinkItemVideoViewModel.webMetaTag)</head><body>\(videoHTML)</body>"
    } else {
      self.videoHTML = nil
    }
    super.init(user: user, accessToken: accessToken, link: link, showSubreddit: showSubreddit)
  }
}
