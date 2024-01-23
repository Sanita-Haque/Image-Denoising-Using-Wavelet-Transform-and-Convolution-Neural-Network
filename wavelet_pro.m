clc;
clear all;
I = imread('cameraman.png');
noisyI = imnoise(I, 'gaussian', 0, 0.005);  %add noise
%noisyI=imnoise(I,'speckle',0.05);
%noisyI = imnoise(I,'poisson') ;
[thr, sorh, keepapp] = ddencmp('den', 'wv', noisyI); %finding default values
% Denoise image using global thresholding.
denI = wdencmp('gbl', double(noisyI), 'sym4', 2, thr, sorh, keepapp);
subplot(131)
imshow(I)
title('Original Image')
subplot(132)
imshow(noisyI)
title('Noisy Image')
subplot(133)
imshow(uint8(denI))
title('denoised image')
%Finding SNR
% This gives the value of ratio between the original image and the noisy image
Orig_vs_Noisy_SNR = 20*log10(norm(double(I(:)))/norm(double(I(:))-double(noisyI(:))))
% This gives the value of ratio between the original image and the denoised image
Origin_vs_denoised = 20*log10(norm(double(I(:)))/norm(double(I(:))-double(denI(:))))  