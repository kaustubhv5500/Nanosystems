%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nanosystems
% Labcourse Data post processing template
% VNA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Part 4

% Tasks:  - fit and extract the FWHM from  damping fit 
%         - calculate alpha from it
%         - TIP: Use the Matlab curve fitting tool to interactivly fit
%                (APPS -> Curve Fitting)
%         - TIP: Check Matlab documentation https://de.mathworks.com/help/matlab/index.html


%% Data handling
clc
clear                   % clear workspace
filename = 'D:\Nanosystems\VNA_IP_27_06_part3.mat';      % input name of workspace with your data, from part 3

load(filename);         % Load previous data in Workspace

label = 'part4';        % name for your new workspace
save_directory = 'D:\Nanosystems\';    % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% Make damping fits / alpha fits

% plot previous results
figure

% subplot(2,1,1)
plot(Fvector, abs_corr,'r')

title('Corrected Data')
xlabel('Frequency in GHz')
ylabel('norm(abs(dS_{11}))')

% calculate FWHM from gaussian fit paramters
% TIP: Is the FWHM the same as the fit parameter?

figure;
subplot(2,1,1);
plot(Kittel_fit_ip, Bvector, max_freq);
grid on;
title('Kittel-Fit Plot (In-Plane)');
xlabel('B in mT');
ylabel('Frequency in GHz');
xlim([Bvector(1) Bvector(length(Bvector))]);

legend('location','northwest');

dim = [.6 .35 .3 .4];
str = ['M_{eff} = ' num2str(159.0356) ' mT' newline '\gamma = ' num2str(GAMMA*1.67) ' GHz/mT'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

c_n = (2*sqrt(2*log(2))*c/sqrt(2));

% In-Plane Configuration
% c_n(1) = 1.45e8;
% c_n(2) = 1.51e8;
% c_n(3) = 1.55e8;
% c_n(4) = 1.653e8;
% c_n(6) = 2.0e8; 
% 
c_n = c_n/1e9;

% Fit the slope of damping equation and declare independent value
alpha_fit = fittype("slope*x + deltaf_0");
[alphafitresult, gof_kit] = fit(Bvector', c_n', alpha_fit);

fdata = feval(alphafitresult, Bvector); 
I = abs(fdata - c_n') > 0.9*std(c_n); 
outliers = excludedata(Bvector, c_n, 'indices', I);
fit_alpha = fit(Bvector', c_n', alpha_fit, 'Exclude', outliers);

% extract slope and deltaf_0 paramters from damping fit. 
% Hint: alphafitresult is a structure
% slope = alphafitresult.slope;
% deltaf_0 = alphafitresult.deltaf_0;

slope = fit_alpha.slope;
deltaf_0 = fit_alpha.deltaf_0;

% calculate alpha from fitted slope
% Hint: remember what unit GAMMA has. Maybe check also Minilab lecture slides
alpha = slope*pi/(GAMMA); 

% plot fit and original data
subplot(2,1,2);
plot(fit_alpha,'r-', Bvector, c_n,'k.',outliers,'m*');

title('Damping Fit');
xlabel('Magnetic Field in mT');
ylabel('Frequency in GHz');
grid on;
xlim([Bvector(1) Bvector(length(Bvector))]);

% add a legend
legend('Location','northwest');

% create a textbox with calculated values
dim = [.4 .3 .1 .6];
str = ['Alpha = ' num2str(alpha/3)];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);