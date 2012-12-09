/**
 * jquery.youtubin.js
 * Copyright (c) 2009 Jon Raasch (http://jonraasch.com/)
 * Licensed under the Free BSD License (see http://dev.jonraasch.com/youtubin/docs#licensing)
 * 
 * @author Jon Raasch
 *
 * @projectDescription    jQuery plugin to allow simple and unobtrusive embedding of youtube videos with a variety of options
 * 
 * @documentation http://dev.jonraasch.com/youtubin/docs
 *
 * @version 1.2
 * 
 * @requires jquery.js (tested with v 1.3.2)
 * 
 * @optional SwfObject 2
 * 
 * NOT AFFILIATED WITH YOUTUBE
 */


( function( $ ) {    
    var youtubinCount = 0;
    var youtubinMode  = 0;
    
    $.youtubin = function(options, box) {
        var options = options || {};
        
        // if iphone and iphoneBoot not set or true, just die so youtube link can stay
        if ( (typeof options.iphoneBoot == 'undefined' || options.iphoneBoot )  && ( (navigator.userAgent.match(/iPhone/i)) || (navigator.userAgent.match(/iPod/i)) ) ) return false;
        
        // if first time
        if ( !youtubinMode ) {
            if ( typeof( swfobject ) == 'undefined' ) youtubinMode = 'noScript';
            else youtubinMode = '2';
        }
        
        if ( typeof( box ) == 'undefined' || !box ) {
            options.scope = options.scope || $('body');
            $('a[href^=http://www.youtube.com/watch?v=]', options.scope).youtubin(options);
            
            return false;
        }
        
        // define options
        options.swfWidth  = options.swfWidth || "425";
        options.swfHeight = options.swfHeight || "344";
        options.flashVersion = options.flashVersion || "8";
        options.expressInstall = options.expressInstall || "";
        
        options.flashvars = options.flashvars || {};
        options.params    = options.params || {
            menu : "false",
            loop : "false",
            wmode : "opaque"
        };
        
        options.replaceTime = options.replaceTime || 'auto';
        options.keepLink = options.keepLink || (options.replaceTime == 'click');
        options.wrapper = options.wrapper || '<div class="youtubin-video"></div>';
        
        options.autoplay = typeof options.autoplay != 'undefined' ? options.autoplay : ( options.replaceTime == 'click' );
        
        options.srcOptions = options.srcOptions || '?hl=en&fs=1' + ( options.autoplay ? '&autoplay=1' : '' );
        options.method = options.method || 'href';
        
        options.target = options.target || false;
        
        
        var $box = $(box);
        
        // depending on replaceTime trigger replacement or attach click event
        if (options.replaceTime == 'auto') replaceIt();
        else if (options.replaceTime == 'click') $box.click( function(ev) { ev.preventDefault(); replaceIt(); });
        
        function replaceIt() {
            function checkId($tgt) {
                var boxId = $tgt.attr('id');
                if ( !boxId.length ) {
                    boxId = getNewId();
                    $tgt.attr('id', boxId);
                }
                
                return boxId;
            }
            
            function getNewId() {
                var boxId = 'youtubin-' + youtubinCount;
                youtubinCount++;
                
                return boxId;
            }
            
            var src = $box.attr(options.method);
    
            // build swf url from youtube link
            if ( src.substr(0,31) == 'http://www.youtube.com/watch?v=' ) src = 'http://www.youtube.com/v/' + src.substr(31) + options.srcOptions;
        
            // set the target
            if ( options.target ) {
                var $tgt = options.target;
                var boxId = checkId($tgt);
            }
            else if ( options.keepLink ) {
                var boxId = getNewId();
                $box.after($('<div id="'+boxId+'"></div>'));
                
                var $tgt = $('#'+boxId);
                $tgt.css('clear', 'both');
            }
            else {
                var $tgt = $box;
                var boxId = checkId($tgt);
            }
            
            // embed the swf according to youtubinMode
            switch(youtubinMode) {
                case '2' :
                    swfobject.embedSWF(src, boxId, options.swfWidth, options.swfHeight, options.flashVersion, options.expressInstall, options.flashvars, options.params);
                break;
                
                default : 
                    $tgt.html('<object width="' + options.swfWidth + '" height="' + options.swfHeight + '"><param name="movie" value="' + src + '"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="' + src + '" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="' + options.swfWidth + '" height="' + options.swfHeight + '"></embed></object>');
                break;
            }
            
            // (hack) must redefine boxId here or it will cause error in IE
            //if (options.wrapper) $('#'+boxId).wrap(options.wrapper);
        }
        
    };
    
    $.fn.youtubin = function(options) {
        this.each( function() {new $.youtubin( options, this );});
        return this;
    };
})( jQuery );