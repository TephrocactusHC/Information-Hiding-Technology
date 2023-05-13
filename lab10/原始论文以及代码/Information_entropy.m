% % 这个函数用于对求解信息熵；
% % I_gray表示带求解的图像矩阵；
% % Infor_entopy表示信息熵值。

function Infor_entopy=Information_entropy(I_gray)
%输出图片的图像熵值
[ROW,COL] = size(I_gray);
%矩阵用于统计256个灰度值的出现次数
temp = zeros(256);
for i= 1:ROW
    for j = 1:COL
        %统计当前灰度出现的次数
        temp(I_gray(i,j)+1)= temp(I_gray(i,j)+1)+1;
    end
end
res = 0.0 ;
for  i = 1:256
    %计算当前灰度值出现的概率
    temp(i) = temp(i)/(ROW*COL);
    %如果当前灰度值出现的次数不为0
    if temp(i)~=0.0
        res = res - temp(i) * (log(temp(i)) / log(2.0));
    end
    end
    Infor_entopy=res
    disp(Infor_entopy)
end
