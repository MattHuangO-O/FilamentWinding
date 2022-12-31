function [forward, backward, starts] = helicalWind(R, cyl_Length, alpha, n_pts)
D = 2*R;
P = 2*D / tan(alpha); % (6)
revolutions = cyl_Length / P; % (7)
deg_revolutions = revolutions * 360;
rad_revolutions = deg_revolutions * pi / 180;
phi_right_back = (270 + deg_revolutions) * pi / 180;

o_rev = revolutions - floor(revolutions);
cycles = ceil(1 / o_rev); %new
starts = 360 / cycles; %new
%starts = 2*360*o_rev;

%forward 
phi_cyl = linspace(pi/2, rad_revolutions + pi/2, n_pts); % (9)
x_cyl = linspace(R, R + cyl_Length, n_pts);
y_cyl = R*cos(phi_cyl); % (11)
z_cyl = R*sin(phi_cyl); % (12)

%backward
phi_cyl_back = linspace(phi_right_back, phi_right_back + rad_revolutions, n_pts);
x_cyl_back = fliplr(x_cyl); 
y_cyl_back = R*cos(phi_cyl_back); % (11)
z_cyl_back = R*sin(phi_cyl_back); % (12)

forward = [x_cyl; y_cyl; z_cyl];
backward = [x_cyl_back; y_cyl_back; z_cyl_back];

end