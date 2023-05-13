function original = niyiwei(B1, picturess)
% 创建与输入图像大小相同的数组来存储逆向操作后的像素值
original = zeros(size(picturess));
% 循环移位逆操作
for i = 1:numel(picturess)
    % 将逆向移位前的像素值转换为8位二进制表示
    ershu = dec2bin(picturess(i), 8);    
    % 将二进制表示的位移值转换为对应的十进制数
    result = dec2bin(B1(i));
    yishu = sum(result - '0');
    % 使用circshift函数对ershu进行逆向移位操作
    e = circshift(ershu', yishu)'; 
    % 将逆向移位后的二进制表示转换为十进制数，并更新original数组中的对应像素值
    original(i) = bin2dec(e);
end
end
