function [midoutcome] = freq_decomp(VEPs, baseline, f, tf, filelist) 

% VEPs = structure of all VEPs during the familiar and novel stimulus
% stored in a seperated by stimulus block (1 x 5 cell)

% baseline = structure of all grey-screen windows seperated whether prior
% to the familiar and novel stimulus and stored seperated by stimulus block (1 x 5 cell)

% f = number of datasets loaded

% tf = important for knowing whether one or multiple files selected; tf==0
% single file and tf==1 multiple files

% filelist = all filenames are stored in individual cells

%%=========================================================================
%% Analysis of familiar stimulus
%%=========================================================================

% specify sampling rate
srate = 1000; % sampled at 1000 Hz (1kHz)

for blocki = 1:length(VEPs.fam) % loop over blocks
    
    % number of ffts
    nfft = 1500;

    % Hann window
    winsize = 200;                                      % window size
    overlap = winsize/2;                                % overlap of windows
    hannw = (.5 - cos(2*pi*linspace(0,1,winsize))./2);  % create actual hann window


    for rowi = 1:size(VEPs.fam{blocki},1) % loop over rows (individual VEPs)
        
        % pick specific block and corresponding baseline window
        pick = VEPs.fam{blocki};
        currbaseline = baseline.fam{blocki};
        
        % run p welch function for one VEP of the selected block
        [pxx ,hz] = pwelch(pick(rowi,:),hannw,overlap,nfft,srate);  % frequency decomposition for VEP
        [bpxx ,hz] = pwelch(currbaseline,hannw,overlap,nfft,srate); % frequency decomposition for baseline
        
        % store results
        fam(rowi,:) = pxx';                     % raw power
        famdb(rowi,:) = 10*log10(pxx'./bpxx');  % dB-normalised power to the grey screen

    end

    midoutcome.fam (blocki,:,:) = fam;    % store raw power of all VEPs in all blocks
    midoutcome.famdb(blocki,:,:) = famdb; % store dB-normalised power of all VEPs in all blocks

end

%%=========================================================================
%% Analysis of novel stimulus
%%=========================================================================

for blocki = 1:length(VEPs.nov) % loop over blocks

    % number of ffts
    nfft = 1500;

    % Hann window
    winsize = 200;                                       % window size
    overlap = winsize/2;                                 % overlap of windows
    hannw = (.5 - cos(2*pi*linspace(0,1,winsize))./2);   % create actual hann window

    for rowi = 1:size(VEPs.nov{blocki},1) % loop over rows (individual VEPs)

        % pick specific block and corresponding baseline window
        pick = VEPs.nov{blocki};
        currbaseline = baseline.nov{blocki};
        
        % run p welch function for one VEP of the selected block
        [pxx ,hz] = pwelch(pick(rowi,:),hannw,overlap,nfft,srate);  % frequency decomposition for VEP
        [bnpxx ,hz] = pwelch(currbaseline,hannw,overlap,nfft,srate); % frequency decomposition for baseline
        
        % store results
        nov(rowi,:) = pxx';                      % raw power
        novdb(rowi,:) = 10*log10(pxx'./bnpxx');   % dB-normalised power to the grey screen

    end

    midoutcome.nov (blocki,:,:) = nov;       % store raw power of all VEPs in all blocks
    midoutcome.novdb(blocki,:,:) = novdb;    % store dB-normalised power of all VEPs in all blocks

end

%%=========================================================================
%% Store more information as function output
%%=========================================================================

midoutcome.VEPdata = VEPs;      % store VEPs
midoutcome.basedata = baseline; % store baseline window
midoutcome.hz = hz;             % store the interval of frequency decomposition
    


%% store file names

if tf ~= 0 % multiple files
   str = strcat(filelist{f});
   expression = '_';
   splitStr = regexp(str, expression, 'split');
   midoutcome.name = char(strcat(splitStr(1, 2)));
else % single file
   str = strcat(filename);
   expression = '_';
   splitStr = regexp(str, expression, 'split');
   midoutcome.name = char(strcat(splitStr(1, 2)));
end
    
end