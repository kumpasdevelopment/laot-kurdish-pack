const laotStashApp = new Vue({
    el: "#content",
    data: {
        page: "home",
        stashID: 0,
        pass: "0000",
        stashPass: "0000",
        changePage(page) {
            this.page = page;
        },
        setStashData(id, pass, stashPass) {
            this.stashID = id;
            this.pass = pass;
            this.stashPass = stashPass;
        },
        kapat() {
            $.post('http://laot-stashouse/closeNUI', JSON.stringify({}));
            this.page = 'home';
        },
    }
});

key = "";
hidden = "";

$(".row button").click(function(){
    var character = $(this).text();
    if (key.length < 4){
      key = key+character;
      hidden = hidden+"*";
      $("#keypad-display").attr("value", hidden);
    }
  })
  $("#keypad-clear").click(function(){
    key = "";
    hidden = "";
    $("#keypad-display").attr("value", hidden);
  })
  $(".keypad-tryagain").click(function(){
    $(".noaccess").slideUp("slow");
    $(".access").slideUp("slow");
    $(".keys").slideDown("slow");
    $("#keypad-display").attr("disabled", "enabled"); 
    key = "";
    hidden = "";
    $("#keypad-display").attr("value", hidden);
  })
  $("#keypad-enter").click(function(){
    $("#keypad-display").attr("disabled", "disabled"); 
    $(".keys").slideUp("slow",function(){
        if (laotStashApp.page == 'home') {
            if (key == laotStashApp.pass){
                $(".access").slideDown();
                key = "";
                hidden = "";
                
                $(".noaccess").slideUp("slow");
                $(".access").slideUp("slow");
                $(".keys").slideDown("slow");
                $("#keypad-display").attr("disabled", "enabled"); 
                key = "";
                hidden = "";
                $("#keypad-display").attr("value", hidden);
                $.post('http://laot-stashouse/closeNUI', JSON.stringify({}));

                $.post('http://laot-stashouse/openStash', JSON.stringify({
                    id: laotStashApp.stashID
                }));
            } else {
                $(".noaccess").slideDown();
                key = "";
                hidden = "";
            }
        }
      });
})


function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
      if ((new Date().getTime() - start) > milliseconds){
        break;
      }
    }
}

document.onkeydown = function (data) {
    if (data.which == 27 || data.which == 112) {
        laotStashApp.kapat()
    } else if (data.which == 13) { // enter
        
        var textarea = document.getElementsByTagName('textarea');
        if (!$(textarea).is(':focus')) {
            return false;
        }
    }
};

document.onreadystatechange = () => {
    if (document.readyState === "complete") {
        window.addEventListener('message', function(event) {
            if (event.data.type == "enable") {
                document.body.style.display = event.data.isVisible ? "block" : "none";
            } else if (event.data.type == "afterEnable") {
                laotStashApp.setStashData(event.data.id, event.data.pass, event.data.stashPass)
            } else if (event.data.type == "changePage") {
                laotStashApp.changePage(event.data.page)
            }
        });
    };
};
