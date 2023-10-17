% CIC 128 MODE 25BIT
fs= 6e6;
R = 128;  % decimator factor
D = 1;  % differential delay 
N = 3;  % number of stage 13.46*3=40.4 dB

CICDecim = dsp.CICDecimator(R, D, N);
fs_ciccom_128m = 23437.5*2;
fPass_ciccom_128m = fs/2048;
fStop_ciccom_128m = 20000;

CICCompDecim_128m = dsp.CICCompensationDecimator('CICDifferentialDelay', 1,...
    'CICNumSections',3,...
    'CICRateChangeFactor', 128,...
    'DecimationFactor',2,...
    'PassbandFrequency',fPass_ciccom_128m, ...
    'PassbandRipple', 0.01, ...
    'StopbandFrequency',fStop_ciccom_128m,...
    'StopbandAttenuation', 120, ...
    'SampleRate',fs_ciccom_128m);
%   fvtool(CICCompDecim1,'Analysis','freq');
coff_compen_128m = coeffs(CICCompDecim_128m);
coff_ciccom_128m = coff_compen_128m.Numerator;
coff_ciccom_round_128m = round(coff_ciccom_128m * 2^11);
fvtool(CICCompDecim_128m,'Analysis','freq');
title("CICC 128mode")
% fvtool(CICDecim,CICCompDecim_128m,cascade(CICDecim,CICCompDecim_128m),'ShowReference','off','Fs');
% legend('CIC Decimator','CIC Compensator','Resulting Cascade Filter');

fs_half_128m_1 = fs/256;
trans_half_128m_1=6000;
hfirhalfbanddecim_128m = dsp.FIRHalfbandDecimator(...
    'Specification','Transition width and stopband attenuation',...
    'TransitionWidth',trans_half_128m_1,'StopbandAttenuation',90,'SampleRate',fs_half_128m_1);
half1en_128m = coeffs(hfirhalfbanddecim_128m);
half1co_128m = half1en_128m.Numerator;
half1co_r_128m = round(half1co_128m * 2^11);
fvtool(hfirhalfbanddecim_128m,'Analysis','freq');
title("Halfband1  128mode")

fs_half_128m_2 = fs/512;
trans_half128m_2=3000;
hfirha2fbanddecim_128m = dsp.FIRHalfbandDecimator(...
    'Specification','Transition width and stopband attenuation',...
    'TransitionWidth',trans_half128m_2,'StopbandAttenuation',80,'SampleRate',fs_half_128m_2);
half2en_128m = coeffs(hfirha2fbanddecim_128m);
half2co_128m = half2en_128m.Numerator;
half2co_r_128m = round(half2co_128m * 2^11);
fvtool(hfirha2fbanddecim_128m,'Analysis','freq');
title("Halfband2  128mode")


% CIC 256MODE 28BIT
fs_ciccom_256m = fs/256;
fPass_ciccom_256m = fs/2048;
fStop_ciccom_256m = 10000;

CICCompDecim_256m = dsp.CICCompensationDecimator('CICDifferentialDelay', 1,...
    'CICNumSections',3,...
    'CICRateChangeFactor', 256,...
    'DecimationFactor',2,...
    'PassbandFrequency',fPass_ciccom_256m, ...
    'PassbandRipple', 0.01, ...
    'StopbandFrequency',fStop_ciccom_256m,...
    'StopbandAttenuation', 120, ...
    'SampleRate',fs_ciccom_256m);
%   fvtool(CICCompDecim1,'Analysis','freq');
coff_compen_256m = coeffs(CICCompDecim_256m);
coff_ciccom_256m = coff_compen_256m.Numerator;
coff_ciccom_round_256m = round(coff_ciccom_256m * 2^11);
fvtool(CICCompDecim_256m,'Analysis','freq');
title("CICC 256mode")


fs_half_256m_1 = fs/512;
trans_half_256m_1=4000;
hfirhalfbanddecim_256m = dsp.FIRHalfbandDecimator(...
    'Specification','Transition width and stopband attenuation',...
    'TransitionWidth',trans_half_256m_1,'StopbandAttenuation',90,'SampleRate',fs_half_256m_1);
half1en_256m = coeffs(hfirhalfbanddecim_256m);
half1co_256m = half1en_256m.Numerator;
half1co_r_256m = round(half1co_256m * 2^11);
fvtool(hfirhalfbanddecim_256m,'Analysis','freq');
title("Halfband1  256mode")

% CIC 64MODE 22BIT
fs_ciccom_64m = fs/64;
fPass_ciccom_64m = fs/2048;
fStop_ciccom_64m = 40000;

CICCompDecim_64m = dsp.CICCompensationDecimator('CICDifferentialDelay', 1,...
    'CICNumSections',3,...
    'CICRateChangeFactor', 64,...
    'DecimationFactor',2,...
    'PassbandFrequency',fPass_ciccom_64m, ...
    'PassbandRipple', 0.01, ...
    'StopbandFrequency',fStop_ciccom_64m,...
    'StopbandAttenuation', 120, ...
    'SampleRate',fs_ciccom_64m);
%   fvtool(CICCompDecim1,'Analysis','freq');
coff_compen_64m = coeffs(CICCompDecim_64m);
coff_ciccom_64m = coff_compen_64m.Numerator;
coff_ciccom_round_64m = round(coff_ciccom_64m * 2^11);
fvtool(CICCompDecim_64m,'Analysis','freq');
title("CICC 64mode")


fs_half_64m_1 = fs/128;
trans_half_64m_1=16000;
hfirhalfbanddecim_64m1 = dsp.FIRHalfbandDecimator(...
    'Specification','Transition width and stopband attenuation',...
    'TransitionWidth',trans_half_64m_1,'StopbandAttenuation',80,'SampleRate',fs_half_64m_1);
half1en_64m = coeffs(hfirhalfbanddecim_64m1);
half1co_64m = half1en_64m.Numerator;
half1co_r_64m = round(half1co_64m * 2^11);
fvtool(hfirhalfbanddecim_64m1,'Analysis','freq');
title("Halfband1  64mode")

fs_half_64m_2 = fs/256;
trans_half_64m_2=10000;
hfirhalfbanddecim_64m2 = dsp.FIRHalfbandDecimator(...
    'Specification','Transition width and stopband attenuation',...
    'TransitionWidth',trans_half_64m_2,'StopbandAttenuation',90,'SampleRate',fs_half_64m_2);
half2en_64m = coeffs(hfirhalfbanddecim_64m2);
half2co_64m = half2en_64m.Numerator;
half2co_r_64m = round(half2co_64m * 2^11);
fvtool(hfirhalfbanddecim_64m2,'Analysis','freq');
title("Halfband2  64mode")

fs_half_64m_3 = fs/512;
trans_half_64m_3=3500;
hfirhalfbanddecim_64m3 = dsp.FIRHalfbandDecimator(...
    'Specification','Transition width and stopband attenuation',...
    'TransitionWidth',trans_half_64m_3,'StopbandAttenuation',100,'SampleRate',fs_half_64m_3);
half3en_64m = coeffs(hfirhalfbanddecim_64m3);
half3co_64m = half3en_64m.Numerator;
half3co_r_64m = round(half3co_64m * 2^11);
fvtool(hfirhalfbanddecim_64m3,'Analysis','freq');
title("Halfband1  64mode")
