% Clear Memory and Command window
clc;
clear all;
close all;
img = imread("Lena.bmp");

k = input("请输入要显示的位平面：");

[m,n]=size(img);
c=zeros(m,n);
for i=1:m
    for j=1:n
        c(i,j)=bitget(img(i,j),k);
    end
end
figure;
imshow(c,[]);
title(['这是第',num2str(k),'个位平面']);
