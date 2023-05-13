% Clear Memory and Command window
clc;
clear all;
close all;
wav_name='myvoice.wav';
[wav,f]=audioread (wav_name) ;
plot(wav);
%%
[x,f]=audioread ('myvoice.wav');
fx=fft(x);
plot(abs(fftshift(fx)));
%%
% Clear Memory and Command window
clc;
clear all;
close all;
[a,fs]=audioread ("myvoice.wav") ;
[ca1,cd1]=dwt(a(:,1),'db4') ;
a0=idwt(ca1,cd1,'db4',length(a(:,1))) ;
%绘图
subplot (2 ,2 ,1) ; plot ( a ( : , 1)) ; %原始波形
subplot (2 ,2 ,2) ; plot ( cd1 ) ; %细节分量
subplot (2 ,2 ,3) ; plot ( ca1 ) ; %近似分量
subplot (2 ,2 ,4) ; plot ( a0 ) ; %一级分解的重构结果
axes_handle = get ( gcf,'children') ;
axes ( axes_handle (4) ) ; title('( 1 ) wav original') ;
axes ( axes_handle (3) ) ; title('( 2 ) detail component') ;
axes ( axes_handle (2) ) ; title('( 3 ) approximation') ;
axes ( axes_handle (1) ) ; title('( 4 ) wav recover') ;
%%
% Clear Memory and Command window
clc;
clear all;
close all;
[a,fs]=audioread ("myvoice.wav") ;
[ca1,cd1]=wavedec(a(:,1),1 ,'db4') ;
a0=waverec(ca1,cd1,'db4') ;
%绘图
subplot (2 ,2 ,1) ; plot ( a ( : , 1)) ; %原始波形
subplot (2 ,2 ,2) ; plot ( cd1 ) ; %细节分量
subplot (2 ,2 ,3) ; plot ( ca1 ) ; %近似分量
subplot (2 ,2 ,4) ; plot ( a0 ) ; %一级分解的重 构 结 果
axes_handle = get ( gcf,'children') ;
axes ( axes_handle (4) ) ; title('( 1 ) wav original') ;
axes ( axes_handle (3) ) ; title('( 2 ) detail component') ;
axes ( axes_handle (2) ) ; title('( 3 ) approximation') ;
axes ( axes_handle (1) ) ; title('( 4 ) wav recover') ;
%%
% Clear Memory and Command window
clc;
clear all;
close all;
[a,fs]=audioread('myvoice.wav') ;
[c,l]=wavedec(a(:,2),3 ,'db4') ;
ca3=appcoef(c,l,'db4',3) ;
cd3=detcoef(c,l,3) ;
cd2=detcoef(c,l,2) ;
cd1=detcoef(c,l,1) ;
a0=waverec(c,l,'db4') ;

subplot (3 ,2 ,1) ; plot ( a ( : , 2 ) ) ;
subplot (3 ,2 ,2) ; plot ( ca3 ) ; % 三 级 分 解 近 似 分 量
subplot (3 ,2 ,3) ; plot ( cd1 ) ; % 一 级 分 解 细 节 分 量
subplot (3 ,2 ,4) ; plot ( cd2 ) ; % 二 级 分 解 细 节 分 量
subplot (3 ,2 ,5) ; plot ( cd3 ) ; % 三 级 分 解 细 节 分 量
subplot (3 ,2 ,6) ; plot ( a0 ) ; % 重 构 结 果
axes_handle = get ( gcf , 'children') ;
axes ( axes_handle (6) ) ; title( '( 1 ) wav original' ) ;
axes ( axes_handle (5) ) ; title( '( 2 ) 3 detail component ' ) ;
axes ( axes_handle (4) ) ; title ( '( 3 ) 1 approximation ' ) ;
axes ( axes_handle (3) ) ; title ( '( 4 ) 2 approximation ' ) ;
axes ( axes_handle (2) ) ; title ( ' ( 5 ) 3 approximation ' ) ;
axes ( axes_handle (1) ) ; title ( ' ( 6 ) wav recover') ;

%%
% Clear Memory and Command window
clc;
clear all;
close all;
[a,fs]=audioread('myvoice.wav') ;
dct_a=dct ( a ( : , 1 ) ) ;
a0=idct ( dct_a ) ;

subplot (3 ,1 ,1) ; plot ( a ( : , 1 ) ) ; %原 始 波 形
subplot (3 ,1 ,2) ; plot ( dct_a ) ; %dct 处 理 后 的 波 形
subplot (3 ,1 ,3) ; plot ( a0 ) ; %重 构 得 到 的 结 果

axes_handle = get ( gcf , 'children') ;
axes ( axes_handle (3) ) ; title ( '( 1 ) wav original') ;
axes ( axes_handle (2) ) ; title ( '( 2 ) wav dct' ) ;
axes ( axes_handle (1) ) ; title ( '( 3 ) wav recover' ) ;
