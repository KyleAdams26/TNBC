%function to convert enligh version of Moore convention of parameters names
%to Greek letters

function latexName = englishToGreek(paramName) %takes in paramName as char
% Examples:
%   dX    -> \delta_{X}
%   sX    -> \sigma_{X}
%   lX    -> \lambda_{X}
%   gX    -> \gamma_{X}
%   aABC  -> \alpha_{ABC}
%   bABC  -> \beta_{ABC}
% -------
% KF      -> K_F
% pB      -> p_B

    % Mapping from English prefix to Greek LaTeX command
    greekMap = containers.Map( ...
        {'d','s','l','g','a','b', 'K', 'p'}, ...
        {'\delta','\sigma','\lambda','\gamma','\alpha','\beta', 'K', 'p'} ...
    );

    % Extract prefix and subscript
    prefix    = paramName(1);
    subscript = paramName(2:end);

    if isempty(subscript)
        error('Parameter name must have at least one character after the prefix.');
    end

    if isKey(greekMap, prefix)
        greekSymbol = greekMap(prefix);
    else
        % Fallback: keep prefix as-is
        greekSymbol = prefix;
    end

    latexName = sprintf('%s_{%s}', greekSymbol, subscript);
end
