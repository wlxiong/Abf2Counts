function ind = lowerBound(haystack, needle, varargin)
% lowerBound(haystack, needle, varargin)
% unpack arguments
if nargin < 4
    hi = length(haystack);
    if nargin < 3
        lo = 1;
    else
        lo = varargin{1};
    end
else
    lo = varargin{1};
    hi = varargin{2};
end
hayleng = hi;
% binary search for the lower bound
while lo < hi
    mid = floor( (lo + hi) / 2.0 );
    if haystack(mid) == needle
        hi = mid;
    elseif haystack(mid) < needle
        lo = mid + 1;
    elseif haystack(mid) > needle
        hi = mid;
    end
end
% return index
if haystack(lo) == needle
    ind = lo;
elseif lo < hayleng
    ind = lo;
elseif haystack(lo) < needle
    ind = lo + 1;
else
    ind = lo;
end
