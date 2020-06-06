//
//  Protocols.swift
//  runkick-dev
//
//  Created by Cameron Frasier on 8/31/19.
//  Copyright © 2019 Cameron Frasier. All rights reserved.
//

import Foundation
import MapKit

protocol UserProfileHeaderDelegate {
    func handleEditFollowTapped(for header: UserProfileHeader)
    func handleAddPhotoTapped(for header: UserProfileHeader)
    func setUserStats(for header: UserProfileHeader)
    func setAdminNavigationBar(for header: UserProfileHeader)
    func handleFollowersTapped(for header: UserProfileHeader)
    func handleFollowingTapped(for header: UserProfileHeader)
    func handlePostTapped(for header: UserProfileHeader)
    func handleCheckInTapped(for header: UserProfileHeader)
    func handlePointsTapped(for header: UserProfileHeader)
    func handleDistanceTapped(for header: UserProfileHeader)
    func handleMessagesTapped(for header: UserProfileHeader)
    func handleAnalyticsTapped(for header: UserProfileHeader)
    func handleFavoritesTapped(for header: UserProfileHeader)
    func handledSearchFriendsTapped(for header: UserProfileHeader)
    func handleSearchGroupsTapped(for header: UserProfileHeader)
    func handleGridViewTapped(for header: UserProfileHeader)
    func handleActivityTapped(for header: UserProfileHeader)
}

// will be able to delete this protocol
protocol AdminProfileHeaderDelegate {
    func handleEditFollowTapped(for header: AdminProfileHeader)
    func setUserStats(for header: AdminProfileHeader)
    func handleAddPhotoTapped(for header: AdminProfileHeader)
    func handleFollowersTapped(for header: AdminProfileHeader)
    func handleFollowingTapped(for header: AdminProfileHeader)
    func handlePostTapped(for header: AdminProfileHeader)
    func handleAnalyticsTapped(for header: AdminProfileHeader)
    func handleFavoritedTapped(for header: AdminProfileHeader)
    func handleStoreAccountTapped(for header: AdminProfileHeader)
    func handleModifyPointsTapped(for header: AdminProfileHeader)
}

protocol FollowLikeCellDelegate {
    func handleFollowTapped(for cell: FollowLikeCell)
}

protocol FeedCellDelegate {
    func handleUsernameTapped(for cell: FeedCell)
    func handleOptionTapped(for cell: FeedCell)
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool)
    func handlePhotoTapped(for cell: FeedCell)
    func handleCommentTapped(for cell: FeedCell)
    func handleConfigureLikeButton(for cell: FeedCell)
    func handleShowLikes(for cell: FeedCell)
}

protocol CategoryFeedCellDelegate {
    func handlePhotoTapped(for cell: CategoryFeedCell)
}

protocol AdminStorePostCellDelegate {
    func handlePhotoTapped(for cell: AdminStorePostCell)
    func handleOptionTapped(for cell: AdminStorePostCell)
}

protocol Printable {
    var description: String { get }
}

protocol NotificationCellDelegate {
    
    func handleFollowTapped(for cell: NotificationsCell)
    func handlePostTapped(for cell: NotificationsCell)
}

protocol CommentInputAccessoryViewDelagate {
    func didSubmit(forComment comment: String)
}

protocol HomeControllerDelegate {
    func handleMenuToggle(shouldDismiss: Bool, menuOption: MenuOption?)
    func handleRightMenuToggle(shouldDismiss: Bool, rightMenuOption: RightMenuOption?)
    func handleProfileToggle(shouldDismiss: Bool)
}

protocol SettingsControllerDelegate {
    func handleSettingsMenuToggle(shouldDismiss: Bool, settingsMenuOption: SettingsMenuOption?)
}

protocol AdminLoginControllerDelegate {
    func handleAdminLogin(shouldDismiss: Bool)
}

protocol AdminStatusControllerDelegate {
    func handleLoginStatus(adminToggled: Bool)
}

