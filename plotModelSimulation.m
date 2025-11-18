%%adjusted by Kyle Adams, originally Mahya Aghaee

function plotModelSimulation
    % ###Step 1
    % define the colors of the state variables
    M2_color  = [217/255, 196/255,  255/255]; % purple
    F_color  = [217/255, 217/255, 217/255]; % light gray
    B_color = [239/255, 157/255, 192/255]; % pink
    Tc_color = [191/255, 224/255, 179/255]; % green
    Tr_color = [228/255, 191/255, 174/255]; % orange
    line_width = 4;

    %load the parameter names and values
    p = setParameters();

    % ###Step 2
    % set simulation timespan and load the initial conditions
    t0 = 0; tfinal = 300; % initial and final simulation times in days
    IC = setInitialConditions(); % get the initial values of the model
    IC = struct2cell(IC); IC = [IC{:}];
    
    % simulate the model 
    [Tf,Xf] = ode45(@(t, y)odefun(t, y, p),...
        [t0 tfinal], IC);
    
    % ###Step 4
    % store the solutions for each variable for plotting
    M2F   = Xf(:,1);
    FF   = Xf(:,2);
    BF  = Xf(:,3);
    TcF  = Xf(:,4);
    TrF  = Xf(:,5);
   
    % ###Step 5
    %% Create plots of the variables in a 2x3 grid %%
    % each plot has the same aesthetic and similar labelings
    
    tiledlayout(2,3)

    % Top left plot
    nexttile
    plot(Tf, M2F, 'Color', M2_color, 'LineWidth',line_width)
    xlim([0 tfinal])
    xlabel('Time (days)')
    ylabel('M2 (cells/mm ^3)')
    title('M2 Macrophages')
    ax = gca;
    formatAxes(ax);

    % Top middle plot
    nexttile
    plot(Tf,FF,'Color', F_color,'LineWidth', line_width)
    title('Cell Populations')
    xlim([0 tfinal]) 
    ylim([0 2*p.KF])
    xlabel('Time (days)')
    ylabel('F (cells/mm^3)')
    title('Cancer-Associated Fibroblasts')
    ax = gca;
    formatAxes(ax);

    % Top right plot
    nexttile
    plot(Tf,BF, 'Color', B_color, 'LineWidth', line_width)
    xlim([0 tfinal])
    xlabel('Time (days)')
    ylabel('B (mm^3)')
    title('Breast Cancer Tumor Cells')
    ax = gca;
    formatAxes(ax);

    % Bottom left plot
    nexttile
    plot(Tf,TcF, 'Color', Tc_color,'LineWidth',line_width)
    xlim([0 tfinal])
    ylim([0 2*p.KC])
    xlabel('Time (days)')
    ylabel('T_{C} (cells/ mm ^3)')
    title('Cytotoxic T cells (T_{C})')
    ax = gca;
    formatAxes(ax);

    % Bottom middle plot
    nexttile
    plot(Tf,TrF,'Color', Tr_color, 'LineWidth',line_width)
    xlim([0 tfinal])
    xlabel('Time (days)')
    ylabel('T_{R} (cells/mm ^3)')
    title('Regulatory T cells (T_{R})')
    ax = gca;
    formatAxes(ax);
  
    %helper function for formatting axes
    function formatAxes(ax)
        ax.Title.FontSize = 15;
        ax.XAxis.FontSize = 14;
        ax.YAxis.FontSize = 14;
    end

end 
