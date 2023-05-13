function Method3()
    x=input('请输入载体图像：','s'); %载体图像
    m=input('请输入要隐藏的秘密信息图像：','s'); %水印图像
    WaterMarked=Hide(x,m);
    watermark=Extract(WaterMarked);
end
 
function WaterMarked = Hide(origin,watermark)
    fidx=fopen(origin,'r');
    
    %获取图像数据的偏移
    fseek(fidx,10,"bof"); 
    xoffset=fread(fidx,1,"uint32");

    %读取出文件头
    fseek(fidx,0,"bof");
    [xhead,xhlength]=fread(fidx,xoffset,'uint8'); 
    %读取出图像数据
    [xtail,xtlength]=fread(fidx,inf,"uint8");

    fidm=fopen(watermark,'r');
    [m,mlength]=fread(fidm,inf,'uint8');

    %写入所有数据，将水印信息放到文件头和图像数据之间的位置
    fid=fopen('Method3_watermarked.bmp','w');
    fwrite(fid,xhead);
    fwrite(fid,m);
    fwrite(fid,xtail);

    %还要更改图像数据偏移的字段，加上水印信息的文件长度
    fseek(fid,10,"bof");
    fwrite(fid,xoffset+mlength,"uint32");

    fclose(fid);
    fclose(fidx);
    fclose(fidm);

    WaterMarked=imread('Method3_watermarked.bmp');

    figure;
    imshow(WaterMarked,[]);
    title("WaterMarked Image");
    WaterMarked="Method3_watermarked.bmp";
end

function WaterMark=Extract(WaterMarked)
    fid=fopen(WaterMarked,'r');

    %获取载体图像的实际大小
    fseek(fid,2,"bof");
    xlen=fread(fid,1,'uint32');
    
    %读取整个文件，得到整个文件的大小
    fseek(fid,0,"bof");
    [A,truelen]=fread(fid,inf,'uint8');
    
    %相减，即可得到秘密信息的大小
    mlen=truelen-xlen;

    %获取载体图像数据的偏移，减去秘密信息的大小，就得到了秘密信息的偏移
    fseek(fid,10,"bof");
    xoffset=fread(fid,1,"uint32");
    moffset=xoffset-mlen;

    %由此，即可读出秘密信息
    fseek(fid,moffset,"bof");
    m=fread(fid,mlen,"uint8");

    fidm=fopen("method3_watermark.bmp","w");
    fwrite(fidm,m,"uint8");
    fclose(fidm);

    fclose(fid);

    WaterMark=imread('method3_watermark.bmp');
    figure;
    imshow(WaterMark,[]);
    title("WaterMark");
end