/* This file is inspired by debian/build.js in the jquery package and on gruntfile.js
 */
({
    baseUrl: "ui",
    name: "widget",
    out: "jquery-ui.js",
	preserveLicenseComments: false,
    // We have multiple minify steps
    optimize: "none",
	findNestedDependencies: true,
    // Avoid breaking semicolons inserted by r.js
    skipSemiColonInsertion: true,
    // otherwise define(xxx, function(){}) gets added
    skipModuleInsertion: true,
    wrap: {
        startFile: "debian/intro.js",
        endFile:   "debian/outro.js",
    },
    // prevent jquery from being included
    paths: {
        jquery: "empty:" 
    },
	include: [
        "position.js",
        "data.js",
        "disable-selection.js",
        "effect.js",
        "effects/effect-blind.js",
        "effects/effect-bounce.js",
        "effects/effect-clip.js",
        "effects/effect-drop.js",
        "effects/effect-explode.js",
        "effects/effect-fade.js",
        "effects/effect-fold.js",
        "effects/effect-highlight.js",
        "effects/effect-puff.js",
        "effects/effect-pulsate.js",
        "effects/effect-scale.js",
        "effects/effect-shake.js",
        "effects/effect-size.js",
        "effects/effect-slide.js",
        "effects/effect-transfer.js",
        "focusable.js",
        "form-reset-mixin.js",
        "jquery-1-7.js",
        "keycode.js",
        "labels.js",
        "scroll-parent.js",
        "tabbable.js",
        "unique-id.js",
        "widgets/accordion.js",
        "widgets/autocomplete.js",
        "widgets/button.js",
        "widgets/checkboxradio.js",
        "widgets/controlgroup.js",
        "widgets/datepicker.js",
        "widgets/dialog.js",
        "plugin.js",
        "widgets/draggable.js",
        "widgets/droppable.js",
        "widgets/menu.js",
        "widgets/mouse.js",
        "widgets/progressbar.js",
        "widgets/resizable.js",
        "widgets/selectable.js",
        "widgets/selectmenu.js",
        "widgets/slider.js",
        "widgets/sortable.js",
        "widgets/spinner.js",
        "widgets/tabs.js",
        "widgets/tooltip.js"
    ],
    rawText: {},
    /**
     * @param {String} name
     * @param {String} path
     * @param {String} contents The contents to be written (including their AMD wrappers)
     */
    onBuildWrite: function( name, path, contents ) {
        function capitalize(word){
	        return word.substring(0,1).toUpperCase() + word.substring(1);
        }
        contents = contents.replace(/\( function\( factory[\s\S]*?function\( \$\s*\)[^\n]+/mig, '');
        contents = contents.replace(/[\n]{1}\} \) \);/ig, '');
        // Next line works, except they should capitalize first character
        contents = contents.replace(/[\n]{1}return \$\.effects\.define\( \"[a-z]+/g, function(c){ return "\nvar effectsEffect" + capitalize(c.replace(/[\n]{1}return \$\.effects\.define\( \"/, '')) + ' = ' + c.replace(/[\n]{1}return /, ''); });

        contents = contents.replace(/[\n]{1}return \$\.widget\( \"ui\.[a-z]+/g, function(c){ return "\nvar widgets" + capitalize(c.replace(/[\n]{1}return \$\.widget\( \"ui\./, '')) + ' = ' + c.replace(/[\n]{1}return /, ''); });

        contents = contents.replace(/[\n]{1}return \$\.ui\.[a-zA-Z]+ \=/g, function(c){ return "\nvar " + c.replace(/[\n]{1}return \$\.ui\./, '').replace(/ =/, '') + ' = ' + c.replace(/[\n]{1}return /, ''); });

        contents = contents.replace(/[\n]{1}return \$\.ui\.[a-z]+/g, function(c){ return "\nvar widgets" + capitalize(c.replace(/[\n]{1}return \$\.ui\./, '')) + ' = ' + c.replace(/[\n]{1}return /, ''); });

        contents = contents.replace(/[\n]{1}return \$\.fn\.extend\( \{[\n]{1}\t[a-zA-Z]+/ig, function(c){ return "\nvar " + c.replace(/[\n]{1}return \$\.fn\.extend\( \{[\n]{1}\t/ig, '') + ' = ' + c.replace(/[\n]{1}return /, ''); });

        contents = contents.replace(/[\n]{1}return \$\.fn\.[a-zA-Z]+/g, function(c){ return "\nvar " + c.replace(/[\n]{1}return \$\.fn\./g, '') + ' = ' + c.replace(/[\n]{1}return /, ''); });

        // very specific (1 case)
        contents = contents.replace(/return \$\.extend\( \$\.expr\[ \":\" \], \{[\n]{1}\tdata/, 'var data = $.extend( $.expr[ ":" ], {' + "\n\tdata");
        contents = contents.replace(/return \$\.extend\( \$\.expr\[ \":\" \], \{[\n]{1}\ttabbable/, 'var tabbable = $.extend( $.expr[ ":" ], {' + "\n\ttabbable");
        
        contents = contents.replace(/[\n]{1}return \$\.[a-z]+/g, function(c){ return "\nvar " + c.replace(/[\n]{1}return \$\./, '') + ' = ' + c.replace(/[\n]{1}return /, ''); });

        // Some fixes
        contents = contents.replace('var effects ', 'var effect ');
        contents = contents.replace(/[\n]{1}return effect;/, "\n" + 'var effectsEffectTransfer = effect;');
        contents = contents.replace('widgetsPosition', 'position');
        contents = contents.replace('widgetsFocusable', 'focusable');
        contents = contents.replace('var datepicker ', 'var widgetsDatepicker ');
        contents = contents.replace(/[\n]{1}var keyCode/, "\nvar keycode");

        return contents;
    }
})


