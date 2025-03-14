clc;
clear;
close all;

rng(100);
numSymbolsPerAntenna = 1000;
M = 16; %QAM order
SNRdB = 20;

symbolsTx1 = qammod(randi([0 M-1],numSymbolsPerAntenna,1),M);
symbolsTx2 = qammod(randi([0 M-1],numSymbolsPerAntenna,1),M);

% 2x2 MIMO channel , Rayleigh fading
H = (randn(2,2) + 1i * randn(2,2))/sqrt(2); %Random 2x2 channel

%Trasmnit signal through MIMO channel

symbolsRx1 = H(1,1) * symbolsTx1 + H(1,2) * symbolsTx2;
symbolsRx2 = H(1,2) * symbolsTx1 + H(2,2) * symbolsTx2;

% stack recieved signal

rxSignal = [symbolsRx1 , symbolsRx2].';

% Add reciever noise
rxSignalNoisy = awgn(rxSignal,SNRdB,"measured");

% ZF Equalisation in Time Domain

H_inv = pinv(H);
equalisedSignal = H_inv * rxSignalNoisy;

% DEmodulate Symbols
demodulatedSymbolsTx1 = qamdemod(equalisedSignal(1,:).',M);
demodulatedSymbolsTx2 = qamdemod(equalisedSignal(2,:).',M);

% Compute Symbol Error Rate

SER_tx1 = sum(demodulatedSymbolsTx1~=qamdemod(symbolsTx1,M))/numSymbolsPerAntenna;
SER_tx2 = sum(demodulatedSymbolsTx2~=qamdemod(symbolsTx2,M))/numSymbolsPerAntenna;

fprintf('Symbol Error Rate (SER) for Tx1 = %f\n', SER_tx1);
fprintf('Symbol Error Rate (SER) for Tx2 = %f\n', SER_tx2);

% Plot Constellations
figure;
subplot(1,2,1);
scatter(real(rxSignalNoisy(1,:)), imag(rxSignalNoisy(1,:)), 'r.');
title('Received Constellation at Rx1 (Before ZF)');
xlabel('In-Phase'); ylabel('Quadrature'); grid on;

subplot(1,2,2);
scatter(real(equalisedSignal(1,:)), imag(equalisedSignal(1,:)), 'b.');
title('Constellation After ZF Equalization (Tx1)');
xlabel('In-Phase'); ylabel('Quadrature'); grid on;

a=1;
