clr; %clear all function

%get in file name
in_file = uigetfile ('.wav','Select a Wave File to Input');
%set out file name
out_file = ['output mul ' in_file];

%pass file names to physdo-stream function
signal = streamio(in_file, out_file);

%filters held in an array with delay in the top row and
%gain in the bottom
dly = 100;
g = 0.5;



%creates bufffer
fb_buffer = zeros(dly,1);
ff_buffer = zeros(dly,1);

while true
    %prevents clipping
    x = 0.5* signal.input();
    if isfinite(x)
        %put sample in buffer
        ff_buffer(1) = x;
        %add delayed signal
        
            x = g*x + ff_buffer(dly) + g*fb_buffer(dly);
        
            fb_buffer(1) = x;
        %move the buffer up by one to make space for next sample
        ff_buffer(2:dly) = ff_buffer(1:dly-1); 
        fb_buffer(2:dly) = fb_buffer(1:dly-1); 
        %output sample
        signal.output(x);
        
    else
            for i=1:dly
              
               x = ff_buffer(dly) + g*fb_buffer(dly);
        
                fb_buffer(1) = x;
        %move the buffer up by one to make space for next sample
                ff_buffer(2:dly) = ff_buffer(1:dly-1); 
                fb_buffer(2:dly) = fb_buffer(1:dly-1); 
               signal.output(x); 
            end
            signal.output(NaN);
            break
    end
    
    
end

%%soundsc()

h = msgbox('Finished Processing','help');