
%get parameters from parameters.m and set seed for reproducibility
random_seed = 1; %this should be same seed as in sobolMain
rng(random_seed);


lower_percentage = 0.5;
upper_percentage = 1.5;
base_samples = 10000;
param_dist = {'Uniform'};
p = setParameters();
param_names = fieldnames(p);
num_params = length(param_names);
lowBounds = zeros(1, num_params);
upBounds = zeros(1, num_params);

% Parameters in this list will have UB capped at 1 if nominal value > 2/3
inhibitoryParams = { ...
    'a2CB', ...
    'aBCB', ...
    'aRCB', ...
    'aRC', ... 
};



%perform same setup as sobolMain sensitivity analysis for each parameter set
    for j = 1:num_params
        param = param_names{j};
        lowBounds(j) = p.(param) * lower_percentage;
        upBounds(j) = p.(param) * upper_percentage;

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


topNames = {'pB', 'aFB', 'bFB', 'KB', 'a2B'}; % put in which parameters you want plotted (we used top 6 influential)

paramLabels = {'p_B', '\alpha_{FB}', '\beta_{FB}', 'KB', '\alpha_{2B}'};
%paramColors = {[ 1, 0, 0], [1, 135/255, 0], };


plotInteractionScatters(pN, QOI, topNames, paramLabels);

function plotInteractionScatters(pN, QOI, topNames, paramLabels)%, paramColors)
tiledlayout(2, 5, 'TileSpacing', 'compact', 'Padding', 'compact');

N = numel(pN); % number of model evaluations
numTop = numel(topNames); % number of top influential parameters

topVals = zeros(N, numTop); % initializing matrix to store values of top parameters (values from sensitivity analysis)
for i = 1:numTop
    field = topNames{i};
    topVals(:,i) = cellfun(@(s) s.(field), pN); % for each parameter, we are getting all of its perturbed values from each parameter set
end

combs = nchoosek(1:numTop, 2); % getting all possible index pairs

for i = 1:size(combs, 1)
    idx1 = combs(i, 1); % gets index of first member of parameter pair
    idx2 = combs(i, 2); % gets index of second member of parameter pair

    x = topVals(:, idx1); % gets values of parameter 1
    y = topVals(:, idx2); % gets values of parameter 2
    c = QOI; 

    nexttile;
    scatter(x, y, 10, c, 'filled', 'MarkerFaceAlpha', 0.5, 'MarkerEdgeAlpha', 0.5);
    clim([min(QOI) max(QOI)])
    xlabel(paramLabels{idx1}, 'FontWeight', 'bold', 'FontSize', 14);
    xRange = max(x) - min(x);
    xpadding = 0.01 * xRange; % used to get rid of weird whitespace in plots
    xlim([min(x) - xpadding, max(x) + xpadding]); % gives a little extra buffer room
    ylabel(paramLabels{idx2}, 'FontWeight', 'bold', 'FontSize', 14);
    yRange = max(y) - min(y); % used to get rid of weird whitespace in plots
    ypadding = 0.01 * yRange;  % gives a little extra buffer room
    ylim([min(y) - ypadding, max(y) + ypadding]);
    colormap(TNBCColorMap);
    set(gca, 'Box', 'on');
end

ax = gca;
cb = colorbar(ax, 'eastoutside');
cb.Label.String = 'TNBC Tumor Size';
cb.Label.FontWeight = 'bold';
cb.Label.FontSize = 14; %color bar label's font size
cb.Position = [0.96, 0.3, 0.01, 0.25]; % hardcoded based on what the plot looks like
    % [x start, y start, width, height]
end

%update parameters function
function p = updatePars(p, parsName, parsValue)
    for ii = 1:length(parsName)
        p.(parsName{ii}) = parsValue(ii);
    end
end
