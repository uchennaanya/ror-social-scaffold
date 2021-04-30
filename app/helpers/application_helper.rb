module ApplicationHelper
  def ish_current_user(_user)
    render partial: 'layouts/current' if current_user
    render partial: 'layouts/not-current' unless current_user
  end

  def ish_notice
    render partial: 'layouts/notice' if notice.present?
  end

  def ish_alert
    render partial: 'layouts/alert' if alert.present?
  end

  def menu_link_to(link_text, link_path)
    class_name = current_page?(link_path) ? 'menu-item active' : 'menu-item'

    content_tag(:div, class: class_name) do
      link_to link_text, link_path
    end
  end

  def like_or_dislike_btn(post)
    like = Like.find_by(post: post, user: current_user)
    if like
      link_to('Dislike!', post_like_path(id: like.id, post_id: post.id), method: :delete)
    else
      link_to('Like!', post_likes_path(post_id: post.id), method: :post)
    end
  end

  def current_user_or_friend?(user)
    current_user == user || current_user.friend?(user)
  end

  def invite_or_pending_btn(user)
    return if current_user_or_friend?(user)

    'Friendship pending' if current_user.pending_friends.include?(user)
  end

  def accept_friendship_with_user(user)
    return if current_user_or_friend?(user)
    return unless current_user.pending_friendship?(user)

    friendship = current_user.pending_friendship(user)
    link_to('Accept', user_friendship_path(friendship.user, friendship.id), method: :put, class: 'profile-link')
  end

  def reject_friendship_with_user(user)
    return if current_user_or_friend?(user)
    return unless current_user.pending_friendship?(user)

    friendship = current_user.pending_friendship(user)
    link_to('Reject', user_friendship_path(friendship.user, friendship.id), method: :delete, class: 'profile-link')
  end

  def accept_friendship(friendship)
    return unless current_user == @user

    link_to('Accept', user_friendship_path(friendship.user, friendship.id), method: :put, class: 'profile-link')
  end

  def reject_friendship(friendship)
    return unless current_user == @user

    link_to('Reject', user_friendship_path(friendship.user, friendship.id), method: :delete, class: 'profile-link')
  end
end
