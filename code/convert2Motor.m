function [x_steps, y_steps] = convert2MotorY(x_inches, y_inches)
y_steps = y_inches*635;
x_steps = x_inches*1.7639;
end