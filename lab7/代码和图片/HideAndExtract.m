function HideAndExtract()
    x=imread ('Lena.bmp'); %载体图像
    y=imread ('lion.bmp'); %秘密信息图像  是灰度图像，长宽均为载体图像的一半
    y=imbinarize(y);
    [m, n]= size(y);

    subplot(2, 2, 1);
    imshow(x) ; title('原始图像');

    subplot(2, 2, 2);
    imshow(y) ; title('水印图像');

    x=Hide(x,m,n,y);
    subplot(2, 2, 3);
    imshow(x ,[]) ; title('伪装图像');

    t=Extract();
    subplot(2,2,4);
    imshow(t,[]); title("提取出的水印图像");
end


function out = checksum (x, i, j)
   %计 算 特 定 一 维 向 量 的 第m个 区 域 的 最 低 位 的 校 验 和
   temp= zeros(1, 4);
   temp(1) = bitget(x(2*i-1,2*j-1), 1);
   temp(2) = bitget(x(2*i-1,2*j), 1);
   temp(3) = bitget(x(2*i, 2*j-1), 1);
   temp(4) = bitget(x(2*i, 2*j ), 1);
   out=rem(sum(temp), 2);
end

function result=Hide(x,m,n,y)
    for i =1:m
        for j =1:n
            if checksum(x, i, j) ~= y(i, j) %需要反转一位
                random= int8(rand()*3);
                switch random  %任意反转一位
 				    case 0
 					    x(2*i-1,2*j-1)= bitset(x(2*i-1,2*j-1), 1, ~ bitget(x(2*i-1,2*j-1), 1));
				    case 1
 					    x(2*i-1,2*j)= bitset(x(2*i-1,2*j) , 1 , ~ bitget(x(2*i-1,2*j), 1));
				    case 2
 					    x(2*i, 2*j-1)= bitset(x(2*i, 2*j-1) ,1 ,~ bitget(x(2*i , 2*j-1) , 1));
                    case 3
 					    x(2*i , 2*j)= bitset(x(2*i , 2*j) , 1 , ~ bitget(x(2*i , 2*j) , 1));
                end
            end
        end
    end
    imwrite(x , 'watermarkedImage.bmp');
    result=x;
end


function out=Extract()
    c=imread('watermarkedImage.bmp');
    [m, n]= size(c);
    secret = zeros(m/2 , n/2);
    for i =1:m/2
        for j =1: n/2
            secret(i, j)= checksum(c, i, j);
        end
    end
    out=secret;
end