function ind = upperBound(haystack, needle, varargin)
% upperBound(haystack, needle, varargin)
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
hi = hi + 1;
cmp = nan;
% binary search for the lower bound
while lo < hi
    mid = floor( (lo + hi) / 2.0 );
    cmp = needle - haystack(mid);
    if cmp == 0
        lo = mid + 1;
    elseif cmp > 0
        lo = mid + 1;
    elseif cmp < 0
        hi = mid;
    end
end
% return index
if lo == 1
    if cmp == 0
        ind = 1;
    else
        ind = -1;
    end
elseif haystack(lo-1) == needle
    ind = lo - 1;
else
    ind = -lo;
end
