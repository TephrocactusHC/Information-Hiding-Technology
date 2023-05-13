
%% encode
clc;
clear;
d = imread('./pic.bmp');
d = im2bw(d);
imwrite(d, 'black1.bmp', 'bmp')
subplot (1, 2, 1); imshow (d, []); title (' 原始图片 ');
secret = 2012026;

for t = 1:24
    s(t) = bitget(secret, t);
end

num = 1;
t = 1;

while t < 24

    if s(t) == 0

        switch (CalculateBlack(d, num))
            case 0
                t = t - 1;
                num = num + 4;
            case 1
                temp = 1;
                startnum = num;

                while temp < 3

                    if d(startnum) == 1
                        d(startnum) = 0;
                        temp = temp + 1;
                        startnum = startnum + 1;
                    end

                end

                num = num + 4;
            case 2
                temp = 2;
                startnum = num;

                while temp < 3

                    if d(startnum) == 1
                        d(startnum) = 0;
                        temp = temp + 1;
                        startnum = startnum + 1;
                    end

                end

                num = num + 4;
            case 3
                num = num + 4;
            case 4
                temp = 4;
                startnum = num;

                while temp > 3

                    if d(startnum) == 0
                        d(startnum) = 1;
                        temp = temp - 1;
                        startnum = startnum + 1;
                    end

                end

                num = num + 4;
        end

    else
        a = CalculateBlack(d, num)

        switch a
            case 0
                temp = 4;
                startnum = num;

                while temp > 3

                    if d(startnum) == 1
                        d(startnum) = 0;
                        temp = temp - 1;
                        startnum = startnum + 1;
                    end

                end

                num = num + 4;

            case 1
                num = num + 4;
            case 2
                temp = 2;
                startnum = num;

                while temp < 3

                    if d(startnum) == 0
                        d(startnum) = 1;
                        temp = temp + 1;
                        startnum = startnum + 1;
                    end

                end

                num = num + 4;
            case 3
                temp = 1;
                startnum = num;

                while temp < 3

                    if d(startnum) == 0
                        d(startnum) = 1;
                        temp = temp + 1;
                        startnum = startnum + 1;
                    end

                end

                num = num + 4;
            case 4
                t = t - 1;
                num = num + 4;
        end

    end

    t = t + 1;
end

imwrite(d, 'black2.bmp', 'bmp')

subplot (1, 2, 2); imshow (d, []); title (' 水印 ');



