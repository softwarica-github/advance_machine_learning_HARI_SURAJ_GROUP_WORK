% PART 1
% Create a fuzzy inference system
fis = mamfis('Name', 'Intelligence Flat');
 
% Add input variables
fis = addInput(fis, [0 100],'Name', 'temperature');
fis = addInput(fis,[0 100], 'Name', 'humidity');
fis = addInput(fis,[0 1], 'Name', 'motion');
fis = addInput(fis,[0 100], 'Name', 'person_sound');
 
% Add output variables
fis = addOutput(fis,[0 100],'Name', 'heater_power');
fis = addOutput(fis,[0 1],'Name', 'lightning');
fis = addOutput(fis,[0 100],'Name', 'speakerVolume');
 
% Set the parameters for trimf membership functions
fis = addMF(fis, 'temperature', 'trimf', [0 5 10], 'Name', 'cold');
fis = addMF(fis, 'temperature', 'trimf', [25 25 35], 'Name', 'comfortable');
fis = addMF(fis, 'temperature', 'trimf', [40 45 50], 'Name', 'hot');

fis = addMF(fis, 'humidity', 'trimf', [0 0 10], 'Name', 'dry');
fis = addMF(fis, 'humidity', 'trimf', [20 50 80], 'Name', 'normal');
fis = addMF(fis, 'humidity', 'trimf', [70 100 100], 'Name', 'moist');

fis = addMF(fis, 'motion', 'trimf', [0 0 0], 'Name', 'no');
fis = addMF(fis, 'motion', 'trimf', [1 1 1], 'Name', 'yes');
 

fis = addMF(fis, 'person_sound', 'trimf', [0 5 10], 'Name', 'low');
fis = addMF(fis, 'person_sound', 'trimf', [20 25 30], 'Name', 'normal');
fis = addMF(fis, 'person_sound', 'trimf', [70 100 110], 'Name', 'high');


 
fis = addMF(fis, 'heater_power', 'trimf', [0 5 10], 'Name', 'low');
fis = addMF(fis, 'heater_power', 'trimf', [20 50 50], 'Name', 'medium');
fis = addMF(fis, 'heater_power', 'trimf', [60 100 100], 'Name', 'high');
 
fis = addMF(fis, 'lightning', 'trimf', [0 0 0], 'Name', 'TurnOff');
fis = addMF(fis, 'lightning', 'trimf', [1 1 1], 'Name', 'TurnOn');

fis = addMF(fis, 'speakerVolume', 'trimf', [0 5 10], 'Name', 'low');
fis = addMF(fis, 'speakerVolume', 'trimf', [20 25 30], 'Name', 'normal');
fis = addMF(fis, 'speakerVolume', 'trimf', [70 100 110], 'Name', 'high');
 
% Add rules
fis = addRule(fis, 'temperature==cold & humidity==moist => heater_power==high');
fis = addRule(fis, 'temperature==hot & humidity==dry=> heater_power==low');

fis = addRule(fis, 'motion==yes => lightning==TurnOn');
fis = addRule(fis, 'motion==no => lightning==TurnOff');
 
fis = addRule(fis, 'person_sound==low => speakerVolume==low');
fis = addRule(fis, 'person_sound==normal => speakerVolume==normal');
fis = addRule(fis, 'person_sound==high => speakerVolume==high');

 
% Set inputs (replace these values with actual sensor readings)
inputValues = [10,10,1,80]


% Evaluate the fuzzy inference system
outputValues = evalfis(fis, inputValues);
disp(outputValues);
 
% Display results
disp(['Heater Power: ', num2str(outputValues(1))]);
disp(['Lightning: ', num2str(outputValues(2))]);
disp(['speakerVolume: ', num2str(outputValues(3))]);
 
% Display triggered rules based on output membership values
[~, heaterPowerRuleIndex] = max(outputValues(1));
[~, LightiningRuleIndex] = max(outputValues(2));
[~, speakerVolumeRuleIndex] = max(outputValues(3));
 
disp(['Triggered Heater Power Rule: ', num2str(heaterPowerRuleIndex)]);
disp(['Triggered Lightining Rule: ', num2str(LightiningRuleIndex)]);
disp(['Triggered Speaker Rule: ', num2str(speakerVolumeRuleIndex)]);
 
% Plot input membership functions
figure;
subplot(4, 1, 1);
plotmf(fis, 'input', 1);
title('Membership Functions for Temperature');
set(gca, 'XTick', [0 10 20]); % Adjust the x-axis ticks for better visibility
 
subplot(4, 1, 2);
plotmf(fis, 'input', 2);
title('Membership Functions for Humidity');
set(gca, 'XTick', [0 60 70]); % Adjust the x-axis ticks for better visibility
 
 
subplot(4, 1, 3);
plotmf(fis, 'input', 3);
title('Membership Functions for Motion');
set(gca, 'XTick', [0 120 130]); % Adjust the x-axis ticks for better visibility
 

subplot(4, 1, 4);
plotmf(fis, 'input', 4);
title('Membership Functions for person sound');
set(gca, 'XTick', [0 170 180]); % Adjust the x-axis ticks for better visibility
 
 
 
 
% Set the renderer property to 'painters'
 set(gcf, 'Renderer', 'painters');
