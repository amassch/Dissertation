function [Ep1, Ep2] = integrate_invert_EII(data1, data2)

%==========================================================================
%==========================================================================
% Running it for the 1. phase
%==========================================================================
%==========================================================================

% model parameters (free parameters)
%--------------------------------------------------------------------------
P.A_EE      = 0.1;                  % excitatory self-coupling 
P.A_EIp     = -0.1;                 % inhibitory parvalbumin to excitation coupling         
P.A_IpE     = 0.1;                  % excitatory to inhibitory parvalbumin coupling  
P.A_IpIp    = -0.1;                 % inhibitory parvalbumin self-coupling  
P.A_EIs     = -0.1;                 % inhibitory somatostatin to excitation coupling 
P.A_IsE     = 0.1;                  % excitatory to inhibitory somatostatin coupling
P.A_IsIp    = 0;                    % inhibitory parvalbumin to inhibitory somatostatin coupling
P.A_IsIs    = -0.1;                 % inhibitory somatostatin self-coupling  
P.A_IpIs    = -0.1;                 % inhibitory somatostatin to inhibitory parvalbumin coupling 
P.C_e       = 0.39;                 % external excitation coupling
P.C_Ip      = 1;                    % external inhibitory parvalbumin coupling
P.C_Is      = 0.02;                 % external inhibitory somatostatin coupling
P.scale     = 1;                    % param to scale voltage - optimise once then fix

% prior covariance
%--------------------------------------------------------------------------
pC.A_EE     = 1;                    % excitatory self-coupling 
pC.A_EIp    = 1;                    % inhibitory parvalbumin to excitation coupling           
pC.A_IpE    = 1;                    % excitatory to inhibitory parvalbumin coupling  
pC.A_IpIp   = 1;                    % inhibitory parvalbumin self-coupling  
pC.A_EIs    = 1;                    % inhibitory somatostatin to excitation coupling 
pC.A_IsE    = 1;                    % excitatory to inhibitory somatostatin coupling
pC.A_IsIp   = 0;                    % inhibitory parvalbumin to inhibitory somatostatin coupling
pC.A_IsIs   = 1;                    % inhibitory somatostatin self-coupling  
pC.A_IpIs   = 1;                    % inhibitory somatostatin to inhibitory parvalbumin coupling 
pC.C_e      = 1;                    % external excitation coupling
pC.C_Ip     = 1;                    % external inhibitory parvalbumin coupling
pC.C_Is     = 1;                    % external inhibitory somatostatin coupling
pC.scale    = 1;                    % change to 0 to fix this to a value for the whole datasetn

M.IS = 'spm_int_ode';               % integrator
M.FS = [];                          % feature selection (not in this case)
M.f  = 'spm_fx_lfp';                % equation of motion
M.g  = 'spm_gx_lfp';                % observation function
M.x  = sparse(1,3);                 % 3 state model
M.E.dt = 0.001;                     % integration step
M.n  = 3;                           % 3 populations
M.pE = P;                           % priors of parameters
M.pC = pC;                          % prior covariance of parameters
%M.m  = 1;                          % one channel
M.l  = 1;                           % one channel


% input 
%--------------------------------------------------------------------------
N = 600;                                             % length of time series
U.u   = sparse(140:168,1,1,N,1)*64 + randn(N,1);     % noisy burst from 140 to 168 msec - taking 40ms into account that the signal takes get from retina to V1
figure;plot(U.u)
 

% Simulate Forward
%==========================================================================
LFP   = spm_int_ode(P,M,U);                          % given the priors and the input this is how the system behaves 
figure;plot(LFP)                                     % a prior figure                          


% invert
%==========================================================================
% call data
%--------------------------------------------------------------------------
Y.y      	= data1';                                % must be samples x 1

% invert real data
%--------------------------------------------------------------------------
[Ep,Cp,Eh,F,L,dFdp,dFdpp]  = spm_nlsi_GN(M,U,Y);

% simulate forward given posteriors
%--------------------------------------------------------------------------
LFP1   = spm_int_ode(Ep,M,U);                        
figure;plot(LFP1)                                    % plot the dynamics as per the POSTERIOR

% storing model output
%--------------------------------------------------------------------------
Ep1.Ep = Ep;
Ep1.Cp = Cp;
Ep1.Eh = Eh;
Ep1.F = F;
Ep1.L = L;
Ep1.dFdp = dFdp;
Ep1.dFdpp = dFdpp;

