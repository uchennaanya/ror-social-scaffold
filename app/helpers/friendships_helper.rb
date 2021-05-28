module FriendshipsHelper
  def show_error(friendship)
    return unless friendship.errors.any?

    result = "<div id='error_explanation'>
            <h2> #{pluralize(friendship.errors.count, 'error')}  prohibited this friendship from being saved:</h2>

            <ul>"
    friendship.errors.full_messages.each do |message|
      result += "<li>#{message}</li>"
    end
    result += "</ul>
            </div>"
    result.html_safe
  end
end
