% Demo of non-blind image deconvolution
%   Author: Keting Zhang (zzsnail@sjtu.edu.cn)
%   Date:   September 10, 2016.

clear
% load an image
image = im2double(imread('.\Cameraman.png'));
sizImage = size(image);

% load the motion blur kernels from Krishnan and Rob Fergus, "Fast image deconvolution 
% using hyper-laplacian priors," NIPS 2009
load('.\kernels.mat');
kernel_ind = 1; % kernel 1 or 2
% load the trained model for specific kernel
load(['.\model_kernel',num2str(kernel_ind),'.mat'])
if kernel_ind == 1
    K = kernel1;
    weightSig = 2;   % Gaussian weighting average
else
    K = kernel2;
    weightSig = 1;
end

% generate the blurred image
randn('seed', 1);
noise = imfilter(image,K,'conv','symmetric','same');
noise = noise + 5/255*randn(size(noise));   % the Gaussian noise is sigma=5

% get the sizes of input and output
pSz = sqrt(size(W{1},2));
patchSzOut = sqrt(size(W{end},1));

% if input patch is larger than output patch, pad the images with mirror reflections
diffSize = (pSz-patchSzOut)/2;
noiseEx = noise;
noiseEx = padarray(noiseEx,[diffSize diffSize],'symmetric');

% convert the image into columns and normalization
patches = image2cols(noiseEx,pSz,1);
patches = 2*patches-1;

% deblur the patches and denormalization
patches = deblurPatch(W,b,t,patches);
patches = (patches+1)/2;

% get the deblurred image and compute the PSNR
denoised = columns2im(patches, sizImage, 1, weightSig);
dIpsnr = getPSNR(denoised,image,1);
nIpsnr = getPSNR(noise,image,1);

% show the results
figure;imshow(image);
title('clean image');
figure;imshow(noise);
title(['blurred image (kernel ',num2str(kernel_ind),'): ',num2str(nIpsnr),' dB']);
figure;imshow(denoised);
title(['deblurred image (kernel ',num2str(kernel_ind),'): ',num2str(dIpsnr),' dB']);
