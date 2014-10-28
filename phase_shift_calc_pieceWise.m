function [X Y H_abs H_atan t_delay t_delay_xc ] = phase_shift_calc_pieceWise( x, y, nChannel, Fs, nFFT, skipCount)
%PHASE_SHIFT_CALC1 Summary of this function goes here
%   Detailed explanation goes here

%%
x = x(skipCount+1:end);
y = y(:,skipCount+1:end);

sx = size(x);
sy = size(y);

if((sx(1) ~= 1) || (sy(1) < nChannel))
    error('Incompatible dimensions');
end

N = 2^(ceil(log2(nFFT)));

if(N ~= nFFT)
    error('FFT length must be a power of two');
end

nIter = min(floor(length(x)/nFFT),floor(length(y(1,:))/nFFT));

t_delay_xc = zeros(nChannel,nIter);
t_delay = zeros(nChannel,nIter);
X = zeros(1,nFFT);
Y = zeros(nChannel,nFFT);
H_atan = zeros(nChannel,nFFT);
H_abs = zeros(nChannel,nFFT);
%%
for j = 1:nIter
    start_index = 1+(j-1)*nFFT;
    end_index = j*nFFT;
    x1 = x(start_index:end_index);
    y1 = y(:,start_index:end_index);
    for i=1:nChannel
		Xc = xcorr(y1(i,:),x1);
		max_index = find(Xc==max(Xc));
		t_delay_xc(i,j) = max_index;
	end
end

end
