clear
close all;
rootFolder = 'TrainingData';
imds = imageDatastore(fullfile(rootFolder), ...
    'LabelSource', 'foldernames');
dnds = denoisingImageDatastore(imds,...
    'PatchesPerImage',512,...
    'PatchSize',50,...
    'GaussianNoiseLevel',[0.01 0.1],...
    'ChannelFormat','grayscale');
%imds = imageDatastore(fullfile(rootFolder,'automobile'), ...
   % 'LabelSource', 'foldernames');
% *Define Layers*
varSize = 1;

%CNN Layers
layers = [ ...
    imageInputLayer([50 50 1])
    
    convolution2dLayer(3,64,'Stride',1,'Padding',[1 1 1 1])
    reluLayer
    
    convolution2dLayer(3,64,'Stride',1,'Padding',[2 2 2 2])
    reluLayer
    convolution2dLayer(3,64,'Stride',1,'Padding',[1 1 1 1])
    reluLayer

    convolution2dLayer(3,1)
    regressionLayer];

% *Define training options*
opts = trainingOptions('adam', ...
    'InitialLearnRate', 0.01, ...
    'LearnRateSchedule', 'piecewise', ...
    'LearnRateDropFactor', 0.1, ...
    'LearnRateDropPeriod', 8, ...
    'L2Regularization', 0.004, ...
    'MaxEpochs', 10, ...
    'MiniBatchSize', 1000, ...   
    'Plots','training-progress','Verbose', true);
analyzeNetwork(layers) % Checking the CNN network status.

[SdnNet, info] = trainNetwork(dnds, layers, opts);

save('SdnNet.mat', 'SdnNet');

% I = imread('cameraman.tif');
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