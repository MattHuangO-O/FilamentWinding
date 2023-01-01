function [left, right] = polarWind(R, polar_alpha, cyl_Length, n_pts)
l_0 = R*cos(polar_alpha); %(-2)
x_0 = R - l_0; % (-1)

x_left = linspace(x_0, R, n_pts); % (0)
y_left = zeros(1, n_pts); 
z_left = zeros(1, n_pts);
phi_left = zeros(1, n_pts);

%Left polar winding
for i = 1:n_pts %plotting points for the left hemispherical end cap
    l = R - x_left(i); % (1)
    y_left(i) = l * tan(polar_alpha); % (2)
    r_xy = sqrt(l^2 + y_left(i)); % (3)
    z_left(i) = sqrt(R^2 - r_xy^2); % (4)
    %phi_left(i) = asin(z_left(i)/R); % (5)
    phi_left(i) = atan(z_left(i)/y_left(i)); % (5)
end

x_left_back = fliplr(x_left);
y_left_back = fliplr(y_left);
z_left_back = fliplr(z_left .* -1);

left = [x_left, x_left_back;
        y_left, y_left_back;
        z_left, z_left_back];

    
%Right polar winding
x_start = R + cyl_Length; % (14)
x_right = linspace(x_start, x_start + l_0, n_pts); % (15)
y_right = zeros(1,n_pts); 
z_right = fliplr(z_left); %z right is just z left but flipper
%phi_right = phi_cyl(end) + phi_left;
%phi_right = zeros(1,n_pts);
l = zeros(1,n_pts);
r_xy = zeros(1,n_pts);

for i = 1:n_pts %plotting points for the right hemispherical end cap
    l(i) = x_right(i) - x_start; % (15)
    y_right(i) = -l(i) * tan(polar_alpha); % (16)
    r_xy(i) = sqrt(l(i)^2 + y_right(i)^2); % (3) 
    %z_right(i) = sqrt(R^2 - r_xy(i)^2); % (17)
    %phi_right(i) = atan(z_right(i)/y_right(i))*180/pi; % (18)
end

z_right_back = fliplr(z_right .* -1);
y_right_back = flip(y_right);
x_right_back = fliplr(x_right);

right = [x_right, x_right_back; 
         y_right, y_right_back;
         z_right, z_right_back];
end