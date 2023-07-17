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
filename = 'Locked_in_IP.mat';                      % input name of workspace with your data

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
Field(:,2) =  volts2450(:,1);
Field(:,3) =  volts2950(:,1);
Field(:,4) =  volts3400(:,1);
Field(:,5) =  volts3900(:,1);
Field(:,6) =  volts4350(:,1);
Field(:,7) =  volts4850(:,1);
Field(:,8) =  volts5300(:,1);
Field(:,9) =  volts5800(:,1);
Field(:,10) = volts6250(:,1);
Field(:,11) = volts6720(:,1);
Field(:,12) = volts7200(:,1);

Signal(:,1) =  volts2000(:,2);
Signal(:,2) =  volts2450(:,2);
Signal(:,3) =  volts2950(:,2);
Signal(:,4) =  volts3400(:,2);
Signal(:,5) =  volts3900(:,2);
Signal(:,6) =  volts4350(:,2);
Signal(:,7) =  volts4850(:,2);
Signal(:,8) =  volts5300(:,2);
Signal(:,9) =  volts5800(:,2);
Signal(:,10) = volts6250(:,2);
Signal(:,11) = volts6720(:,2);
Signal(:,12) = volts7200(:,2);


% Define Frequency vector in GHz
Frequency = [2 2.45 2.95 3.4 3.9 4.35 4.85 5.3 5.8 6.25 6.72 7.2];
% Rescale field in mT - which conversion rule did we use during the lab?
Field = Field * 100e-3;

freq = linspace(2e9, 7.2e9, length(Signal));

%% Plot the raw data 
% Create a plot
figure

grid on 
hold on 

% plot your measurement data
% TIP: figure out which x-vector is best suited to represent the actual measurement
% plot(Field*1e3, Signal);

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
legend(leg_cell{:},'Location','southeast')

hold off

%% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);
