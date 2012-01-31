function stream = streamio(in_file,out_file)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[in_buffer,fs,bits] = wavread(in_file);

in_index = 0;
in_length = length(in_buffer);

out_index = 0;
out_length = 0;
chunk_size = fs*1;
out_buffer = zeros(chunk_size,1);

stream.fs = @getfs;
stream.input = @getinput;
stream.output = @putoutput;

    function y1 = getinput()
        in_index = in_index + 1;
         if in_index > in_length   %no more samples
             y1 = NaN; % Output the 'Sentinel'
             return
         else
             y1 = in_buffer(in_index); % Output the next Sample value
             return
         end
        
    end

    function y2 = getfs()
        y2 = fs;
    end

    function putoutput(out_sample)
        if isfinite(out_sample)
            out_index = out_index + 1;
            if  out_index > out_length   %no more buffer space! :( Lets make it bigger!
                out_buffer = [out_buffer; zeros(chunk_size,1)]; % Add chunk_size more samples onto the buffer
                out_length = length(out_buffer);
            end
        out_buffer(out_index) = out_sample;
        else
            wavwrite(out_buffer(1:out_index),fs, bits,out_file); 
        end   
    end
end

