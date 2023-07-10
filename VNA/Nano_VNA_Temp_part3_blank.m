%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nanosystems 
% Labcourse Data post processing template
% VNA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Part 3

% Tasks:  - select kittel fit (in-plane or out-off-plane)
%         - fit and extract M_eff from it
%         - TIP: Use the Matlab curve fitting tool to interactivly fit
%                (APPS -> Curve Fitting)
%         - TIP: Check Matlab documentation https://de.mathworks.com/help/matlab/index.html
 
%% Data handling
clc
clear                   % clear workspace
filename = 'D:\Nanosystems\VNA_IP_27_06_part2.mat';      % input name of workspace with your data, from part 3
filename = 'D:\Nanosystems\VNA_OOP_27_06_part2.mat';

load(filename);         % Load previous data in Workspace

label = 'part3';        % name for your new workspace
save_directory = 'D:\Nanosystems\';    % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% input the orientation of the sample during the measurement
direction = input('In-plane or out-of-plane measurement? (i/o)\n','s');

%% Make Kittel fits to corrected data 

% plot previous results
figure;
subplot(2,1,1);
plot(Fvector, abs_corr ,'r');

title('Corrected Data');
xlabel('Frequency in GHz');
ylabel('norm(abs(dS_{21}))');

% TIP: check matlab documentation for defining your own equation including your own scaling/fit parameters
% and how to define the x-axis parameter for this fit (= the independent value of your equation)
% For example: [y = a*x+b] could be defined as [func = steepness*xValues+yAxisInterception],
% where xValues is the independent parameter and the fit-structure will give you the fitted 'steepness' and
% 'yAxisInterception' values

% Bvector = [8.5 10.5 12.2 14.1 16.167 17.678 19.535 21.317 23.116 25.071 26.920 28.463 30.321 32.165 33.85 ];

for i=1:length(Bvector)
    gauss(:,i) = a(i).*exp(-((freq-b(i))./c(i)).^2);
%     [m, index] = max(abs_corr(:,i));
    [m, index] = max(gauss(:,i));
    max_freq(i) = freq(index)/1e9;
end

% Kittel-fits
if direction == 'i'
%     --- In-Plane ---
%     input fit equation (Kittel in-plane) and declare independent value
%     Hint: check matlab documentation for defining your own function

    Kitteltype_ip = fittype('gamma*sqrt(x*(x + M_eff))');
    [Kittel_fit_ip, gof_kit] = fit(Bvector', max_freq', Kitteltype_ip);

% Gamma = 2.81 MHz/mT
% Ms = 145 mT
%     extract Meff paramters from kittel fit. 
%     Hint: kittel is a structure
    Meff = Kittel_fit_ip.M_eff;
    GAMMA = Kittel_fit_ip.gamma*2*pi;
    
%     plot Kittel-Fit and Meff
    subplot(2,1,2);
    plot(Kittel_fit_ip, Bvector, max_freq);
    grid on;
    title('Kittel-Fit Plot (In-Plane)');
    xlabel('B in mT');
    ylabel('Frequency in GHz');
end    
if direction == 'o'
%     --- Out-Of-Plane ---
    
%     input fit equation (Kittel out-of-plane) and declare independent value
%     Hint: check matlab documentation for defining your own function 
    Kitteltype_oop = fittype('gamma*(x-M_eff)');
    
    [Kittel_fit_oop, gof_kit] = fit(Bvector', max_freq', Kitteltype_oop);
    
%     extract Meff paramters from kittel fit. 
%     Hint: kittel is a structure  
    Meff = Kittel_fit_oop.M_eff;
    GAMMA = Kittel_fit_oop.gamma;
    
%     plot Kittel-Fit and Meff
    subplot(2,1,2)
    plot(Kittel_fit_oop, Bvector, max_freq);
    grid on;

    title('Kittel-Fit Plot (Out-Of-Plane)')
    xlabel('B in mT')
    ylabel('Frequency in GHz')
end

% create a textbox with calculated values
dim = [.5 .0 .6 .2];
str = ['GAMMA = ' num2str(GAMMA) ' GHz/mT' '   M_{eff} = ' num2str(Meff) ' mT'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

% save results (complete workspace) to desired location
mkdir(save_directory); 
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);

