module UsersHelper
  def request_sent(user)
    @user = user
    current_user.sent_requests.any? do |request|
      request.friend_id == @user.id
    end
  end

  def request_received(user)
    @user = user
    current_user.received_requests.any? do |request|
      request.user_id == @user.id
    end
  end

  def check_friendship_status(user, friend)
    user = Friendship.where(user_id: user, friend_id: friend)
    status = user.pluck(:status)
    status[0]
  end

  def show_buttons(user)
    if user.id == current_user.id
      "Name: #{user.name}
      <span class='profile-link'>
        #{link_to 'See My Profile', user_path(user), class: 'profile-link'}
      </span>
      <span>&nbsp</span>
      <span>&nbsp</span>
      <span class='profile-link'>".html_safe
    else
      result =
        "Name: #{user.name}
      <span class='profile-link'>
        #{link_to 'See Profile', user_path(user), class: 'profile-link'}
      </span>
      <span>&nbsp</span>
      <span>&nbsp</span>
      <span class='profile-link'>"

      if request_sent(user)
        result += "<span class= 'profile-link'>
          You already sent a request
        </span>".html_safe
      elsif check_friendship_status(user.id, current_user.id) == 'accept'
        result += "<span class= 'profile-link'>
            You are friends
        </span>".html_safe
      elsif check_friendship_status(user.id, current_user.id) == 'Unconfirmed'
        path = "/friendships/#{Friendship.where(user_id: user, friend_id: current_user.id)[0].id}"
        result += "#{link_to 'Accept friend request', update_request_path(user: current_user.id,
                                                                          friend: user, status: 'accept'),
                             class: 'profile-link'}
        <span>&nbsp</span>
        <span>&nbsp</span>
         #{link_to 'Reject friend request',
                   path, method: :delete,
                         class: 'profile-link'}".html_safe
      else
        result += link_to 'Invite friend', friendships_path(user: @current_user, friend: user),
                          method: :post,
                          class: 'profile-link'.to_s.html_safe
      end
      result.html_safe
    end
  end
end
