% This code was originally written by Jaimit Parikh, and was edited by 
% Kyle Adams to compare QOI distributions when some parameters are fixed.

random_seed = 1;
rng(random_seed);  %Setting seed 

% ###Step 1
%set up bounds and distributions for Sobol sampling
lower_percentage = 0.5;
upper_percentage = 1.5;
base_samples = 250000;
param_dist = {'Uniform'};
p = setParameters();

% ###Step 2
%define parameter sets to compare QOI distributions
param_sets = {
    'All Parameters Varied', fieldnames(p)', ...
    'The 5 Most Influential Parameters Varied', {'pB', 'aFB', 'bFB', 'KB', 'a2B'}, ...
    'The Least 34 Influential Parameters Varied', {'aB2', 'bB2', 'aF2', 'bF2', 'g2', 'aC2', ...
                                            'bC2', 'd2', 'sF', 'KF', 'dF', 'b2B', 'dB',...
                                            'aCB', 'bCB', 'a2CB', 'b2CB', 'aBCB', 'bBCB', 'aRCB', 'bRCB', 'pC', 'KC', ...
                                            'a2C', 'b2C', 'aRC', 'bRC', 'dC', 'sR', 'a2R', 'b2R', 'aBR', 'bBR', 'dR'}};

num_param_sets = length(param_sets) / 2;
QOIs = cell(1, num_param_sets);
labels = cell(1, num_param_sets);

% Parameters in this list will have UB capped at 1 if nominal value > 2/3
inhibitoryParams = { ...
    'a2CB', ...
    'aBCB', ...
    'aRCB', ...
    'aRC', ... 
};

%perform sensitivity analysis setup for each parameter set
for i = 1:num_param_sets
    set_name = param_sets{2*i - 1};
    varying_params = param_sets{2*i};
    labels{i} = set_name;

    %using the parameter names from param_sets, extract all
    %parameter info from parameters.m
    p_subset = struct();
    for j = 1:length(varying_params)
        field = varying_params{j};
        if isfield(p, field)
            p_subset.(field) = p.(field);
        end
    end

    param_names = fieldnames(p_subset);
    num_params = length(param_names);
    lowBounds = zeros(1, num_params);
    upBounds = zeros(1, num_params);

    for j = 1:num_params
        param = param_names{j};
        lowBounds(j) = p_subset.(param) * lower_percentage;
        upBounds(j) = p_subset.(param) * upper_percentage;

                % override upper bound if parameter is an inhibitory parameter with a
    % whose upper bound is bigger than 1
        if ismember(param, inhibitoryParams) && p.(param)*1.5 > 1
        upBounds(j) = 1;
        end
    end



    parsObj.name = param_names';
    parsObj.lb = num2cell(repmat(-inf, 1, length(parsObj.name)));
    parsObj.ub = num2cell(inf(1, length(parsObj.name)));
    parsObj.dist = repmat(param_dist, 1, num_params);
    parsObj.N = base_samples;
    parsObj.parameters = arrayfun(@(i) {'lower', lowBounds(i), 'upper', upBounds(i)}, ...
                                  1:num_params, 'UniformOutput', false);

    %get varied parameter value sets by running getSamplesSobol
    samples = generateSobolSamples(parsObj, false);
    samples = samples(1:2*base_samples, :);  % first 2N rows = A and B, do not want ABi

    %simulate the QOI
    QOI = zeros(1, length(samples));
    pN = cell(1,length(samples));
    parsName = parsObj.name;
    parfor ii = 1:length(samples)
        pN{ii} = updatePars(p, parsName, samples(ii, :));
        QOI(ii) = calculateQOI(pN{ii});
    end
    QOIs{i} = QOI;
end
%take equal-sized subsets of bigger QOI distributions to compare fairly
smallest_num_model_evals = min(cellfun(@length, QOIs));

% ###Step 3
%plot histogram comparisons of QOI distributions
figure;
hold on;
colors = {'black', '#FF6C00', 'blue'}; % all params, top params, bottom params
for i = 1:num_param_sets
    histogram(generateRandomSubset(QOIs{i}, smallest_num_model_evals, random_seed), ...
        'EdgeColor', colors{i}, ...
        'DisplayStyle', 'stairs', ...
        'LineWidth', 3.5);
end
legend(labels, 'FontSize', 20, 'FontName', 'serif', 'Location', 'northeast', 'FontWeight', 'bold');
xlabel('QOI Value', 'FontSize', 22, 'FontName', 'serif', 'FontWeight', 'bold');
ylabel('Frequency', 'FontSize', 22, 'FontName', 'serif', 'FontWeight', 'bold');
title('Histogram Comparison of QOI Distributions', 'FontSize', 28, 'FontName', 'serif', 'FontWeight', 'bold');
xlim([0 4e5]);

truncate = true;
if truncate == true
    ylim([0 3.15e4])
    xlim([0 2.5e5])
end

hold off;

%update parameters function
function p = updatePars(p, parsName, parsValue)
    for ii = 1:length(parsName)
        p.(parsName{ii}) = parsValue(ii);
    end
end
