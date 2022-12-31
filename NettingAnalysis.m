toRad = pi / 180;

alpha = linspace(0, 80, 100);

S_F = 710000;%fiber strength
P = 1000;%pressure
N = 2; %safety factor
D = 8; %diameter
w = .25; %filament width
t = .004;%filament thickness
r_0 = .5;%starting radius
n_pts = 250; %number of points
R = D/2; %Radius 

S_D = S_F / N; %Design strength

N_hoop = P * R; %hoop force
N_axial = N_hoop / 2; %axial force

t_helical = zeros(1,length(alpha));
t_hoop = zeros(1,length(alpha));

for i = 1:length(alpha)
    t_helical(i) = N_axial / (S_D * cos(alpha(i)*toRad)^2); %hoop thickness
    t_hoop(i) = (N_hoop - N_axial * tan(alpha(i)*toRad)^2) / S_D; %helical thickness
end

t_total = t_helical + t_hoop;

plot(alpha, t_helical, 'LineWidth', 2);
hold on
plot(alpha, t_hoop, 'LineWidth', 2);
plot(alpha, t_total, 'LineWidth', 2);
title('Layer Thickness v.s Wind Angle')
legend('Helical', 'Hoop')
xlabel('Wind Angle (Degrees)')
ylabel('Thickness (in)')
ylim([0 .04])
xlim([0 58])