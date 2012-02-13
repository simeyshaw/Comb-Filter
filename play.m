function y = play(in_file,out_file)

[buffer,fs,bits] = wavread(in_file);
soundsc(buffer,fs,bits);

[buffer,fs,bits] = wavread(out_file);
soundsc(buffer,fs,bits);