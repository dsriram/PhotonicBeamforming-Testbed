bits = InputPort1.Sequence;
bitrate = InputPort1.BitRate;
bitduration = 1/bitrate;

time = InputPort2.Sampled.Time;
dt_samp = min(diff(time));
SampledNumber = length(InputPort2.Sampled);

samples_per_bit = floor(bitduration/dt_samp);

opt_signal = InputPort2.Sampled.Signal;

OutputPort1 = InputPort2;
OutputPort2 = InputPort2;

cur_index = 1;

for i=1:SampledNumber
         OutputPort1.Sampled(i).Signal(1,:) = zeros(1,length(InputPort2.Sampled(i).Signal(1,:)));
         OutputPort2.Sampled(i).Signal(1,:) = zeros(1,length(InputPort2.Sampled(i).Signal(1,:)));
        
        PolarizationNumber = size(InputPort2.Sampled(i).Signal,1);
        
        if( PolarizationNumber == 2)
            OutputPort1.Sampled(i).Signal(2,:) = zeros(1,length(InputPort2.Sampled(i).Signal(2,:)));
            OutputPort2.Sampled(i).Signal(2,:) = zeros(1,length(InputPort2.Sampled(i).Signal(2,:))); 
        end;
end

for i=bits
    if(i == 0)
  
     for i=1:SampledNumber
         
            OutputPort1.Sampled(i).Signal(1,cur_index:cur_index+samples_per_bit-1) = InputPort2.Sampled(i).Signal(1,cur_index:cur_index+samples_per_bit-1);
        
        PolarizationNumber = size(InputPort2.Sampled(i).Signal,1);
        
        if( PolarizationNumber == 2)
            
            OutputPort1.Sampled(i).Signal(2,cur_index:cur_index+samples_per_bit-1) = InputPort2.Sampled(i).Signal(2,cur_index:cur_index+samples_per_bit-1);
           
        end;
     end
    else
        for i=1:SampledNumber
         
            OutputPort2.Sampled(i).Signal(1,cur_index:cur_index+samples_per_bit-1) = InputPort2.Sampled(i).Signal(1,cur_index:cur_index+samples_per_bit-1);
        
        PolarizationNumber = size(InputPort2.Sampled(i).Signal,1);
        
        if( PolarizationNumber == 2)
            
            OutputPort2.Sampled(i).Signal(2,cur_index:cur_index+samples_per_bit-1) = InputPort2.Sampled(i).Signal(2,cur_index:cur_index+samples_per_bit-1);
           
        end;
     end
    end
    cur_index = cur_index+samples_per_bit;
end