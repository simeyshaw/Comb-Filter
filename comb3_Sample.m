clr;

in_file = uigetfile ('.wav','Select a Wave File to Input');
out_file = ['output cb ' in_file];

signal = streamio(in_file, out_file);

dly = 1000;   %delay
g = 0.9;    %gain

buffer = zeros(dly,1);
y = 0;

while true
    x = 0.5* signal.input();
    y=y+1;
    if isfinite(x)
        buffer(1) = x;
        x = x + g*buffer(dly);
        buffer(2:dly) = buffer(1:dly-1); 
        signal.output(x);
        
    else
            for i=1:dly
               x = g*buffer(dly);
               buffer(2:dly) = buffer(1:dly-1);
               signal.output(x); 
            end
            signal.output(NaN);
            break
    end
    
    
end

%%soundsc()

h = msgbox('Finished Processing','help');

