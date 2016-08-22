//= require_self
$(document).ready(function(){
    $('.other-property-values').on('click', function(){
        $(this).parent().parent().find('.hide, .show').toggleClass('hide show');
        if($(this).text()=='другие параметры'){
            $(this).text('скрыть')
        }else{
            $(this).text('другие параметры')
        }
    });

    $('.styled-checkbox input').on('change', function(){
        $(this).closest('form').submit();
    });
});
