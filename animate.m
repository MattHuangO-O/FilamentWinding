function animate(g)
x = g(1,:);
y = g(2,:);
z = g(3,:);
x_max = x(end) + 1;

len = length(x);

for k = 1: len
    plot3(x(k), y(k), z(k), 'x')
    hold on
    plot3(x(1:k), y(1:k), z(1:k), 'LineWidth',3);
    xlim([0,x_max])
    axis('equal')
    xlabel('x')
    ylabel('y')
    zlabel('z')
    %view(90,0)
    pause(.1);
    if k~= length(len)
        clf
    end
end
hold off;
end