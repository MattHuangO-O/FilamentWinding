function [xmesh_cir,ymesh_cir,zmesh_cir,xmesh_cyc,ymesh_cyc,zmesh_cyc,xmesh_full,ymesh_full,zmesh_full] = MainPlot(alpha,S_F,Pr,N,D,w,th,r_0,n_pts,cyl_Length,compl)
Red=[0,1];
Green=[1,0];
Blue=[0.1,0.1];

R = D/2; %Radius 
polar_alpha = asin(r_0 / R); %see figure 1

P = 2*D / tan(alpha); % (6) pitch
revolutions = cyl_Length / P; % (7)
rad_revolutions = revolutions * 2 * pi; % (8)
deg_revolutions = revolutions * 360; %degrees that the cylinder rotates in helical portion

n = (2*deg_revolutions) / 360; %calculates how many full revolutions gone in the cylindrical portion
start = 2*deg_revolutions - 360*(floor(n));

[left, right] = polarWind(R, polar_alpha, cyl_Length, n_pts);
[forward, backwards] = helicalWind(R, cyl_Length, alpha, n_pts);

num_cycles = find_cycles(deg_revolutions, 2); 

%phi = calculate_Mandrel_angle(circuit(2,:), circuit(3,:));

circuit_g = circuit_Generator(left, forward, right, backwards, deg_revolutions, n_pts); %g-code for one circuit
circuit=increase(circuit_g,th*10);

cycle_g = cycle_Generator(num_cycles, deg_revolutions, circuit_g, n_pts); %g-code for one cycle
cycle=increase(cycle_g,num_cycles*th*10);

[full_layer_g,num_full] = layer_Generator(w, R, cycle_g, num_cycles); %g-code for full layer
full_layer=increase(full_layer_g,num_full*th*10);


%TESTING WRITING TO TXT FILE AND GETTING MOTOR COORDINATES
[g_phi, g_y] = calculate_Mandrel_angle(full_layer_g(2,:), full_layer_g(3,:));
g_x = full_layer_g(1,:);
g = [g_x; g_y; g_phi]';
%writematrix(g,'myData.txt','Delimiter','\t')  

%writing to file
filename = 'dat.txt';

fileID = fopen(filename,'w');

writelines('G90', filename,WriteMode="append");
zero = ['G00', '    ', 'X', num2str(0), '   ', 'Y', num2str(0), '  ', 'Z', num2str(0)];
writelines(zero, filename, WriteMode = "append");

for k = 1: length(g_x)
    lines = ['G01 ','X', num2str(g_x(k)), '   ', 'Y', num2str(g_y(k)), '  ', 'Z', num2str(g_phi(k))];
    writelines(lines,filename,WriteMode="append")
end
fclose(fileID);



%% surface plot circuit

[Th_circuit,R_circuit]=cart2pol(circuit(2,:),circuit(3,:));

ThR_circuit=Th_circuit+w./R_circuit;
yR_circuit=R_circuit.*cos(ThR_circuit);
zR_circuit=R_circuit.*sin(ThR_circuit);
circuitR=[circuit(1,:);yR_circuit;zR_circuit];

ThL_circuit=Th_circuit-w./R_circuit;
yL_circuit=R_circuit.*cos(ThL_circuit);
zL_circuit=R_circuit.*sin(ThL_circuit);
circuitL=[circuit(1,:);yL_circuit;zL_circuit];


x_meshcir=[circuit(1,:);circuit(1,:)];
y_meshcir=[yL_circuit;yR_circuit];
z_meshcir=[zL_circuit;zR_circuit];

colorcir=meshcolor(length(x_meshcir));
%% surface plot cycle
[Th_cycle,R_cycle]=cart2pol(cycle(2,:),cycle(3,:));

ThR_cycle=Th_cycle+w./R_cycle;
yR_cycle=R_cycle.*cos(ThR_cycle); %right surface
zR_cycle=R_cycle.*sin(ThR_cycle); 
cycleR=[cycle(1,:);yR_cycle;zR_cycle];

