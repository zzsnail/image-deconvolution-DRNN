%   Author: Harold Christopher Burger
%   Date:   March 19, 2012.
%   Modified by Keting Zhang on September 10, 2016

function res = columns2im(cols, im_sz, stride, wSig)

pSz = sqrt(size(cols,1));
res = zeros(im_sz(1), im_sz(2));
w = zeros(im_sz(1), im_sz(2));

if wSig > 0
    pixel_weights = zeros(pSz);
    mid = ceil(pSz/2);
    sig = floor(pSz/2)/wSig;
    for i=1:pSz
        for j=1:pSz
            d = sqrt((i-mid)^2 + (j-mid)^2);
            pixel_weights(i,j) = exp((-d^2)/(2*(sig^2))) / (sig*sqrt(2*pi));
        end
    end
    pixel_weights = pixel_weights/max(pixel_weights(:));
    cols = bsxfun(@times, cols, pixel_weights(:));
end

range_y = 1:stride:(im_sz(1)-pSz+1);
range_x = 1:stride:(im_sz(2)-pSz+1);
if (range_y(end)~=(im_sz(1)-pSz+1))
    range_y = [range_y (im_sz(1)-pSz+1)];
end
if (range_x(end)~=(im_sz(2)-pSz+1))
    range_x = [range_x (im_sz(2)-pSz+1)];
end

idx = 0;
for y=range_y
    for x=range_x
        idx = idx + 1;
        p = reshape(cols(:,idx), [pSz pSz]);
        res(y:y+pSz-1, x:x+pSz-1) = res(y:y+pSz-1, x:x+pSz-1) + p;
        if wSig > 0
            w(y:y+pSz-1, x:x+pSz-1) = w(y:y+pSz-1, x:x+pSz-1) + pixel_weights;
        else
            w(y:y+pSz-1, x:x+pSz-1) = w(y:y+pSz-1, x:x+pSz-1) + 1;
        end        
    end
end
res = res./w;

end

