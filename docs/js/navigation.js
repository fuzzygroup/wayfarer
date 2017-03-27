document.addEventListener("DOMContentLoaded", function() {
  var links = document.querySelectorAll(".navigation__link");

  for (i = 0; i < links.length; i++) {
    var link = links[i];

    if (link.pathname === window.location.pathname) {
      link.classList.add("navigation__link--active");
    }
  }
});
