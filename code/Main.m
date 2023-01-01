%% user inputs
alpha = 14 * pi / 180; %wind angle (radians)
S_F = 710000;%fiber strength
Pr = 1000;%pressure
N = 2; %safety factor
D = 8; %diameter
w = .25; %filament width
th = .004;%filament thickness
r_0 = 1;%starting radius
n_pts = 200; %number of points
cyl_Length = 12; %Length of cylindrical section
MainPlot(alpha,S_F,Pr,N,D,w,th,r_0,n_pts,cyl_Length)