ThL_cycle=Th_cycle-w./R_cycle;
yL_cycle=R_cycle.*cos(ThL_cycle); %left surface
zL_cycle=R_cycle.*sin(ThL_cycle);
cycleL=[cycle(1,:);yL_cycle;zL_cycle];

x_meshcyc=[cycle(1,:);cycle(1,:)];
y_meshcyc=[yL_cycle;yR_cycle];
z_meshcyc=[zL_cycle;zR_cycle];

colorcyc=meshcolor(length(x_meshcyc));
%%
[Th_full,R_full]=cart2pol(full_layer(2,:),full_layer(3,:));

ThR_full=Th_full+w./R_full;
yR_full=R_full.*cos(ThR_full);
zR_full=R_full.*sin(ThR_full);
fullR=[full_layer(1,:);yR_full;zR_full];

ThL_full=Th_full-w./R_full;
yL_full=R_full.*cos(ThL_full);
zL_full=R_full.*sin(ThL_full);
fullL=[full_layer(1,:);yL_full;zL_full];

x_meshfull=[full_layer(1,:);full_layer(1,:)];
y_meshfull=[yL_full;yR_full];
z_meshfull=[zL_full;zR_full];

colorfull=meshcolor(length(x_meshfull));
%%
figure 
hold all
s1 = surf(x_meshcir,y_meshcir,z_meshcir,colorcir);
plot3(circuit(1,:), yR_circuit, zR_circuit, 'k','LineWidth',0.5);
plot3(circuit(1,:), yL_circuit, zL_circuit, 'k','LineWidth',0.5);
axis('equal')
set(s1,'EdgeColor','none')
hold off

figure
plot3(circuit(1,:), circuit(2,:), circuit(3,:));
%hold on
%plot3(circuitR(1,:), circuitR(2,:), circuitR(3,:));
%plot3(circuitL(1,:), circuitL(2,:), circuitL(3,:));
axis('equal')

figure
hold all

s2 = surf(x_meshcyc,y_meshcyc,z_meshcyc,colorcyc); %surface
plot3(cycleR(1,:), cycleR(2,:), cycleR(3,:), 'k','LineWidth',0.5); %out line
plot3(cycleL(1,:), cycleL(2,:), cycleL(3,:), 'k','LineWidth',0.5);
set(s2,'EdgeColor','none')
axis('equal')
hold off

figure
plot3(cycle(1,:), cycle(2,:), cycle(3,:));
axis('equal')
%view(90,0)  % YZ

%animate(cycle)

figure
hold all
layern=ceil(length(full_layer)*compl);
s3 = surf(x_meshfull(:,1:layern),y_meshfull(:,1:layern),z_meshfull(:,1:layern),colorfull(:,1:layern,:));
plot3(fullR(1,:), fullR(2,:), fullR(3,:), 'k','LineWidth',0.1); %out line
plot3(fullL(1,:), fullL(2,:), fullL(3,:), 'k','LineWidth',0.1);
set(s3,'EdgeColor','none')
axis('equal')
hold off

figure
plot3(full_layer(1,1:layern), full_layer(2,1:layern), full_layer(3,1:layern), 'LineWidth', 1);
axis('equal')
%animate(full_layer)
%view(90,0)  % YZ



%plot3(G(1,:), G(2,:), G(3,:), 'LineWidth',3);
%{
start_i = starts;
for i = 1:n
    start_i = i * start_i;
    Rotate = rotx(start_i);
    G_rot = mtimes(Rotate,G);
    x = G_rot(1,:);
    y = G_rot(2,:);
    z = G_rot(3,:);
    hold all
    plot3(x,y,z,'LineWidth',1);
    axis('equal')
    xlabel('x')
    ylabel('y')
    zlabel('z')
end
%}
