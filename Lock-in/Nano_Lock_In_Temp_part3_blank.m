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
filename = '';                      % input name of workspace with your data

load(filename);                     % Load data in Workspace

label = 'part3';                    % name for your new workspace
save_directory = '';                % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% Fit a gauss function to each of the peaks in the flattened (and maybe windowed) data 
%Create a plot
figure

grid on 
hold on 

 
%Iterate over all frequencies
for i = :
    %fit a gaussian function to edited data
    GAUSS =  fittype(); 
    [gauss_fit, gof] = fit( , ,GAUSS);
    
    %Extract fit parameters
    a(i) = ;
    b(i) = ;
    c(i) = ;  
    
    %Plot data and fitted curves in the same plot to evaluate your fits
    %TIP: check matlab documentation for automatically plotting fits and
    %original data in one graph
    plot()
end

%Give your figure a title and name axis!
title('')
xlabel('')
ylabel('')

% add a legend
legend( ,'Location','southeast')

hold off

%% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);
