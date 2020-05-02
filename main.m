clear dev;
fc = 740e6;
fs = 30.72e6;
dt = 1 / fs;
duration = 100e-3;

dev = limeSDR();
dev.rx0.frequency = fs;
dev.rx0.samplerate = fs;
dev.rx0.enable;
dev.start();

disp("Starting capture");
samples = dev.receive(fs * duration, 0);
disp("Ending capture");
dev.stop();

N = length(samples);
Yf = fft(samples);
Yfs = circshift(Yf, N/2);
df = 1 / (N * dt);
f = (fc - (N * df / 2) + (0:N-1) * df) / 1e6;
figure;
plot(f, abs(Yfs));
xlabel('Frequency (MHz)');
title('Absolute value');