clr; %clear all function

%get in file name
in_file = uigetfile ('.wav','Select a Wave File to Input');
%set out file name
out_file = ['output FBN ' in_file];

%pass file names to physdo-stream function
signal = streamio(in_file, out_file);

%
dly = [1023,2052,5047,];

dly_no = length(dly);
max_dly = max(dly);

routing_matrix = [
1, 1, 1;
1, 1, 1;
1, 1, 1;
];

dly_array = zeros(max_dly,dly_no);

g_in = [0.5,0.4,0.3];
g_out =[0.25,0.25,0.25];
g_fb = [0.4,0.4,0.4];
g_ft = 0.5;

while true
    x = signal.input();
    if isfinite(x)
        
        sam_fo = 0;
        
        for d = 1:dly_no
            sam_fb = 0;
            %generate the feedback sample using routing matix
            for m = 1:dly_no
                sam_fb = sam_fb + routing_matrix(m,d)*dly_array(dly(m),m);
            end
            %store signal and feedback sample in the delay lines
            dly_array(1,d) = g_in(d)*x + g_fb(d)*sam_fb;
            %generate the delay line output
            sam_fo = sam_fo + g_out(d)*dly_array(dly(d),d);
        end
        
        %move the delay lines up by 1 sample
        for d = 1:dly_no
            dly_array(2:dly(d)) = dly_array(1:dly(d)-1);
        end
        
        %To Do - insert filter here
        
        %add delay output to the pass through signal
        x = g_ft*x + sam_fo;
        %output sample
        signal.output(x);
    else
        for i=1:max_dly
            
            sam_fo = 0;
            
            for d = 1:dly_no
                sam_fb = 0;
                %generate the feedback sample using routing matix
                for m = 1:dly_no
                    sam_fb = sam_fb + routing_matrix(m,d)*dly_array(dly(m),m);
                end
                %store signal and feedback sample in the delay lines
                dly_array(1,d) = g_fb(d)*sam_fb;
                %generate the delay line output
                sam_fo = sam_fo + g_out(d)*dly_array(dly(d),d);
            end
            
            %move the delay lines up by 1 sample
            for d = 1:dly_no
                dly_array(2:dly(d)) = dly_array(1:dly(d)-1);
            end

            %To Do - insert filter here

            %add delay output to the pass through signal
            x = sam_fo;
            %output sample
            
            signal.output(x); 
        end
        signal.output(NaN);
        break
    end
    
    
end
h = msgbox('Finished Processing','help');
play(in_file,out_file);

