function f = spm_fx_lfp(x,u,P,M)
 
 
% 3 populations 
%--------------------------------------------------------------------------
xe  = x(1) ;
xip = x(2) ;
xis = x(3) ;

% equations of motion (hidden model with 3 populations)
%--------------------------------------------------------------------------
f =   [P.A_EE*xe + P.A_EIp*xip + P.A_EIs*xis + P.C_e*u ;
       P.A_IpE*xe + P.A_IpIp*xip + P.A_IpIs*xis + P.C_Ip*u;
       P.A_IsE*xe + P.A_IsIp*xip + P.A_IsIs*xis + P.C_Is*u ];
 