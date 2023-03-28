function visualCrypRGB()
%divide a .bmp image into two crypted images
%show that two images and the recovered result
path = input("请输入要加密的图片：",'s');%彩色图（R-C.bmp）
gray = imread(path);

imshow(gray);

Size=size(gray);
origin=zeros(Size);
origin1=zeros(2*Size(1),2*Size(2),Size(3));
image1=zeros(2*Size(1),2*Size(2),Size(3));
image2=zeros(2*Size(1),2*Size(2),Size(3));

for i=1:3
%半色调化处理
origin(:,:,i) = turn_to_bw(gray(:,:,i));


%信息分存
[image1(:,:,i),image2(:,:,i)] = divide(origin(:,:,i));


%重新合并
origin1(:,:,i) = merge(image1(:,:,i),image2(:,:,i));

end

figure(1)
imshow(image1);
figure(2)
imshow(image2);
figure(3)
imshow(origin1);
figure(4)
imshow(origin);
end

function image = turn_to_bw(gray)
Size=size(gray);
x=Size(1);
y=Size(2);

for m=1:x
    for n=1:y
        if gray(m,n)>127
            out=255;
        else
            out=0;
        end
        error=gray(m,n)-out;
        if n>1 && n<255 && m<255
            gray(m,n+1)=gray(m,n+1)+error*7/16.0;  %右方
            gray(m+1,n)=gray(m+1,n)+error*5/16.0;  %下方
            gray(m+1,n-1)=gray(m+1,n-1)+error*3/16.0;  %左下方
            gray(m+1,n+1)=gray(m+1,n+1)+error*1/16.0;  %右下方
            gray(m,n)=out;
        else
            gray(m,n)=out;
        end
    end
end
image=gray;

end


function [image1,image2] = divide(image)
%init
Size=size(image);
x=Size(1);
y=Size(2);
image1=zeros(2*x,2*y);
image1(:,:)=255;
image2=zeros(2*x,2*y);
image2(:,:)=255;

%take image1 as first
for i = 1:x
    for j = 1:y
        key = randi(3);
        son_x=1+2*(i-1);
        son_y=1+2*(j-1);
        switch key
            case 1
                image1(son_x,son_y)=0; image1(son_x,son_y+1)=0;
                if image(i,j)==0
                    %origin is black
                    image2(son_x+1,son_y)=0; image2(son_x+1,son_y+1)=0;
                else
                    %origin is white
                    image2(son_x,son_y+1)=0; image2(son_x+1,son_y+1)=0;
                end
            case 2
                image1(son_x,son_y)=0; image1(son_x+1,son_y+1)=0;
                if image(i,j)==0
                    %origin is black
                    image2(son_x,son_y+1)=0; image2(son_x+1,son_y)=0;
                else
                    %origin is white
                    image2(son_x,son_y)=0; image2(son_x+1,son_y)=0;
                end
            case 3
                image1(son_x,son_y)=0; image1(son_x+1,son_y)=0;
                if image(i,j)==0
                    %origin is black
                    image2(son_x,son_y+1)=0; image2(son_x+1,son_y+1)=0;
                else
                    %origin is white
                    image2(son_x,son_y)=0; image2(son_x,son_y+1)=0;
                end
        end
    end
end

end


function image = merge(image1,image2)
Size=size(image1);
x=Size(1);
y=Size(2);
image=zeros(x,y);
image(:,:)=255;

for i=1:x
    for j=1:y
        image(i,j)=image1(i,j)&image2(i,j);
    end
end

end