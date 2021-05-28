module FriendshipsHelper
def show_error(friendship)
     if friendship.errors.any?
    "<div id='error_explanation'>
      <h2> #{pluralize(friendship.errors.count, 'error')}  prohibited this friendship from being saved:</h2>

      <ul>
      #{ friendship.errors.full_messages.each do |message|}
        <li>#{ message }</li>
       #{ end }
      </ul>
    </div>"
   end

end
