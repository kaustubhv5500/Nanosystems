%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Nanosystems
% Labcourse Data post processing template
% VNA
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Part 1

% Tasks:  - Understand Code
%         - Rename and rescale data
%         - Extract FMR peaks from your raw data
%         - Visualize the raw and processed data
%         - Tip: You can run indiviual parts of the script
%           by selecting the code and pressing F9 
%         - TIP: Check Matlab documentation https://de.mathworks.com/help/matlab/index.html

%% Data handling
%Hint: Make sure to name your workspace uniquely.
%Hint2: Keep in mind that you have to process IP and OOP data with the same
%matlab scripts! 

clc;
clear;                               % clear workspace
filename = 'VNA_IP_27_06.mat';                  % input name of workspace with your data
% filename = 'VNA_OOP_27_06.mat';

load(filename);                     % Load data in Workspace

label = 'part1';                    % name for your new workspace - should contain configuration!
save_directory = 'D:\Nanosystems\';                % input filepath where you want to save your data to (For example C:\Users\name\Desktop\)

%% Plot the raw data

% rescale frequency vector to GHz
Fvector = Fvector./1e9 ;

% add a figure
figure

%Add a subplot
subplot(2,2,1)
% plot raw data (e.g. the absoulte value of (all) S-parameters)
plot(Fvector, abs(S21))

% Add a legend
for i=1:length(Bvector)
    leg_cell{i}=[ num2str(Bvector(i)) 'mT'];
end
legend(leg_cell{:},'Location','northeast')

% Add a title and name figure axis
title('S21 Parameters')
xlabel('Frequency (GHz)')
ylabel('Transmitted Power')

%% Normalization with reference measurement

% S-parameter Normalization with reference measurement
dS = S21./S21_ref; % divide (instead of subtract)  
dS_real = real(dS); % extract the real part
dS_imag = imag(dS); % extract the imaginary part

% plot data after Normalization 
subplot(2,2,2)

plot(Fvector, abs(dS))

title('Normalised S21 Parameters')
xlabel('Frequency (GHz)')
ylabel('Transmitted Power')

% plot the real part of your data
subplot(2,2,3)
plot(Fvector, dS_real)

title('Real Part of Normalised S21 Parameters')
xlabel('Frequency (GHz)')
ylabel('Real Transmitted Power')

% plot the imaginary part of your data
subplot(2,2,4)
plot(Fvector, dS_imag)

title('Imaginary Part of Normalised S21 Parameters')
xlabel('Frequency (GHz)')
ylabel('Imaginary Transmitted Power')

%% save results (complete workspace) to desired location
mkdir(save_directory);
measurefile = [filename(1:(end-4)) '_' label '.mat'];
save([save_directory measurefile]);
