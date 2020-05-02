clear dev;
fc = 95e6;
fs = 5e6;

dev = limeSDR();
dev.rx0.frequency = fc;
dev.rx0.samplerate = fs;
dev.rx0.bandwidth = fs;
dev.rx0.enable;
dev.start();

%% Loop capture
capture_duration = 10e-3;
DISP_TIME_SEC = 2;
figure;
xlabel('Frequency (MHz)');
title('Absolute value');
N = fs * capture_duration;
dt = 1 / fs;
df = 1 / (N * dt);
f = (fc - (N * df / 2) + (0:N-1) * df) / 1e6;
tt = 0;
while tt < DISP_TIME_SEC
    samples = dev.receive(N, 0);
    Yf = fft(samples);
    Yfs = fftshift(Yf);
    plot(f, abs(Yfs));
    drawnow;
    tt = tt + capture_duration;
end

%% Single capture
capture_duration = 2;
disp("Starting capture");
samples = dev.receive(fs * capture_duration, 0);
disp("Ending capture");

N = length(samples);
Yf = fft(samples);
Yfs = fftshift(Yf);
dt = 1 / fs;
df = 1 / (N * dt);
f = (fc - (N * df / 2) + (0:N-1) * df) / 1e6;
figure;
plot(f, abs(Yfs));
xlabel('Frequency (MHz)');
title('Absolute value');

% Station at 93.6 MHz

%% Stop
dev.stop();