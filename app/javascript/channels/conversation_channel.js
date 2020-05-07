import consumer from "./consumer"

consumer.subscriptions.create("ConversationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    if(data.message){
      var conversation = $('#conversations-list').find("[data-conversation-id='" + data.message.conversation_id + "']");
      var body_message = '<li> <div class="row">' + 
                         '<div class="message-received">' + 
                         `${data.message.body}` + 
                         '</div> </div> </li>';
      conversation.find('.messages-list').find('ul').append(body_message);
      
      //update notifications message
      if((document.getElementById("ib"+data.sender.id)) === null){
        let sender_link = '<li id="ib' + `${data.sender.id}` + '">' +
                          '<a data-remote="true" rel="nofollow" data-method="post"' + 
                          'href="/conversations?user_id=' + `${data.sender.id}` + '">' + 
                          `${data.sender.name}` + '</a> </li>'
        $("#conversations-group").append(sender_link);
        let sum_ib = document.getElementById("sum-ib");
        sum_ib.textContent = parseInt(sum_ib.textContent) + 1
      }

      // scroll button bottom
      var messages_list = conversation.find('.messages-list');
      if(messages_list){
        var height = messages_list[0].scrollHeight;
        messages_list.scrollTop(height);
      }
    }
  }
})
