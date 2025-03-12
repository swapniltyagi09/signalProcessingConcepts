% OFDM Modulation and demodulation
rng(100);
txDataLen = 1024 ;
qamOrder = 4; %QPSK
Nsc = 64; %Number of subcarriers
cpLength = 16;
SNRdB = 20;

txBits = randi([0,1],txDataLen,1); %Generate random data
txSymbols = reshape(txBits,log2(qamOrder),[]).'; %Group into log2(M) bits groups
txSymbols = bi2de(txSymbols); %Convert to decimal
txSymbols = qammod(txSymbols,qamOrder); %QAM modulation
scatterplot(txSymbols);
grid on;
axis([-1.5 1.5 -1.5 1.5]);

ofdmFrames = reshape(txSymbols,Nsc,[]); %Reshape into OFDM Grid , Nsc X NofdmSym
timeDomainSignal = ifft(ofdmFrames,Nsc); %Convert to time domain by taking IFFT

cpPart = timeDomainSignal(end-cpLength+1:end,:); %Obtain CP part
txSignal = [cpPart;timeDomainSignal]; % add cp

txSignalSerial = txSignal(:); %parrellel to serial conversion

rxSignalSerial = awgn(txSignalSerial,SNRdB,'measured'); %measures the power of txSignalSerial and then calculates the noise power so that the desired SNRdB is acheived

rxSignal = reshape(rxSignalSerial,Nsc + cpLength,[]); %reshape back to GRID FORM

rxSignal = rxSignal(cpLength+1:end,:); %remove CP

rxSymbols = fft(rxSignal,Nsc);  %Convert back to FRequency domain

rxBits = qamdemod(rxSymbols,qamOrder); %demodulate QAM symbols
rxBits = de2bi(rxBits,log2(qamOrder));
rxBits = rxBits(:); %Serialise rxBits

BER = sum(rxBits~=txBits)/txDataLen






