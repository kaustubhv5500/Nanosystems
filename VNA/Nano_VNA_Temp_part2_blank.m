%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nanosystems
% Labcourse Data post processing template
% VNA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Part 2

% Tasks:  - Normalize data 
%         - remove linear parts of real and imaginary signal components
%         - Fit a gaussian curve to the FMR peak
%         - repeat for all peaks
%         - extract paramters of the gaussian fit from processed data
%         - TIP: Use the Matlab curve fitting tool to interactivly fit
%                (APPS -> Curve Fitting)
%         - TIP: Check Matlab documentation https://de.mathworks.com/help/matlab/index.html

%% Data handling
clc;
clear;                   % clear workspace
filename = 'D:\Nanosystems\VNA_IP_27_06_part1.mat';      % input name of workspace with your data, from part 1
% filename = 'D:\Nanosystems\VNA_OOP_27_06_part1.mat';

load(filename);         % Load previous data in Workspace

label = 'part2';        % name for your new workspace
save_directory = 'D:\Nanosystems\';    % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% Correct the raw referenced data to get better fit results afterwards  
% iterate through all peaks, i.e. all magnetic field values
% Hint: check matlab documentation for making fits and how to extract fit
% parameters

% freq = freq./1e9;

for h = 1:length(Bvector)
    
    % 1.take a single vector from dS matrix
    dS_vec = dS(:,h);
    
    % 2.correct real part
    % take real part
    dS_vec_r(:,h) = real(dS_vec);
    
    % make a linear fit to the real part of signal
    lin_real = fittype('poly1'); 
    [poly1_real, gof] = fit(freq, dS_vec_r(:, h) ,lin_real);
    
    % extract slope and offset paramters from fit. 
    % Hint: poly1_real is a structure
    p1_real(h) = poly1_real.p1;
    p2_real(h) = poly1_real.p2;
    
%     subtract linear component from dS_vec_r
    real_corr(:,h) = dS_vec_r(:,h) - p1_real(h).*freq - p2_real(h);
    
%     3.correct imaginary part
%     take imaginary part
    dS_vec_i(:,h) = imag(dS_vec);
%     
%     make a linear fit to the imaginary part
    lin_imag = fittype('poly1');
    [poly1_imag, gof] = fit(freq, dS_vec_i(:,h),lin_imag);
    
%     extract slope and offset paramters from fit 
%     Hint: poly1_imag is a structure
    p1_imag(h) = poly1_imag.p1;
    p2_imag(h) =  poly1_imag.p2;
    
%     subtract linear component from dS_vec_i
    imag_corr(:,h) = dS_vec_i(:,h) - p1_imag(h).*freq - p2_imag(h);
    
    
%     4.put corrected real and imaginary part back together
%     i.e. calculate the absolute value of the signal without the linear parts
    abs_corr(:,h) = abs(real_corr(:,h) + imag_corr(:,h).*1j);
end

% normalize the data between 0 and 1
abs_corr(:,:) = rescale(abs_corr, 0, 1);

% Fit gaussian functions to all of the peaks
% iterate through all peaks, i.e. all magnetic field values
% and fit a guassian curve to the corrected data
% Hint: check matlab documentation for gauss fits and how to extract the
% parameters

figure
hold on

for k = 1:length(Bvector)
    GAUSS =  fittype('gauss1');     
    % This part is OPTIONAL! 
    % some fit options to optimize gauss fit (check out interactive fitting tool)
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    opts.Lower = [-Inf -Inf 0];
    opts.StartPoint = [1 1.5e9 1e8];

    % make a gauss fit
    [gauss_fit, gof] = fit(freq, abs_corr(:,k), GAUSS); % fit(...,opts) in case you want fit options
    
    % extract a,b,c paramters from gauss fit. 
    % Hint: gauss_fit is a structure

%     if k < 4
%         gauss_fit.a1 = gauss_fit.a1 * 1.3;
%         gauss_fit.c1 = gauss_fit.c1 * 0.3;
%     else
%         gauss_fit.a1 = gauss_fit.a1 * 1.3;
%         gauss_fit.c1 = gauss_fit.c1 * 0.4;
%     end
    
%         gauss_fit.a1 = gauss_fit.a1 * 1.3;
%         gauss_fit.b1 = gauss_fit.b1 + 0.1e8;
%         gauss_fit.c1 = gauss_fit.c1 * 0.4;
    a(k) = gauss_fit.a1;
    b(k) = gauss_fit.b1;
    c(k) = gauss_fit.c1;
    
    % plot the gauss fit and corresponding peak for the corrected data
    % Hint: check matlab documentation for automatically plot original data
    % and fits
    plot(gauss_fit, freq, abs_corr(:,k));
    legend('off');
    grid on;
end 

title('Gauss Fit of Linearly Corrected Data');
xlabel('Frequency');
ylabel('Normalised Abs(S21)');

% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);
