%% Mold
alpha = 15 * pi / 180; %wind angle (radians)
S_F = 710000;%fiber strength
P = 1000;%pressure
N = 2; %safety factor
D = 8; %diameter
w = .25; %filament width
th = .004;%filament thickness
r_0 = .5;%starting radius
n_pts = 50; %number of points
R = D/2; %Radius 
cyl_Length = 0; %Length of cylindrical Section

l_h = R*cos(alpha); %see figure 2
x_0 = R - l_h; %see figure 2

Helix_Pitch = 2 * D / atan(alpha); %see Figure 1 
Step = w/R * 180 / pi; %exact step angle
N_C = floor(360 / Step); %Number of Circuits to fully cover the cylinder section
N_C = N_C + 5; %Increase number of circuits for overlapping (making sure everything is covered)

Step = 360 / N_C; %run step angle

Rev = cyl_Length / Helix_Pitch; %number of revolutions 
Rev_rad = Rev * 2 * pi; %offset for polar winding (revolution in radians)
%Total_Rotation = 2*pi*Rev; %How many radians it takes to get to end to end of cylinder

Length = 2 * l_h + cyl_Length; %2 hemispherical lengths + 1 cylinder length
x_max = 2*R + cyl_Length;

R = 2;
x_ls = linspace(0,R,25); %left Sphere x-coordinates (start at 0)
x_c = linspace(R,R+cyl_Length, 50); %cylinder mold
x_rs = linspace(R+cyl_Length, 2*R + cyl_Length, 25); %right Sphere x-coordinates 

t = linspace(0,2*pi, 50); %theta descretization for visualization
x_m = [x_ls, x_c, x_rs]; %total x matrix (x-mold)
X = ones(length(x_m), length(t));
Y = zeros(length(x_m), length(t));
Z = zeros(length(x_m), length(t));

for i = 1: length(x_m)
    X(i,:) = X(i,:)*x_m(i); %need to do this for surf()
end

for i = 1: length(x_m)
    if i < 25 %left sphere
        r_c = sqrt(R^2 - (x_m(i)-R)^2); %current radius of the circle at x-position  
        for t_i = 1: length(t)
           Z(i,t_i) = r_c*sin(t(t_i));
           Y(i,t_i) = r_c*cos(t(t_i)); 
        end
        
    elseif i < 75
       for t_i = 1: length(t)
           Z(i,t_i) = R*sin(t(t_i));
           Y(i,t_i) = R*cos(t(t_i)); 
       end
    else
        r_c = sqrt(R^2 - (x_m(i)-(R+cyl_Length))^2);
        for t_i = 1: length(t)
           Z(i,t_i) = r_c*sin(t(t_i));
           Y(i,t_i) = r_c*cos(t(t_i)); 
        end
    end
end

surf(X,Y,Z)
axis('equal')
xlabel('x')
ylabel('y')
zlabel('z')


%% SPherical Winding 2nd try
alpha_polar = asin(r_0/R); %polar wind angle
L = R*cos(alpha_polar); %2 in drawing 

x_start_L = R-L; %starting point for Left Hemisphere
x_end_L = L; %ending point for Left Hemisphere

x_start = 0;
x_start_R = R + cyl_Length; %radius plus cylinder length (starting point for Right hemisphere)
x_end_R = x_start_R + L; %(ending points for Right Hemipshere)

x_left = linspace(x_start_L, x_end_L, n_pts); %x points for left hemisphere
x_right = linspace(x_start_R, x_end_R, n_pts); %y points for right hemisphere

x_0 = linspace(0, 2*(R-x_start_L), 100);

x_back_left = fliplr(x_left); %flips the matrix about the center
x_back_right = fliplr(x_right); %flips the matrix about the center 
x = [x_left, x_right, x_back_right, x_back_left]; %Total x matrix (Total length = npts * 4)

theta_start = 0;
theta_end = pi;

theta = linspace(theta_start, theta_end, 100); %pre allocation

y = zeros(1,length(theta)/2);

the = zeros(1,length(theta)/2);

for i = 1:length(theta)
    l = L - x_0(i); %x_0 used here to calculate y
    y(i) = l*tan(alpha_polar); % 3 in drawing
end

y_back = flip(y); %y doesnt ever change, look at the graph bro flips head tp tail
y = [y,y_back];

z = zeros(1,length(theta));
r_temp = zeros(1,length(theta));


for i = 1:length(theta)
    r_temp(i) = sqrt(y(i)^2 + (L-x_0(i))^2);
    z(i) = sqrt(R^2 - r_temp(i)^2);
    the(i) = atan(y(i)/z(i)*180/pi); %calculating location of motor
end
z_back = z .* -1;
z = [z, z_back];

ang = 60; %adjust this to adjust the angle of the next wind
iter = 2; %adjust this to adjust the number of windings
wind = [x; y; z];
starts = 360 / ang; %tells you how many iterations to make a complete revolution
Rotate = rotx(ang);

for i = 1: starts
    wind = mtimes(Rotate, wind);
    x = wind(1,:);
    y = wind(2,:);
    z = wind(3,:);
    hold all
    surf(X,Y,Z)
    plot3(x,y,z,'LineWidth',3);
    axis('equal')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    %view(0,90)  % XY
    %pause
    %view(0,0)   % XZ
    %pause
    %view(90,0)  % YZ
end
hold off