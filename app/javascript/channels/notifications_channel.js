import consumer from "./consumer"

consumer.subscriptions.create("NotificationsChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    if(data.content){

      var all_notifications = document.querySelectorAll("#notifications-alert");
      var notification = $("#notifications-alert").clone();
      notification[0].style.display = "block";
      notification.children($(".text-notification"))[1].append(data.content)

      if(all_notifications.length > 3){
        all_notifications[all_notifications.length-3].remove()
      }
      $(".notifications-box").append(notification)
    }
  }
});
