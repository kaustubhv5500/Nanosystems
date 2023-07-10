%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nanosystems 
% Labcourse Data post processing template
% Lock-In FMR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Part 3

% Tasks:  - Understand Code
%         - Fit a curve to your peakes (Gaussian, Lorenzian)
%         - Visualize results
%         - TIP: Use the Matlab curve fitting tool to interactivly fit
%                (APPS -> Curve Fitting)
%         - TIP: Check Matlab documentation https://de.mathworks.com/help/matlab/index.html

%% Data handling
clear                               % clear workspace
filename = 'D:\Nanosystems\Locked_in_IP_part2.mat';                      % input name of workspace with your data
% filename = 'D:\Nanosystems\Locked_in_OOP_part2.mat';

load(filename);                     % Load data in Workspace

label = 'part3';                    % name for your new workspace
save_directory = 'D:\Nanosystems\';                % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% Fit a gauss function to each of the peaks in the flattened (and maybe windowed) data 
% Create a plot
figure

grid on 
hold on 

 
%Iterate over all frequencies
for i = 1:length(Frequency)
    %fit a gaussian function to edited data
    GAUSS =  fittype('gauss1'); 
    [gauss_fit, gof] = fit(Field(:,i), Integral_flat(:,i), GAUSS);
    
    %Extract fit parameters
    a(i) = gauss_fit.a1;
    b(i) = gauss_fit.b1;
    c(i) = gauss_fit.c1;  
    
    %Plot data and fitted curves in the same plot to evaluate your fits
    %TIP: check matlab documentation for automatically plotting fits and
    %original data in one graph
    plot(gauss_fit, Field(:,i), Integral_flat(:,i))
end

% Give your figure a title and name axis!
title('Gauss Fit of the Integrates Signal Data')
xlabel('Frequency in GHz')
ylabel('Flattened Lock-in Amplitude')

% add a legend
legend(leg_cell{:} ,'Location','southeast')

hold off

%% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);
