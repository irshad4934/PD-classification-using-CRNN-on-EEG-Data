function out=signal_cutter(in,start,stop,Fs)
    start_index=start*Fs;
    stop_index=stop*Fs;
    
    if (start_index==0)
        start_index=1;
    end
  
    for i=1:length(in)
        signal=in{i};
        if(stop_index<=length(signal))        
            in{i}=signal(start_index:stop_index);
        end
    end

out=in;
end