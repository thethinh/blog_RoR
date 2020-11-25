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
    else if(data.content_relationship){
      var requestConnect = '<li id="sub-request-connect'+`${data.id_relationship}`+'">'+
                            '<p>'+
                              '<a style="color: cornflowerblue;" href="/users/'+ `${data.content_relationship.id}`+'">'+`${data.content_relationship.name}`+'</a>'+
                              ' want to follow you'+
                            '</p>'+
                            '<span>'+
                              '<a class="btn button-accept-connect" role="button" data-remote="true" href="/accept_connect_request?follower_id='+`${data.content_relationship.id}`+'&id_name=sub-request-connect'+`${data.id_relationship}`+'">Accept</a>'+
                              '<a class="btn button-decline-connect" role="button" data-remote="true" href="/decline_connect_request?follower_id='+`${data.content_relationship.id}`+'&id_name=sub-request-connect'+`${data.id_relationship}`+'">Decline</a>'+
                            '</span>'+
                          '</li>'
      $("#sum-notify-connect-request").text(parseInt($("#sum-notify-connect-request").text())+1);
      $("#notification-request-connect").append(requestConnect);
    }
    else if(data.user_relationship){
      var all_notifications = document.querySelectorAll("#notifications-alert");
      var notification = $("#notifications-alert").clone();
      var text = '<a href="/users/'+`${data.user_relationship.id}`+'">'+`${data.user_relationship.name}`+' đã chấp nhận lời mời theo dõi của bạn</a>';
      notification[0].style.display = "block";
      notification.find(".text-notification").append(text)

      if(all_notifications.length > 3){
        all_notifications[all_notifications.length-3].remove()
      }
      $(".notifications-box").append(notification)
    }
    else if(data.user_decline_relationship){
      var all_notifications = document.querySelectorAll("#notifications-alert");
      var notification = $("#notifications-alert").clone();
      var text = '<a href="/users/'+`${data.user_decline_relationship.id}`+'">'+`${data.user_decline_relationship.name}`+' đã từ chối lời mời theo dõi của bạn</a>';
      notification[0].style.display = "block";
      notification.find(".text-notification").append(text)

      if(all_notifications.length > 3){
        all_notifications[all_notifications.length-3].remove()
      }
      $(".notifications-box").append(notification)
    }
  }
});
