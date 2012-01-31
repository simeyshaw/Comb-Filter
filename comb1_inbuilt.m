clr;

in_file = uigetfile ('.wav','Select a Wave File to Input');
out_file = ['output ' in_file];
[audio_data,fs,bits] = wavread(in_file);

%create a simple comb filter to use the inbuilt MATLAB filtering
%functions

dly = 10;   %delay
g = 0.9;    %gain

%These are the filter coefficients which are used in the difference eqn
%type doc filter on the command line for more information including
%circuit diagram

%y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                 - a(2)*y(n-1) - ... - a(na+1)*y(n-na)

%As the comb filter is
%y(n) = x(n) + g*y(n-dly) (see notes)
%this implies

b(1) = 1;
a(1) = 1;
a(dly+1) = -g;

audio_data_out = filter(b,a,audio_data);

%these functions are then useful
%frequency response
figure
freqz(b,a)

%impulse response
figure
impz(b,a)

%z-plane representation (ignore this if you haven't used it before
% figure
% zplane(b,a)

%Group delay, not that important for reverberators?
% figure
% grpdelay(b,a)

wavwrite(audio_data_out,fs, bits,out_file); 