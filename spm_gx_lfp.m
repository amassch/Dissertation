function g = spm_gx_lfp(x,u,P,M)

% population that observed
%--------------------------------------------------------------------------
 xe  = x(1);
 
% observation function (to generate timeseries - output)
%--------------------------------------------------------------------------
g =  -(xe) *P.scale ; 