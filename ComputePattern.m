clear all;
NE = 4;
Cutoff = 0.07;
Xrange = -100:1:100;
Yrange = -100:1:100;

%p = [-0.2,0; 0,0; 0.31,0;0.62,0];
p = [-1,0;-0.5,0;0,0;0.5,0;1,0];
A = [1.,1.,1.,1.];

%phi = [-3*pi/5,0,pi*(1-0.31),2*pi*(1-0.31)];
phi = [0,pi,pi/2,pi];

r = 0;
amp = zeros(length(Xrange),length(Yrange));

for i=1:NE
    for l = 1:length(Xrange)
        for k = 1:length(Yrange)
            r = sqrt((Xrange(l)-p(i,1))^2+(Yrange(k)-p(i,2))^2);
            amp(l,k) = amp(l,k)+(A(i)/r)*exp(-1i*(r*2*pi+phi(i)));
        end
    end
end
amp = min(abs(amp),Cutoff);
contour(Xrange,Yrange,(amp)',10);