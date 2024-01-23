clc;
clear all;
load SdnNet.mat
I = imread('cameraman.png');

% I = double(I);
noisyI = imnoise(I,'gaussian',0,0.005);
subplot(131)
imshow(I)
title("Original Image")
subplot(132)
imshow(noisyI)
title("Noisy Image")
denoisedI = denoiseImage(noisyI,SdnNet);
subplot(133)
imshow(denoisedI)
title('Denoised Image')
%Finding SNR
Orig_vs_Noisy_SNR = 20*log10(norm(double(I(:)))/norm(double(I(:))-double(noisyI(:))))   % This gives the value of ratio between the original image and the noisy image.
Origin_vs_denoised = 20*log10(norm(double(I(:)))/norm(double(I(:))-double(noisyI(:))))   % This gives the value of ratio between the original image and the denoised image.