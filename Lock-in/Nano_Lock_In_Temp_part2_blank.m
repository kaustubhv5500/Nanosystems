%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nanosystems 
% Labcourse Data post processing template
% Lock-In FMR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Part 2

% Tasks:  - Understand Code
%         - Integrate data to create FMR peaks
%         - Remove linear component from Integral
%         - Visualize results
%         - TIP: Use the Matlab curve fitting tool to interactivly fit
%                (APPS -> Curve Fitting)
%         - TIP: Check Matlab documentation https://de.mathworks.com/help/matlab/index.html

%% Data handling
clear                               % clear workspace
filename = 'D:\Nanosystems\Locked_in_IP_part1.mat';                      % input name of workspace with your data
% filename = 'D:\Nanosystems\Locked_in_OOP_part1.mat';
load(filename);                     % Load data in Workspace

label = 'part2';                    % name for your new workspace
save_directory = 'D:\Nanosystems\';                % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% Plot
% Create a plot
figure
subplot(2,1,1)

grid on 
hold on 

%% This section is optional and might help with better peak shapes
% % Uncomment if wanted/needed: Select and press Ctrl + T (Comment = Ctrl + R)
% %Idea: Define data point window around peaks for better integration
% %afterwards
% 
% % Window size in data points
% window = ;
% %Rename data vectors
% Field_tot = Field;
% Signal_tot = Signal;
% %Reinitialze empty vectors
% Field = [];
% Signal = [];
% 
% %Iterate over all frequencies
% for i = :
%    %Find peaks (approximatly) in total data set
%    %Take derivative 
%    dH(:,i) = ;
%    %Find index of maximum derivative
%    H_res_ind(i,1) = ;
%    
%    %Cut data points from total field and signal around resonace field
%    Field(:,i) = ;     
%    Signal(:,i) = ;
% end

%% Iterate over all frequencies and integrate and flip data (easier fitting)
% Iterate over all frequencies
for i = 1:length(Frequency)
    % Integrate and flip
    Integral(:,i) = -1 * cumtrapz(Signal(:,i));    
end

% Plot integrals
plot(Field, Integral)

% Give your figure a title and name axis!
title('Integrated and Flipped Signal')
xlabel('Frequency in GHz')
ylabel('Lock-in Amplitude')

% add a legend
legend(leg_cell{:},'Location','southeast')

hold off

%% Flatten the integral for proper peak fit
% TIP1: If curve still doesn't show a good peak, figure out why and try differnet techniques
% TIP2: good peak fits are only possible if the 'baseline' of the
% integrated signal is horizontal. Thus: remove the linear portion

subplot(2,1,2)

grid on 
hold on 

% Iterate over all frequencies
for i = 1:length(Frequency)
    
%     fit a linear curve and remove it from integral
    lin = fittype("slope*x + yIntercept");
    [lin_fit, gof] = fit(Field(:,i), Integral(:,i), lin);
    
%     Extract slope and offset paramters from linear fit
%     TIP: Check Matlab documentation on fits
    m(i) = lin_fit.slope;
    t(i) = lin_fit.yIntercept; 
    
%     Subtract linear curve from integral
    Integral_flat(:,i) = Integral(:,i) - lin_fit.slope .* Field(:,i) - lin_fit.yIntercept;
    
%     Optional: Set the lowest point to zero
%     Integral_flat(:,i) = normalize(Integral_flat(:,i));
%     [M, index] = min(Integral_flat(:,i));
%     Integral_flat(index, i) = 0;

end

%% Plot edited data
plot(Field, Integral_flat)

%Give your figure a title and name axis!
title('Corrected Integrated Data')
xlabel('Magnetic Field in mT')
ylabel('Flattened Lock-in Amplitude')

% add a legend
legend(leg_cell{:},'Location','southeast')

hold off

%% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);
