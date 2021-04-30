module FriendshipsHelper
  def form_error(_form)
    render partial: 'error' if friendship.errors.any?
  end
end
