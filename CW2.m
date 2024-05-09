%Henry Dunn
%egyhd3@notting.ac.uk




%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [10 MARKS]

clear
a = arduino;


writeDigitalPin(a,'D2',0)
% Number of blinks
numBlinks = 10;

% Blink the LED
for i = 1:numBlinks
    % Turn the LED on
    writeDigitalPin(a,"D2", 1);
    pause(0.5); % Wait for 0.5 seconds
    
    % Turn the LED off
    writeDigitalPin(a, "D2", 0);
    pause(0.5); % Wait for 0.5 seconds
end







%% %% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]
% Connect to Arduino
clear
a = arduino("COM3", "Uno");
fid = fopen('cabin_temperature.txt', 'wt');
% Define the analog pin to which the temperature sensor is connected
analogPin = 'A5';

% Define the duration of data collection (in seconds)
duration = 600; % 10 minutes

% Define the temperature coefficient and zero-degree voltage
TC = 10; % Temperature Coefficient (mV/°C)
V0_C = 500; % Zero-Degree Voltage (mV)

% Calculate the number of readings
numReadings = duration; % One reading per second for the entire duration

% Initialize arrays to store time and voltage data
timeData = (0:numReadings-1)'; % Time data in seconds
voltageData = zeros(numReadings, 1);

% Read temperature sensor data every second for 10 minutes
for i = 1:numReadings
    % Read voltage from the sensor
    voltage = readVoltage(a, 'A5');
    
    % Store voltage data
    voltageData(i) = voltage;
    
    % Pause for 1 second
    pause(1);
end

% Convert voltage data to temperature values
temperatureData = (voltageData - V0_C) / TC;

% Calculate statistical quantities
minTemperature = min(temperatureData);
maxTemperature = max(temperatureData);
avgTemperature = mean(temperatureData);

% Plot temperature over time
plot(timeData, temperatureData);
xlabel('Time (seconds)');
ylabel('Temperature (°C)');
title('Temperature vs. Time');
grid on;

% Print recorded data for the first second of each minute
disp('Recorded Cabin Data:');
for i = 1:numReadings
    if rem(i, 60) == 1
        minute = floor(timeData(i) / 60); % Convert seconds to minutes
        second = rem(timeData(i), 60); % Calculate remaining seconds
        output = sprintf(['Minute       %d         ' ...
    '\t     \t      ' ...
    '\nTemperature %.2f°C   \n'], minute, temperatureData(i));
disp(output);
fprintf(fid, output);
    end
end

fclose(fid);
%% %% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]
clear 

% Initialize Arduino connection
a = arduino("COM3", "Uno");

analogPin = 'A5';
% Define the temperature coefficient and zero-degree voltage
TC = 0.01; 
V0_C = 0.5; % Zero-Degree Voltage (mV)

% Define pin numbers for LEDs
greenPin = 'D8';
yellowPin = 'D4';
redPin = 'D7';
% Configure pin modes
configurePin(a, greenPin, 'DigitalOutput');
configurePin(a, yellowPin, 'DigitalOutput');
configurePin(a, redPin, 'DigitalOutput');



%

t_time = 0
i = 0

while true
    % Read temperature from Arduino
    
    voltage = readVoltage(a, 'A5');
   
    temperature = (voltage -V0_C ) / TC;
  
    
   


    

    plot(i, temperature, "x", "LineWidth",2);
    xlabel("Time (S)")
    ylabel("Temperature (C)")
    title("Live tempertaure vs time")
    grid on
    hold on
    axis([0 inf 0 50])
    pause(1-t_time);
    i=i+1;

    
    
    
    
    % Control LEDs based on temperature range
    if temperature >= 18 && temperature <= 24
        % Green LED constant light
        writeDigitalPin(a, greenPin, 1);
        writeDigitalPin(a, yellowPin, 0);
        writeDigitalPin(a, redPin, 0);
    elseif temperature < 18
        % Yellow LED blinking at 0.5 s intervals
        writeDigitalPin(a, greenPin, 0);
        blinkLED(a, yellowPin, 0.5);
        writeDigitalPin(a, redPin, 0);
    else
        % Red LED blinking at 0.25 s intervals
        writeDigitalPin(a, greenPin, 0);
        writeDigitalPin(a, yellowPin, 0);
        blinkLED(a, redPin, 0.25);
    end
     
   
end












% Function to blink LED at specified interval
function blinkLED(a, pin, interval)
    while true
        writeDigitalPin(a, pin, 1);
        pause(interval);
        writeDigitalPin(a, pin, 0);
        pause(interval);
    end
end



%%  TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [25 MARKS]






function temp_prediction


% Create arduino object
a = arduino();

% Start timer
time = 0;
Temp = 0;
TC = 0.01
while true
    pause(1)
    time = time+1;
    
    % Read voltage from temperature sensor
    v = readVoltage(a,'A5');
    % Convert voltage to temperature
    currentTemp = (v)/(TC); % Initial temperature
    
    % Calculate rate of change of temperature
    rateOfChange = (currentTemp - Temp) / 300;
    disp(rateOfChange)
    
    % Detect if time is a factor of 300s
    j = mod(time, 300);
    
    % Check if temperature is changing too quickly
    if abs(rateOfChange) > 4
        % If rate of change is more than 4°C/min, turn on red LED
        writeDigitalPin(a, 'D7', 1);
        writeDigitalPin(a, 'D4', 0);
        writeDigitalPin(a, 'D8', 0);
    elseif abs(rateOfChange)>= 4 && abs(rateOfChange) <= -4
        % If rate of change is between -4°C/min and 4°C/min, turn on yellow LED
        writeDigitalPin(a, 'D7', 0);
        writeDigitalPin(a, 'D4', 0);
        writeDigitalPin(a, 'D8', 1);
    else
        % If rate of change is less than -4°C/min, turn on green LED
        writeDigitalPin(a, 'D7', 0);
        writeDigitalPin(a, 'D4', 1);
        writeDigitalPin(a, 'D8', 0);
    end
    
    % Predict temperature in 5 minutes
    if j == 0
        % Calculate predicted temperature after 5 minutes
        tempPredict = currentTemp + (rateOfChange * 300);
        disp(currentTemp)
        disp(rateOfChange)
        % Display predicted temperature
        disp(['Predicted temperature in 5 minutes: ', num2str(tempPredict), ' °C']);
    end
end
%% Task 4  - REFLECTIVE STATEMENT [5 MARKS]

%The main challenges I face in the course work was learing the way around the arduino and breadboard and 
%all the new functions that come with them. Also having very limiting coding experince only starting this year
%my coding foundation is rather poor so the more complex questions proved rather difficult. 
%Coding the live graph caused me quite a few problems and went through a
%few ideas on how to do it as i coulndt seem to get the 'drawnow' function to work. I had to get round this
%by using the online reasources and the materials given to us on moodle. One limitation i came accross is when  i used
%the equation T = (V-V0_C)/TC it would come out as negative numbers as the
%zero voltage degrees being 500mv(0.5V) was bigger than the measured
%voltage. This made it hard to see if my code was working or not as i was
%not able to get accurate results. I dont know if this was a problem with
%the arduino kit that was given to me or just a problem with my code but this was a big limitation in this coursework as it was hard to see if my code was working or not.
%A strength in my code is that i kept it well commented so it was easy to
%read my code and follow the logic of it. This also made it easier to
%debug.
%For creating the flowcharts i used the website lucidcharts which made it
%very easy to make and very clear to read. 
%For future course work i would want to make more efficient code and this
%would happen by  increasing my experience and knowledge in matlab.  
% 

