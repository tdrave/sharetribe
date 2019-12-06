$(function(){

    $('.private-check').on('change', function () {
       var checked = $(this).prop('checked'),
           private_content = $('.private-check-content');
       if (checked) {
           private_content.removeClass('opacity_04');
       } else {
           private_content.addClass('opacity_04');
       }
    });

});
