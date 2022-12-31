function num_cycles = find_cycles(deg, error)

n=1;
while deg >= 180
    deg = deg - 180;
end
angle=deg;

if angle < error || angle > 180 - error
    n = 1;
else
    while abs(angle)> error
        angle=angle+deg;
        if angle>90
            angle=angle-180;
        end
        n=n+1;
    end
end

num_cycles=n;
end