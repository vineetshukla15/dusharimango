function synchronizeCarousels(){
    /* Sychronize the carousels:
        http://stackoverflow.com/questions/20710222/bootstrap-carousel-how-to-slide-two-carousel-sliders-at-a-same-time
        http://stackoverflow.com/questions/9860436/twitter-bootstrap-carousel-access-current-index 
    */
    $('#carousel-main').on('slide.bs.carousel', function(ev) {
        // get the direction, based on the event which occurs
        var dir = (ev.direction == 'right' ? 'prev' : 'next');

        // get the slide from and to index
        var slideFrom = $(this).find('.active').index();
        var slideTo = $(ev.relatedTarget).index();
        var numSlides = $(this).find('.item').length;
        //alert(dir + " : " + slideFrom + " : " + slideTo + " : " + numSlides);
        
        //if (dir == 'next' && slideTo == 0)
        if ( Math.abs(slideTo-slideFrom) == 1 ||
             (dir == 'next' && (numSlides - (slideFrom - slideTo) == 1)) ||
             (dir == 'prev' && (numSlides - (slideTo - slideFrom) == 1)) )
            $('.carousel-sync').carousel(dir);
        else
            $('.carousel-sync').carousel(slideTo);
    });
    
    $('#carousel-left').click(function(event){
        //$('.carousel-sync').carousel('prev');
        $('#carousel-main').carousel('prev');
    });
    
    $(".carousel").on("swiperight",function(){
        $('#carousel-main').carousel('prev');
    });
    
    $('#carousel-right').click(function(event){
        //$('.carousel-sync').carousel('next');
        $('#carousel-main').carousel('next');
    });
    
    $(".carousel").on("swipeleft",function(){
        $('#carousel-main').carousel('next');
    });
    
    $('#carousel-right-2').click(function(event){
        $('#carousel-main').carousel('next');
        //$('#carousel-main').carousel('next');
        //$('.carousel-sync').carousel('next');
        //$('.carousel-sync').carousel('next');
    });
        
}