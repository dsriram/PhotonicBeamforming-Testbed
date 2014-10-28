signal_original = InputPort1.Sampled.Signal;
signal_output = InputPort2.Sampled.Signal; %Ignoring noise term
nChannel = 1;

if(Parameter0 >1)
	signal_output = [signal_output; InputPort3.Sampled.Signal ]; % include 2nd channel
	nChannel = 2;
end

if(Parameter0 >2)
	signal_output = [signal_output; InputPort4.Sampled.Signal ]; % include 3rd channel
	nChannel = 3;
end

if(Parameter0 >3)
	signal_output = [signal_output; InputPort5.Sampled.Signal ]; % include 4th channel
	nChannel = 4;
end

orig_len = length(signal_original);
out_len = length(signal_output);

%%

% Assuming input and output signals fall in same frequency window

time = InputPort1.Sampled.Time;
dt_samp = min(diff(time));
Fs = 1/dt_samp;
if(Parameter1 == 0)
	Parameter1 = orig_len;
    
end

%%
[X Y H_abs H_atan t_delay t_delay_xc ] = phase_shift_calc_pieceWise(signal_original,signal_output,nChannel,Fs,Parameter1,0);

%%

% when using short pulse signals which can get shifted into the next bit window
% one of the bit window registers zero pulse, while the adjacent one
% detects the pulse. To compensate for zero pulse detection, we copy the
% delay value to the zeroing window's regiser

t_delay_xc = t_delay_xc-Parameter1;

% for i=1:nChannel
%     roll = 0;
%     for j=2:length(t_delay_xc(i,:))
%         a = t_delay_xc(i,j);
%         b = t_delay_xc(i,j-1);
%         if(a < b)
%             roll = roll+Parameter1;
%             t_delay_xc(i,j:end) = t_delay_xc(i,j:end)+roll;
%         end
%     end
% end

if(Parameter1 == 0)
    time_axis = (1:orig_len)*dt_samp;
else
    time_axis = (1:length(t_delay_xc(1,:)))*Parameter1*dt_samp;
end

delay_xc = (t_delay_xc)*dt_samp;
figure, plot(time_axis,delay_xc,'*-');
title('Measured Time Delay');
xlabel('Time(in seconds)');
ylabel('Delay (in seconds)');

CentralRF = Parameter2;

freqRange = linspace(CentralRF-5e9,CentralRF+5e9,11);

no_of_frames = length(delay_xc(1,:));
clear amps;
amps = zeros(no_of_frames,11,201,201);
%matlabpool open local 4;
tic;
parfor frame_no=1:no_of_frames
    for freq_comp = 1:11
        delay = delay_xc(frame_no);
        freq = freqRange(freq_comp);
        NE = 2; %2 elements
        pos = [-0.25 0; 0.25 0];
        pos = pos*(freq/CentralRF);
        phi = [0 delay*freq*2*pi];
        amps(frame_no,freq_comp,:,:) = ComputePattern_NChannel(NE,phi,pos);
    end
end
msgbox(strcat({'Elapsed Time: ',num2str(toc)}));

handle = BeamFormingUI(amps,freqRange,delay_xc);