% Pause and wait for user interaction
 uiwait(gcf);
 
% Plot output membership functions
figure;
subplot(3, 1, 1);
plotmf(fis, 'output', 1);
title('Output Membership Functions for Heater Power');
 
subplot(3, 1, 2);
plotmf(fis, 'output', 2);
title('Output Membership Functions for Lightning');

subplot(3, 1, 3);
plotmf(fis, 'output', 3);
title('Output Membership Functions for speaker volume');
 
% Set the renderer property to 'painters'
set(gcf, 'Renderer', 'painters');
 
% Pause to keep figures open
uiwait(gcf);% Create a fuzzy inference system
 
figure;
plotfis(fis);
title('Defuzzification Process');
 
% Set the renderer property to 'painters'
set(gcf, 'Renderer', 'painters');
 
% Pause to keep figures open
uiwait(gcf);% Create a fuzzy inference system
 
 
showrule(fis)

ruleview(fis)

% PART 2
% Define the objective function to maximize speakerVolume
objectiveFunction = @(inputValues) -evalfis(fis, inputValues).Outputs(3).mfValues(3);

% Genetic algorithm options
options = optimoptions('ga', 'PopulationSize', 50, 'MaxGenerations', 100);

% Constraints on input values (if any)
lb = [0, 0, 0, 0];  % Lower bounds for temperature, humidity, motion, person_sound
ub = [100, 100, 1, 100];  % Upper bounds for temperature, humidity, motion, person_sound

% Run genetic algorithm
[inputOptimal, objectiveOptimal] = ga(objectiveFunction, 4, [], [], [], [], lb, ub, [], options);

% Display results
disp(['Optimal Input Values: ', num2str(inputOptimal)]);
disp(['Optimal Speaker Volume: ', num2str(-objectiveOptimal)]);

% Evaluate fuzzy inference system with optimal input values
outputOptimal = evalfis(fis, inputOptimal);
disp(['Optimal Heater Power: ', num2str(outputOptimal.Outputs(1).mfValues(3))]);
disp(['Optimal Lightning: ', num2str(outputOptimal.Outputs(2).mfValues(3))]);
disp(['Optimal Speaker Volume: ', num2str(outputOptimal.Outputs(3).mfValues(3))]);


% PART 3 compare between particle swarn and pattern search algorith of
% CEC'2005 functions

% particleswarm
% Define the objective function to maximize speakerVolume
objectiveFunction = @(inputValues) -evalfis(fis, inputValues).Outputs(3).mfValues(3);

% Particle Swarm Optimization options
options = optimoptions('particleswarm', 'SwarmSize', 50, 'MaxIterations', 100);

% Constraints on input values (if any)
lb = [0, 0, 0, 0];  % Lower bounds for temperature, humidity, motion, person_sound
ub = [100, 100, 1, 100];  % Upper bounds for temperature, humidity, motion, person_sound

% Run Particle Swarm Optimization
[inputOptimal, objectiveOptimal] = particleswarm(objectiveFunction, 4, lb, ub, options);

% Display results
disp(['Optimal Input Values: ', num2str(inputOptimal)]);
disp(['Optimal Speaker Volume: ', num2str(-objectiveOptimal)]);

% Evaluate fuzzy inference system with optimal input values
outputOptimal = evalfis(fis, inputOptimal);
disp(['Optimal Heater Power: ', num2str(outputOptimal.Outputs(1).mfValues(3))]);
disp(['Optimal Lightning: ', num2str(outputOptimal.Outputs(2).mfValues(3))]);
disp(['Optimal Speaker Volume: ', num2str(outputOptimal.Outputs(3).mfValues(3))]);


% pattern search
% Define the objective function to maximize speakerVolume
objectiveFunction = @(inputValues) -evalfis(fis, inputValues).Outputs(3).mfValues(3);

% Pattern Search options
options = optimoptions('patternsearch', 'InitialMeshSize', 10, 'MaxIterations', 100);

% Constraints on input values (if any)
lb = [0, 0, 0, 0];  % Lower bounds for temperature, humidity, motion, person_sound
ub = [100, 100, 1, 100];  % Upper bounds for temperature, humidity, motion, person_sound

% Run pattern search
inputOptimal = patternsearch(objectiveFunction, zeros(4,1), [], [], [], [], lb, ub, [], options);
objectiveOptimal = -objectiveFunction(inputOptimal);

% Display results
disp(['Optimal Input Values: ', num2str(inputOptimal)]);
disp(['Optimal Speaker Volume: ', num2str(objectiveOptimal)]);

% Evaluate fuzzy inference system with optimal input values
outputOptimal = evalfis(fis, inputOptimal);
disp(['Optimal Heater Power: ', num2str(outputOptimal.Outputs(1).mfValues(3))]);
disp(['Optimal Lightning: ', num2str(outputOptimal.Outputs(2).mfValues(3))]);
disp(['Optimal Speaker Volume: ', num2str(outputOptimal.Outputs(3).mfValues(3))]);


