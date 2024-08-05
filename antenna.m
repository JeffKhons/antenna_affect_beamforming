clear;
clc;
close all;

theta = [-90:90]/180*pi; % Angle range from -90 to 90 degrees in radians

% Mobile RF parameters
dBase = 0.08; % Base distance in meters
fBase = 2.5e9; % Frequency in Hz
cBase = 3e8; % Speed of light in m/s

% Acoustic parameters (commented out)
% dBase = 0.2; % Base distance in meters
% fBase = 1e3; % Frequency in Hz
% cBase = 343; % Speed of sound in m/s

% Use RF parameters
d = dBase;
f = fBase;
c = cBase;

lambda = c / f; % Wavelength
PhaseOffsetFraction = d * sin(theta) / lambda; % Phase offset fraction
Frames = 10; % Number of frames for animation
N = 3; % Number of antennas
MultFactor = 2; % Multiplication factor for antennas
SpaceFactor = 2; % Spacing factor for antennas
thetaOffset = 0; % Initial phase offset
thetaOffsetStep = pi / 2 / Frames; % Phase offset step for animation

figure(1)
clf
hold off

MaxAbs = 1 + MultFactor * N - 1; % Maximum absolute value for Y-axis scaling

BeamsAntennas = ones(N, 181); % Initialize beam array for antennas

% Loop over the number of antennas
for n = 1:N
    K = MultFactor * n; % Calculate the number of antennas in the array
    for k = 1:(K - 1)
        % Accumulate beam pattern for each antenna in the array
        BeamsAntennas(n, :) = BeamsAntennas(n, :) + exp(1i * k * d * sin(theta) / lambda * 2 * pi);
    end
    % Plot the beam pattern for each antenna array configuration
    subplot(2, N, n)
    semilogy(abs(BeamsAntennas(n, :)))
    title([num2str(K), ' Antennas, ', num2str(d), 'm Spacing'], 'fontsize', 16)
    set(gca, 'XLim', [1 181])
    set(gca, 'xtick', [1:30:181])
    set(gca, 'XTickLabel', {[-90:30:90]})
    set(gca, 'YLim', [1e-2 10^((1 - rem(log10(MaxAbs), 1)) + log10(MaxAbs))])
end

pause

BeamsSpacing = ones(N, 181); % Initialize beam array for spacing variations

% Loop over the number of antennas
for n = 1:N
    K = MultFactor * n; % Calculate the number of antennas in the array
    for k = 1:(K - 1)
        % Accumulate beam pattern with different spacing
        BeamsSpacing(n, :) = BeamsSpacing(n, :) + exp(1i * k * SpaceFactor * d * sin(theta) / lambda * 2 * pi);
    end
    % Plot the beam pattern with spacing variations
    subplot(2, N, n + N)
    semilogy(abs(BeamsSpacing(n, :)))
    title([num2str(K), ' Ant, d=', num2str(SpaceFactor * d), 'm, Phase=', num2str(thetaOffset / pi * 180), 'deg'], 'fontsize', 16)
    set(gca, 'XLim', [1 181])
    set(gca, 'xtick', [1:30:181])
    set(gca, 'XTickLabel', {[-90:30:90]})
    set(gca, 'YLim', [1e-2 10^((1 - rem(log10(MaxAbs), 1)) + log10(MaxAbs))])
end

pause

% Animation loop for different spacing factors and phase offsets
SpaceFactor = 0.5;
for Section = 1:2
    if Section == 2
        d = dBase;
        SpaceFactor = 1;
    end
    for movieupdate = 1:Frames
        if Section == 2
            thetaOffset = thetaOffset + thetaOffsetStep;
        end
        
        BeamsSpacing = ones(N, 181); % Reset beam spacing for each frame
        for n = 1:N
            K = MultFactor * n; % Calculate the number of antennas in the array
            for k = 1:(K - 1)
                % Accumulate beam pattern with updated spacing and phase offset
                BeamsSpacing(n, :) = BeamsSpacing(n, :) + exp(1i * k * SpaceFactor * d * sin((theta - thetaOffset)) / lambda * 2 * pi);
            end
            % Plot the beam pattern with updated spacing and phase offset
            subplot(2, N, n + N)
            semilogy(abs(BeamsSpacing(n, :)))
            title([num2str(K), ' Ant, d=', num2str(SpaceFactor * d), 'm, Phase=', num2str(thetaOffset / pi * 180), 'deg'], 'fontsize', 16)
            set(gca, 'XLim', [1 181])
            set(gca, 'xtick', [1:30:181])
            set(gca, 'XTickLabel', {[-90:30:90]})
            set(gca, 'YLim', [1e-2 10^((1 - rem(log10(MaxAbs), 1)) + log10(MaxAbs))])
        end
        
        pause
        
        if Section == 1
            SpaceFactor = SpaceFactor + 4 / Frames;
        end
    end
    pause
end
