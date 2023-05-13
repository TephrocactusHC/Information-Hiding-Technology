% Clear Memory and Command window
clc;
clear all;
close all;
img = imread("Lena.bmp");
k = input("请输入n的值：");

[a,b]=size(img);

y=zeros(a,b);
z=zeros(a,b);

for n=1:k
    for i=1:a
        for j=1:b
            x(i,j)=bitget(img(i,j),n); 
        end
    end
    for i=1:a
        for j=1:b
            y(i,j)=bitset(y(i,j),n,x(i,j));
        end
    end 
end


for n=k+1:8
    for i=1:a
        for j=1:b
            x(i,j)=bitget(img(i,j),n); 
        end
    end
    for i=1:a
        for j=1:b
            z(i,j)=bitset(z(i,j),n,x(i,j));
        end
    end 
end


figure;
imshow(y,[]);
title(['第1-',num2str(k),'个位平面']);


figure;
imshow(z,[]);
title(['第',num2str(k+1),'-8个位平面']);