% Feed the blurred patches into the trained model and obtain the deblurred patches
% Input:
%      W,b,t: all parameters of the trained model
%      patches: the blurred patches
% Output:
%      res: the deblurred patches
%
% Author: Keting Zhang
% Date:   September 10, 2016.
function res = deblurPatch(W,b,t,patches)

m = length(W)+1;
% A = cell(m-1,1);
A = patches;
for i = 1:m-2
    A = allAct(bsxfun(@plus,W{i}*A,b{i}),t{i});
end
res = bsxfun(@plus,W{m-1}*A,b{m-1});
end

% The activation function equivalent to the dual-pathway architecture
function A = allAct(x,t)
A = max(0,x)-max(0,bsxfun(@plus,-x,t));
end