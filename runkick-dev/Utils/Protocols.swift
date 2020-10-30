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
    func handleProfileComplete(for header: UserProfileHeader)
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

protocol StoreItemSelectionCellDelegate {
    func handleItemTapped(for cell: StoreItemSelectionCell)
}


protocol FeedCellDelegate {
    func handleUsernameTapped(for cell: FeedCell)
    func handleOptionTapped(for cell: FeedCell)
    func handleFollowFollowingTapped(for cell: FeedCell)
    func handleLikeTapped(for cell: FeedCell, isDoubleTap: Bool)
    func handlePhotoTapped(for cell: FeedCell)
    func handleCommentTapped(for cell: FeedCell)
    func handleConfigureLikeButton(for cell: FeedCell)
    func handleShowLikes(for cell: FeedCell)
}

protocol UserSpecificFeedCellDelegate {
    func handleUsernameTapped(for cell: UserSpecificFeedCell)
    func handleOptionTapped(for cell: UserSpecificFeedCell)
    func handleFollowFollowingTapped(for cell: UserSpecificFeedCell)
    func handleLikeTapped(for cell: UserSpecificFeedCell, isDoubleTap: Bool)
    func handlePhotoTapped(for cell: UserSpecificFeedCell)
    func handleCommentTapped(for cell: UserSpecificFeedCell)
    func handleConfigureLikeButton(for cell: UserSpecificFeedCell)
    func handleShowLikes(for cell: UserSpecificFeedCell)
}

protocol CheckInCellDelegate {
    func handleUsernameTapped(for cell: CheckInCell)
    func handleOptionTapped(for cell: CheckInCell)
    func handleFollowFollowingTapped(for cell: CheckInCell)
    func handleLikeTapped(for cell: CheckInCell, isDoubleTap: Bool)
    func handlePhotoTapped(for cell: CheckInCell)
    func handleCommentTapped(for cell: CheckInCell)
    func handleConfigureLikeButton(for cell: CheckInCell)
    func handleShowLikes(for cell: CheckInCell)
}

protocol CategoryFeedCellDelegate {

    func handlePhotoTapped(for cell: CategoryFeedCell)
    func handleRedeemAddToCart(for cell: CategoryFeedCell, category: Category?)
}

protocol CheckoutCellDelegate : class {
    func removeItemFromCart(for cell: CheckoutCell, category: Category?)
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

protocol InviteFriendsDelegate {
    func handleInviteFriendsToggle(shouldDismiss: Bool)
}

protocol SettingsControllerDelegate {
    func handleSettingsMenuToggle(shouldDismiss: Bool, settingsMenuOption: SettingsMenuOption?)
}

protocol AdminLoginControllerDelegate {
    func handleAdminLogin(shouldDismiss: Bool)
}

protocol PrivacyStatusControllerDelegate {
    //func handleLoginStatus(adminToggled: Bool)
    func handlePrivacySetting(privacyToggled: Bool)
}

