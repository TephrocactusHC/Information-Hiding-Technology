% Pre-process images.
clc;clear all;close all;
img = (imread('./raw.bmp'));
watermark = imbinarize(imread('./watermark.bmp'));
img = imresize(img, [256, 256]);
watermark = imresize(~watermark, [64,64]);

img = double(img)/256;
watermark = im2double(watermark);
size = 256; width = 4;

blocks = size / width;
new_image = zeros(size);
vec = ones(64);

for i = 1 : blocks
    for j = 1 : blocks
        x = (i - 1) * width + 1;
        y = (j - 1) * width + 1;
        cur = img(x:x+width-1, y:y+width-1);
        cur = dct2(cur);
        
        if watermark(i, j) == 0
            a = -1;
        else
            a = 1;
        end
        
        cur(1, 1) = cur(1, 1) * (1 + .01 * a) + .01 * a;
        cur = idct2(cur);
        new_image(x: x + width - 1, y : y + width - 1) = cur;
    end
end

for i = 1 : blocks
    for j = 1 : blocks
        x = (i - 1) * width + 1;
        y = (j - 1) * width + 1;
        
        if new_image(x, y) > img(x, y)
            vec(i, j) = 1;
        else
            vec(i, j) = 0;
        end
    end
end

subplot(231); imshow(img);title("原始图像");
subplot(232); imshow(watermark);title("水印图像");
subplot(233); imshow(imcomplement(watermark));title("反色之前的水印图像");
subplot(234); imshow(new_image,[]);title("嵌入水印");
subplot(235); imshow(vec,[]);title("提取图像");
subplot(236); imshow(imcomplement(vec),[]);title("提取图像后反色与原图对比");