%% user inputs
alpha = 10 * pi / 180; %wind angle (radians)
S_F = 710000; %fiber strength
Pr = 1000; %pressure
N = 2; %safety factor
D = 8; %diameter
w = .25; %filament width
th = .004; %filament thickness
%r_0 = 0.5; %starting radius
r_0=sin(alpha)*D/2;%starting radius calculated from wind angle
%alpha = asin(2*r_0 / D); %wind angle (radians) calculated from polar wind
%angle
n_pts = 60; %number of points
cyl_Length = 10; %Length of cylindrical section
compl=0.96;%Layer completion percentage
MainPlot(alpha,S_F,Pr,N,D,w,th,r_0,n_pts,cyl_Length,compl)