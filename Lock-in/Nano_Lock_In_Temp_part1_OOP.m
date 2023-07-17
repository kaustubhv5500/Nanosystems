%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nanosystems  
% Labcourse Data post processing template
% Lock-In FMR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Part 1

% Tasks:  - Understand Code
%         - Rename and rescale data
%         - Visualize the raw and processed data
%         - TIP: You can run indiviual parts of the script
%           by selecting the code and pressing F9 
%         - TIP: Check Matlab documentation https://de.mathworks.com/help/matlab/index.html

%% Data handling
clc
clear                               % clear workspace
filename = 'Locked_in_OOP.mat';                      % input name of workspace with your data

load(filename);                     % Load data in Workspace

label = 'part1';                    % name for your new workspace
save_directory = 'D:\Nanosystems\';                % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% build magnetic field and Lock-In signal Matrix from individual voltage data
% TIP1: smoothing your data might help later for creating better fits
% TIP2: the vector "volts" contains both the hall voltage and the lock-in
% signal information. The vector "time" contains the measurement time steps
% TIP3: Keep in mind that you have to process IP and OOP data with the same
% matlab scripts! 

Field(:,1) =  volts2000(:,1);
Field(:,2) =  volts2400(:,1);
Field(:,3) =  volts2800(:,1);
Field(:,4) =  volts3200(:,1);
Field(:,5) =  volts3600(:,1);
Field(:,6) =  volts4000(:,1);
Field(:,7) =  volts4400(:,1);
Field(:,8) =  volts4700(:,1);
Field(:,9) =  volts5200(:,1);
Field(:,10) = volts5500(:,1);

Signal(:,1) =  volts2000(:,2);
Signal(:,2) =  volts2400(:,2);
Signal(:,3) =  volts2800(:,2);
Signal(:,4) =  volts3200(:,2);
Signal(:,5) =  volts3600(:,2);
Signal(:,6) =  volts4000(:,2);
Signal(:,7) =  volts4400(:,2);
Signal(:,8) =  volts4700(:,2);
Signal(:,9) =  volts5200(:,2);
Signal(:,10) = volts5500(:,2);


% Define Frequency vector in GHz
Frequency = [2 2.4 2.8 3.2 3.6 4 4.4 4.7 5.2 5.5];
% Rescale field in mT - which conversion rule did we use during the lab?
Field = Field * 100e-3;

freq = linspace(2e9, 5.5e9, length(Signal));

%% Plot the raw data 
% Create a plot
figure

grid on 
hold on 

subplot(2,1,1);
plot(time, Signal);

% Give your figure a title and name axis!
title('Plot of Raw Data')
xlabel('Time')
ylabel('Lock-in Signal Amplitude')
grid on;

subplot(2,1,2);
plot(time,Field);
grid on;

% Give your figure a title and name axis!
xlabel('Time')
ylabel('Hall Voltage in V')

% add a legend
for i=1:length(Frequency)
    leg_cell{i}=[ num2str(Frequency(i)) 'GHz'];
end

% add a legend
legend(leg_cell{:},'Location','southeast')

%% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);
