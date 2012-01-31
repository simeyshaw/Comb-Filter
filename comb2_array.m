clr;

dly = 1000;   %delay
g = 0.9;    %gain


in_file = uigetfile ('.wav','Select a Wave File to Input');
out_file = ['output 2' in_file];
[audio_data,fs,bits] = wavread(in_file);

audio_data_out = [audio_data; zeros(dly,1)];
len = length(audio_data);

for s = 1:dly
      audio_data_out(s) = audio_data(s);
end

for s = dly+1:len
      audio_data_out(s) = audio_data(s) + audio_data(s-dly)*g;
end
    
audio_data = audio_data*0.5;


wavwrite(audio_data_out,fs, bits,out_file); 