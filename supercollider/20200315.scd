// Supercollider GUI

(
    var numSliders = 4;
    var numButtons = 2;
    var sliders, buttons, sliderLayout, buttonLayout, layout;

    w = Window.new;
    
    sliders = numSliders.collect{
        Slider.new();
    };

    buttons = numButtons.collect{
        Button.new();
    };

    sliderLayout = VLayout.new(*sliders);
    buttonLayout = HLayout.new(*buttons);
    
    layout = HLayout(buttonLayout, sliderLayout);
    w.layout = layout;
    
    // show the window
    w.front;
)
