document.addEventListener("DOMContentLoaded", function() {
  var navigationLinks = document.querySelectorAll(".navigation__link");

  for (i = 0; i < navigationLinks.length; i++) {
    var link = navigationLinks[i];

    if(link.pathname === window.location.pathname) {
      link.classList.add("navigation__link--active");
    }
  }
});
