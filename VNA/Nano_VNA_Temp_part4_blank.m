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
% filename = 'D:\Nanosystems\VNA_OOP_27_06_part3.mat';

load(filename);         % Load previous data in Workspace

label = 'part4';        % name for your new workspace
save_directory = 'D:\Nanosystems\';    % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% Make damping fits / alpha fits

% plot previous results
figure

subplot(2,1,1)
plot(Fvector, abs_corr,'r')

title('Corrected Data')
xlabel('Frequency in GHz')
ylabel('norm(abs(dS_{11}))')

% calculate FWHM from gaussian fit paramters
% TIP: Is the FWHM the same as the fit parameter?

for i=1:length(Bvector)
    c_n(i) = 2*sqrt(log(2)) * c(i);
    c_n(i) = 2.355 * c(i);
end

% Fit the slope of damping equation and declare independent value
alpha_fit = fittype("slope*x + deltaf_0");
[alphafitresult, gof_kit] = fit(Bvector', c_n', alpha_fit);

% extract slope and deltaf_0 paramters from damping fit. 
% Hint: alphafitresult is a structure
slope = alphafitresult.slope;
deltaf_0 = alphafitresult.deltaf_0;

% calculate alpha from fitted slope
% Hint: remember what unit GAMMA has. Maybe check also Minilab lecture slides
alpha = slope*pi/(GAMMA*1e12); 

% plot fit and original data
subplot(2,1,2)

plot(alphafitresult, Bvector, c_n)

title('Damping Fit');
xlabel('Magnetic Field in mT');
ylabel('Frequency in GHz')

% create a textbox with calculated values
dim = [.5 .0 .3 .3];
str = ['Alpha = ' num2str(alpha)];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

%% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);