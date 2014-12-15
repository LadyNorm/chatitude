<script>
      var source = $("#blog-post-template").html();
      var template = Handlebars.compile(source);
      $.ajax({
  type: 'GET',
  url: 'http://chat.api.mks.io/chats'
}).success(function (chats) {
  chats.forEach(function(chat){
    var myNewHTML = template({
        user: chat['user'],
        message: chat['message'],
        time: chat['time']
      });
        $('body').append(myNewHTML);
  })
})
      var anotherHTML = template({
        title: "New Title",
        content: "New Content"
      });
  </script>