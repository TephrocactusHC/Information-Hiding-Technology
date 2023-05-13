% Clear Memory and Command window
clc;
clear all;
close all;
image=imread('Lena.bmp')
message=imread('lion.bmp')
[m,n]=size(image);
for i=1:m
    for j=1:n
        image(i,j)=bitset(image(i,j),1,message(i,j));
    end
end
figure;
imshow(image,[]);
title(['隐藏后的图像']);
imwrite(image,'hide_image.png','png')
%%
% Clear Memory and Command window
clc;
clear all;
close all;
image=imread('hide_image.png')
[m,n]=size(image);
x=zeros(m,n);
for i=1:m
    for j=1:n
        x(i,j)=bitget(image(i,j),1);
    end
end
figure;
imshow(x,[])
title(['解密出来的图像']);