%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nanosystems 
% Labcourse Data post processing template
% Lock-In FMR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Part 4

% Tasks:  - Understand Code
%         - Fit a curve to your peaks (Gaussian, Lorenzian)
%         - Visualize results
%         - TIP: Use the Matlab curve fitting tool to interactivly fit
%                (APPS -> Curve Fitting)
%         - TIP: Check Matlab documentation https://de.mathworks.com/help/matlab/index.html

%% Data handling
clc
clear                               % clear workspace
filename = 'D:\Nanosystems\Locked_in_IP_part3.mat';                      % input name of workspace with your data
% filename = 'D:\Nanosystems\Locked_in_OOP_part3.mat';

load(filename);                     % Load data in Workspace

label = 'part4';                    % name for your new workspace
save_directory = 'D:\Nanosystems\';                % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% Choose between sample orientations first

% input the orientation of the sample during the measurement
direction = input('In-plane or out-of-plane measurement? (i/o)\n','s');

if direction == 'i'
    %define an IP Kittel fit equation
    Kittel_type = fittype('gamma*sqrt(x*(x + M_eff))');       
elseif direction == 'o'
    %define an OOP Kittel fit equation
    Kittel_type = fittype('gamma*(x-M_eff)');   
else 
    disp('Wrong input! Press "i" or "o"')
    return
end

for i=1:length(Frequency)
    gauss(:,i) = a(i).*exp(-((Field(:,i)-b(i))./c(i)).^2);
    [m, index] = max(gauss(:,i))
    max_field(i) = Field(index, i);
end

%% Make the Kittel fits
%TIP: check matlab documentation for defining your own equation including your own scaling/fit parameters
%and how to define the x-axis parameter for this fit (= the independet value of your equation)
%For example: [y = a*x+b] could be defined as [func = steepness*xValues+yAxisInterception],
% where xValues is the independent parameter and the fit-structure will give you the fitted 'structure' and
%'yAxisInterception' values

%Create a plot
figure

%Create a subplot
subplot(2,1,1)

grid on 
hold on 

freq = Frequency;
%Fit the Kittel Curve to your resonance fields
[Kittel_fit, gof_kit] = fit(max_field', freq', Kittel_type);

%Extract fitting paramters
%TIP: you can directly access them according to your fit definition above
Meff = Kittel_fit.M_eff;
GAMMA_new = Kittel_fit.gamma;

%Plot results
plot(Kittel_fit, max_field, freq);

%Give your figure a title and name axis!
title('Kittel Fit Graph')
xlabel('Magnetic Field in mT')
ylabel('Resonance Frequency in GHz')

% You can also manualy define the axis limits
% xlim()
% ylim()

% add a legend
% legend()

% create a textbox to show calculated values  directly in figure
dim = [.6 .35 .3 .4];
str = ['M_{eff} = ' num2str(Meff) ' mT' newline '\gamma = ' num2str(GAMMA_new) ' GHz/mT'];
annotation('textbox',dim,'String',str,'FitBoxToText','on');

hold off

% %% Make the alpha fits / damping fits
% subplot(2,1,2)
% 
% grid on 
% hold on 
% 
% %calculate FWHM from gaussian fit paramters
% %TIP: Is the FWHM the same as the fit parameter?
% c_n = ;
% 
% %Fit the slope for alpha values
% %TIP: check matlab documentation for defining your own equation and how to
% %define the x-axis parameter for this fit
% %TIP2: which function would you expect for this fit?
% alpha_fit = fittype();    
% [alphafitresult, gof_kit] = fit( , , alpha_fit);
% 
% %Extract fit paramters
% %TIP: you can directly access them according to your fit definition above
% slope = ;
% deltaB_0 = ;
% 
% %Calculate damping coefficient
% alpha = ; 
% 
% %plot fit results for alpha and compare them with the original data points
% plot()
% 
% title('')
% xlabel('')
% ylabel('')
% xlim()
% ylim()
% 
% % add a legend
% legend()
% 
% % create a textbox with calculated values
% dim = ;
% str = ;
% annotation();
% 
% hold off
% 
% %% save results (complete workspace) to desired location
% mkdir(save_directory);
% measurefile = [filename(1:(end-4)) '_' label '.mat'];
% save([save_directory measurefile]);
