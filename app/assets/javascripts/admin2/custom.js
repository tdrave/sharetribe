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

    $('.change-file').on('change', function() {
       var place = $(this).parents('.custom-file').find('.choose-filename');
       place.hide();
    });

    if ($('#colorpicker-slogan').length) {
        $("#colorpicker-slogan, #colorpicker-description").spectrum({
            color: $(this).val(),
            showInput: true,
            preferredFormat: "hex",
            showPalette: true,
            showSelectionPalette: false,
            palette: [["#FFF", "#000", "#ED4F2E", "#15778E", "#ff5a5f"]]
        });
        $("#colorpicker-slogan, #colorpicker-description").show();
    }

    if ($('#colorpicker-color').length) {
        $("#colorpicker-color").spectrum({
            color: $(this).val(),
            showInput: true,
            preferredFormat: "hex",
            showPalette: true,
            showSelectionPalette: false,
            palette: [["#FFF", "#000", "#ED4F2E", "#15778E", "#ff5a5f"]]
        });
        $("#colorpicker-color").show();
    }

});
