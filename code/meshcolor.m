function [color] = meshcolor(n)
%rainbow
colorR=[1,0.5,0,0,1,1,1];%sequence of red values
colorG=[0,0,0,1,1,0.5,0];%sequence of green values
colorB=[0.5,1,1,0,0,0,0];%sequence of blue values
%
l=n/(length(colorR)-1);
R=linspace(0,0,n);
G=linspace(0,0,n);
B=linspace(0,0,n);
for j=1:length(colorR)-1
    R((j-1)*l+1:j*l)=linspace(colorR(j),colorR(j+1),l);
    G((j-1)*l+1:j*l)=linspace(colorG(j),colorG(j+1),l);
    B((j-1)*l+1:j*l)=linspace(colorB(j),colorB(j+1),l);
end
color(:,:,1)=R;
color(:,:,2)=G;
color(:,:,3)=B;
end