// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require_tree .

function remove_fields(link) {
  $(link).prev("input[type=hidden]").val("1");
  $(link).closest(".fields").hide();
}

function add_fields(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g")
  $(link).parent().before(content.replace(regexp, new_id));
}

$(document).on('page:change', function() {
  $(".user-profile").on("click", ".btn-toggle", function() {
    var parent = $(this).parents(".course-listing");
    parent.find(".item").toggleClass("hide");
    if ($(this).text() === "Show") {
      $(this).text("Hide");
    } else {
      $(this).text("Show");
    }
  });

  $("#load_more").click(function(e){
    e.preventDefault();
    var url = $('.pagination .next_page').attr('href');
    $.getScript(url);
  });
})


