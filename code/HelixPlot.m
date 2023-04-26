alpha = 88; %wind angle (helical wind angle)
alpha_r = alpha * pi / 180; %angle in radians
dia = 8; %diamter of cylinder
radius = dia/2;
polar_rad = 1;
Le = 30; %adjust this to adjust the length of the cylinder

alpha_s = asin(polar_rad/radius); %polar wind angle

pitch = 2*dia/atan(alpha_r); %helical pitch

starts = 3; %number of divisions along the cylindrical section
start = 360 / starts * (pi / 180);

revs = Le / pitch; %number of revolutions to get to one end of cylinder
rad_rev = revs * 2 * pi; %total revolutions in radians

C = pi * dia; %circumfrance
L = sqrt(pitch^2 + C^2); %filament length L
Filament_length = revs * L; %calculating approx filament needed 

tt = linspace(0,rad_rev,40); %radial points
x_max = pitch * revs; %total length of winding

x1 = tt / rad_rev * x_max + radius; %reach the end once (divide x lengths into small distances) %+radius to start cylinder winding later
y1 = radius*cos(tt);
z1 = radius*sin(tt);

x2 = x1(end-1) -tt/(rad_rev)*x_max; %come back
y2 = radius*cos(tt);
z2 = radius*sin(tt);

x_temp = [x1,x2]; %travel one full length (back and forth)
y_temp = [y1,y2];
z_temp = [z1,z2];
t_temp = [tt,tt];

%reach end
x = x_temp;
y = y_temp;
z = z_temp;
tt = t_temp;

for i = 1: starts-1
    t_new = t_temp + i*start; %increase theta angle
    y_new = radius*cos(t_new);
    z_new = radius*sin(t_new);
    
    tt = [tt,t_new];
    x = [x,x_temp]; %x just going back and forth
    y = [y,y_new];
    z = [z,z_new];
end
    
%% Plotting Molds
r = radius;

x_ls = linspace(0,r,25);
x_c = linspace(r,r+x_max, 50);
x_rs = linspace(r+x_max, 2*r + x_max, 25);

t = linspace(0,2*pi, 50);
x_m = [x_ls, x_c, x_rs]; %total x matrix
X = ones(length(x_m), length(t));
Y = zeros(length(x_m), length(t));
Z = zeros(length(x_m), length(t));

for i = 1: length(x_m)
    X(i,:) = X(i,:)*x_m(i);
end


for i = 1: length(x_m)
    if i < 25 %left sphere
        r_c = sqrt(r^2 - (x_m(i)-r)^2); %current radius of the circle at x-positio  
        for t_i = 1: length(t)
           Z(i,t_i) = r_c*sin(t(t_i));
           Y(i,t_i) = r_c*cos(t(t_i)); 
        end
        
    elseif i < 75
       for t_i = 1: length(t)
           Z(i,t_i) = r*sin(t(t_i));
           Y(i,t_i) = r*cos(t(t_i)); 
       end
    else
        r_c = sqrt(r^2 - (x_m(i)-(r+x_max))^2);
        for t_i = 1: length(t)
           Z(i,t_i) = r_c*sin(t(t_i));
           Y(i,t_i) = r_c*cos(t(t_i)); 
        end
    end
end
%% Animate Plot (Uncomment to see how winding animation occurs)

%{
for k = 1: length(tt)
    surf(X,Y,Z)
    hold on
    plot3(x(k), y(k), z(k), 'x')
    plot3(x(1:k), y(1:k), z(1:k), 'LineWidth',3);
    xlim([0,x_max])
    axis('equal')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    pause(.1);
    if k~= length(t)
        clf
    end
end
hold off;
%}

%% Final Wind (Shows final wind)
surf(X,Y,Z) %XYZ are coordinates for the mold
hold on
plot3(x, y, z, 'k', 'LineWidth',1); %xyz are coordinates for the filament path
axis('equal')
xlabel('x')
ylabel('y')
zlabel('z')

