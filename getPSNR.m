%   Author: Harold Christopher Burger
%   Date:   March 19, 2012.
function PSNR = getPSNR(noisy, clean, maxVal)
	Diff = double(noisy) - double(clean);
	RMSE = sqrt(mean(Diff(:).^2));
	PSNR = 20*log10(maxVal/RMSE);
end

