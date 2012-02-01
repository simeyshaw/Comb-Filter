clr; %clear all function

%get in file name
in_file = uigetfile ('.wav','Select a Wave File to Input');
%set out file name
out_file = ['output mul ' in_file];

%pass file names to physdo-stream function
signal = streamio(in_file, out_file);

%filters held in an array with delay in the top row and
%gain in the bottom
comb_array=[100 200 300;0.3 0.4 0.5];
dly_no = length(comb_array);
max_dly = max(comb_array(1,:));

%creates bufffer
buffer = zeros(max_dly,1);

while true
    %prevents clipping
    x = 0.5* signal.input();
    if isfinite(x)
        %put sample in buffer
        buffer(1) = x;
        %add delayed signal
        for n=1:dly_no
            x = x + comb_array(2,n)*buffer(comb_array(1,n));
        end
        %move the buffer up by one to make space for next sample
        buffer(2:max_dly) = buffer(1:max_dly-1); 
        %output sample
        signal.output(x);
        
    else
            for i=1:max_dly
               for n=1:dly_no
                    x = x + comb_array(2,n)*buffer(comb_array(1,n));
               end
               buffer(2:max_dly) = buffer(1:max_dly-1);
               signal.output(x); 
            end
            signal.output(NaN);
            break
    end
    
    
end

%%soundsc()

h = msgbox('Finished Processing','help');