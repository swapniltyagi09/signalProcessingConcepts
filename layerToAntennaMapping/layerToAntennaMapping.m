clc;
clear;
close all;

numLayers = 2;  %Number of transmission layers
numAntennas = 4; %Number of physical Antennas
numSymbols = 10; %Number of symbols per layers

layers = (randn(numLayers,numSymbols) + 1j * randn(numLayers,numSymbols)) / sqrt(2);

% Precoding matrix selection (example: 4x2 matrix for 2 layers & 4 antennas)
% Precoding follows 3GPP TS 38.211 Section 6.3.1.3
if numLayers == 1 && numAntennas == 2
    P = 1/sqrt(2) * [1; 1]; % Alamouti scheme for 2 antennas
elseif numLayers == 2 && numAntennas == 4
    P = 1/2 * [1  1;
               1 -1;
               1  1;
               1 -1];  % Precoding matrix for 2 layers and 4 antennas
elseif numLayers == 4 && numAntennas == 4
    P = 1/2 * [1  1  1  1;
               1 -1  1 -1;
               1  1 -1 -1;
               1 -1 -1  1]; % Precoding for full-rank 4x4 MIMO
else
    error('Unsupported layer/antenna configuration.');
endif

% Apply precoding to map layers to antennas
mapped_antennas = P * layers;

% Display results
disp('Layer symbols:');
disp(layers);

disp('Mapped antenna symbols:');
disp(mapped_antennas);

% Plot the original layers and the mapped antenna signals
figure;
subplot(2,1,1);
plot(real(layers(1,:)), imag(layers(1,:)), 'bo');
title('Original Layer 1 Symbols');
xlabel('Real'); ylabel('Imaginary'); grid on;

subplot(2,1,2);
plot(real(mapped_antennas(1,:)), imag(mapped_antennas(1,:)), 'ro');
title('Mapped Antenna 1 Symbols');
xlabel('Real'); ylabel('Imaginary'); grid on;



a=1;


