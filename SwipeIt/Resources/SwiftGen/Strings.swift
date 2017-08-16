// Generated using SwiftGen, by O.Halligon — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable file_length

// swiftlint:disable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
  /// Retry
  static let retry = L10n.tr("Localizable", "Retry")

  enum Alert {

    enum Button {
      /// Cancel
      static let cancel = L10n.tr("Localizable", "Alert.Button.Cancel")
      /// OK
      static let ok = L10n.tr("Localizable", "Alert.Button.OK")
    }
  }

  enum Closeable {

    enum Button {
      /// Close
      static let close = L10n.tr("Localizable", "Closeable.Button.Close")
    }
  }

  enum Link {
    /// comment
    static let comment = L10n.tr("Localizable", "Link.Comment")
    /// comments
    static let comments = L10n.tr("Localizable", "Link.Comments")
    /// Downvote
    static let downvote = L10n.tr("Localizable", "Link.Downvote")
    /// Open in Safari
    static let openInSafari = L10n.tr("Localizable", "Link.OpenInSafari")
    /// Report
    static let report = L10n.tr("Localizable", "Link.Report")
    /// Save
    static let save = L10n.tr("Localizable", "Link.Save")
    /// Unsave
    static let unsave = L10n.tr("Localizable", "Link.Unsave")
    /// Upvote
    static let upvote = L10n.tr("Localizable", "Link.Upvote")

    enum Content {

      enum Selfpost {
        /// Read more
        static let readMore = L10n.tr("Localizable", "Link.Content.SelfPost.ReadMore")
      }
    }

    enum Context {
      /// Locked
      static let locked = L10n.tr("Localizable", "Link.Context.Locked")
      /// Stickied
      static let stickied = L10n.tr("Localizable", "Link.Context.Stickied")
    }

    enum Indicator {
      /// Album
      static let album = L10n.tr("Localizable", "Link.Indicator.Album")
      /// GIF
      static let gif = L10n.tr("Localizable", "Link.Indicator.GIF")
      /// NSFW
      static let nsfw = L10n.tr("Localizable", "Link.Indicator.NSFW")
      /// Spoiler
      static let spoiler = L10n.tr("Localizable", "Link.Indicator.Spoiler")
    }

    enum Report {
      /// Breaking reddit
      static let breakingReddit = L10n.tr("Localizable", "Link.Report.BreakingReddit")
      /// Other
      static let other = L10n.tr("Localizable", "Link.Report.Other")
      /// Personal information
      static let personalInfo = L10n.tr("Localizable", "Link.Report.PersonalInfo")
      /// Sexualizing minors
      static let sexualizingMinors = L10n.tr("Localizable", "Link.Report.SexualizingMinors")
      /// Spam
      static let spam = L10n.tr("Localizable", "Link.Report.Spam")
      /// Vote manipulation
      static let voteManipulation = L10n.tr("Localizable", "Link.Report.VoteManipulation")

      enum Other {
        /// Other reason (max 100 characters)
        static let hint = L10n.tr("Localizable", "Link.Report.Other.Hint")
        /// What other rule does it break?
        static let reason = L10n.tr("Localizable", "Link.Report.Other.Reason")
      }
    }

    enum Score {
      /// hidden
      static let hidden = L10n.tr("Localizable", "Link.Score.Hidden")
    }
  }

  enum Listingtype {
    /// Controversial
    static let controversial = L10n.tr("Localizable", "ListingType.Controversial")
    /// Gilded
    static let gilded = L10n.tr("Localizable", "ListingType.Gilded")
    /// Hot
    static let hot = L10n.tr("Localizable", "ListingType.Hot")
    /// New
    static let new = L10n.tr("Localizable", "ListingType.New")
    /// Rising
    static let rising = L10n.tr("Localizable", "ListingType.Rising")
    /// Top
    static let top = L10n.tr("Localizable", "ListingType.Top")

    enum Range {
      /// All-time
      static let allTime = L10n.tr("Localizable", "ListingType.Range.AllTime")
      /// Past 24 hours
      static let day = L10n.tr("Localizable", "ListingType.Range.Day")
      /// Past hour
      static let hour = L10n.tr("Localizable", "ListingType.Range.Hour")
      /// Past month
      static let month = L10n.tr("Localizable", "ListingType.Range.Month")
      /// Past week
      static let week = L10n.tr("Localizable", "ListingType.Range.Week")
      /// Past year
      static let year = L10n.tr("Localizable", "ListingType.Range.Year")
    }
  }

  enum Login {
    /// Login
    static let title = L10n.tr("Localizable", "Login.Title")

    enum Error {
      /// Login error
      static let title = L10n.tr("Localizable", "Login.Error.Title")
      /// Could not log in. Please try again later
      static let unknown = L10n.tr("Localizable", "Login.Error.Unknown")
      /// Login was cancelled
      static let userCancelled = L10n.tr("Localizable", "Login.Error.UserCancelled")
    }
  }

  enum Subscriptions {
    /// Subscriptions
    static let title = L10n.tr("Localizable", "Subscriptions.Title")
  }

  enum Walkthrough {

    enum Button {
      /// Login
      static let login = L10n.tr("Localizable", "Walkthrough.Button.Login")
    }
  }
}
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name

extension L10n {
  fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
    let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
    return String(format: format, locale: Locale.current, arguments: args)
  }
}

private final class BundleToken {}
