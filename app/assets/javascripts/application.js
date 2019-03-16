// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
////added for maps
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require jquery.cookie
//= require jquery.remotipart
//= require moment
//= require underscore
//= require gmaps/google
//= require fullcalendar
//= require fullcalendar/gcal
//= require jquery.dataTables.js
//= require jquery.dataTables.min
//= require jquery.inputmask
//= require jquery.validate
//= require bootstrap-table.js
//= require bootstrap-table.min
//= require jquery.balloon.min
//= require jquery.cookie
//= require jquery.tablesorter.js
//= require jquery.tablesorter.widgets
//= require select2
//= require cocoon
//= require markerclusterer
//= require underscore-min
//= require_tree .

$(function() {
    setTimeout((function() {
        $('.alert').fadeOut();
    }), 10000);
});
