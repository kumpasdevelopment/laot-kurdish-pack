const drugApp = new Vue({
    el: "#content",
    data: {
        page: "answer1",
        changePage(page) {
            this.page = page;
        },
        kapat() {
            this.changePage("answer1")
            $.post('http://laot-drugs/kapat', JSON.stringify({}));
        },
        postAnswer(id, query) {
            $.post('http://laot-drugs/setAnswer', JSON.stringify({
                id: id,
                query: query,
            }));
        },
    }
});

function sleep(milliseconds) {
    var start = new Date().getTime();
    for (var i = 0; i < 1e7; i++) {
      if ((new Date().getTime() - start) > milliseconds){
        break;
      }
    }
  }

  document.onkeydown = function (data) {
    if (data.which == 27 || data.which == 112) { // ESC or F1
        drugApp.kapat()
    } else if (data.which == 13) { // enter
        /* stop enter key from crashing MDT in an input?  */
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
            } else if (event.data.type == "afterPage") {
                drugApp.changePage(event.data.page);
            };
        });
    };
};