%==========================================================================
%==========================================================================
% Running it for the 2. phase
%==========================================================================
%==========================================================================

% model parameters (free parameters)
%--------------------------------------------------------------------------
P.A_EE      = 0.1;                  % excitatory self-coupling 
P.A_EIp    	= -0.1;                 % inhibitory parvalbumin to excitation coupling         
P.A_IpE     = 0.1;                  % excitatory to inhibitory parvalbumin coupling  
P.A_IpIp    = -0.1;                 % inhibitory parvalbumin self-coupling  
P.A_EIs     = -0.1;                 % inhibitory somatostatin to excitation coupling 
P.A_IsE     = 0.1;                  % excitatory to inhibitory somatostatin coupling
P.A_IsIp    = 0;                    % inhibitory parvalbumin to inhibitory somatostatin coupling
P.A_IsIs    = -0.1;                 % inhibitory somatostatin self-coupling  
P.A_IpIs    = -0.1;                 % inhibitory somatostatin to inhibitory parvalbumin coupling 
P.C_e       = 0.39;                 % external excitation coupling
P.C_Ip      = 1;                    % external inhibitory parvalbumin coupling
P.C_Is      = 0.02;                 % external inhibitory somatostatin coupling
P.scale     = 1;                    % param to scale voltage - optimise once then fix

% prior covariance
%--------------------------------------------------------------------------
pC.A_EE     = 1;                    % excitatory self-coupling 
pC.A_EIp    = 1;                    % inhibitory parvalbumin to excitation coupling           
pC.A_IpE    = 1;                    % excitatory to inhibitory parvalbumin coupling  
pC.A_IpIp   = 1;                    % inhibitory parvalbumin self-coupling  
pC.A_EIs    = 1;                    % inhibitory somatostatin to excitation coupling 
pC.A_IsE    = 1;                    % excitatory to inhibitory somatostatin coupling
pC.A_IsIp   = 0;                    % inhibitory parvalbumin to inhibitory somatostatin coupling
pC.A_IsIs   = 1;                    % inhibitory somatostatin self-coupling  
pC.A_IpIs   = 1;                    % inhibitory somatostatin to inhibitory parvalbumin coupling 
pC.C_e      = 1;                    % external excitation coupling
pC.C_Ip     = 1;                    % external inhibitory parvalbumin coupling
pC.C_Is     = 1;                    % external inhibitory somatostatin coupling
pC.scale    = 1;                    % change to 0 to fix this to a value for the whole datasetn

M.IS = 'spm_int_ode';               % integrator
M.FS = [];                          % feature selection (not in this case)
M.f  = 'spm_fx_lfp';                % equation of motion
M.g  = 'spm_gx_lfp';                % observation function
M.x  = sparse(1,3);                 % 3 state model
M.E.dt = 0.001;                     % integration step
M.n  = 3;                           % 3 populations
M.pE = P;                           % priors of parameters
M.pC = pC;                          % prior covariance of parameters
%M.m  = 1;                          % one channel
M.l  = 1;                           % one channel

% input 
%--------------------------------------------------------------------------
N = 600;                                             % length of time series
U.u   = sparse(140:168,1,1,N,1)*64 + randn(N,1);     % noisy burst from 140 to 168 msec - taking 40ms into account that the signal takes get from retina to V1
figure;plot(U.u)
 

% Simulate Forward
%==========================================================================
LFP   = spm_int_ode(P,M,U);                          % given the priors and the input this is how the system behaves 
figure;plot(LFP)                                     % a prior figure                          


% invert
%==========================================================================

% call data
%--------------------------------------------------------------------------
Y.y      	= data2';                                % must be samples x 1

% invert real data
%--------------------------------------------------------------------------
[Ep,Cp,Eh,F,L,dFdp,dFdpp]  = spm_nlsi_GN(M,U,Y);

% simulate forward given posteriors
%--------------------------------------------------------------------------
LFP2   = spm_int_ode(Ep,M,U);                        
figure;plot(LFP2)                                    % plot the dynamics as per the POSTERIOR

% storing model output
%--------------------------------------------------------------------------
Ep2.Ep = Ep;
Ep2.Cp = Cp;
Ep2.Eh = Eh;
Ep2.F = F;
Ep2.L = L;
Ep2.dFdp = dFdp;
Ep2.dFdpp = dFdpp;


