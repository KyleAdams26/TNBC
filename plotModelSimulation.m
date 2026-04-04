%%adjusted by Kyle Adams, originally Mahya Aghaee

function plotModelSimulation
    % ###Step 1
    % define the colors of the state variables
    M2_color  = [217/255, 196/255,  255/255]; % purple
    F_color  = [217/255, 217/255, 217/255]; % light gray
    B_color = [239/255, 157/255, 192/255]; % pink
    Tc_color = [191/255, 224/255, 179/255]; % green
    Tr_color = [228/255, 191/255, 174/255]; % orange
    line_width = 5;

    %load the parameter names and values
    p = setParameters();

    % ###Step 2
    % set simulation timespan and load the initial conditions
    t0 = 0; tfinal = 1000; % initial and final simulation times in days
    IC = setInitialConditions(); % get the initial values of the model
    IC = struct2cell(IC); IC = [IC{:}];
    
    if tfinal > 500
        plot_title_font = 15;
    else
        plot_title_font = 17;
    end

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
    plot(Tf, M2F, 'Color', M2_color, 'LineWidth',line_width, 'LineStyle', '--')
    xlim([0 tfinal])
    xlabel('Time (days)', 'FontWeight', 'bold', 'FontSize', 20)
    ylabel('M2 (cells/mm^3)', 'FontWeight', 'bold', 'FontSize', 18)
    title('M2 Macrophages (M_2)', 'FontWeight', 'bold', 'FontSize', plot_title_font)


    % Top middle plot
    nexttile
    plot(Tf,FF,'Color', F_color,'LineWidth', line_width, 'LineStyle', '-')
    title('Cell Populations')
    xlim([0 tfinal]) 
    %ylim([0 2*p.KF])
    xlabel('Time (days)', 'FontWeight', 'bold', 'FontSize', 20)
    ylabel('F (mm^3)','FontWeight', 'bold', 'FontSize', 18)
    title('Cancer-Associated Fibroblasts (F)', 'FontWeight', 'bold', 'FontSize', plot_title_font)


    % Top right plot
    nexttile
    plot(Tf,BF, 'Color', B_color, 'LineWidth', line_width, 'LineStyle', '-')
    xlim([0 tfinal])
    xlabel('Time (days)', 'FontWeight', 'bold', 'FontSize', 20)
    ylabel('B (mm^3)', 'FontWeight', 'bold', 'FontSize', 18)
    title('Breast Cancer Tumor Cells (B)', 'FontWeight', 'bold', 'FontSize', plot_title_font)


    % Bottom left plot
    nexttile
    plot(Tf,TcF, 'Color', Tc_color,'LineWidth',line_width, 'LineStyle', ':')
    xlim([0 tfinal])
    ylim([0 2*p.KC])
    xlabel('Time (days)', 'FontWeight', 'bold', 'FontSize', 20)
    ylabel('T_{C} (cells/mm^3)', 'FontWeight', 'bold', 'FontSize', 18)
    title('Cytotoxic T cells (T_{C})', 'FontWeight', 'bold', 'FontSize', plot_title_font)



    % Bottom middle plot
    nexttile
    plot(Tf,TrF,'Color', Tr_color, 'LineWidth',line_width, 'LineStyle', '-.')
    xlim([0 tfinal])
    xlabel('Time (days)', 'FontWeight', 'bold', 'FontSize', 20)
    ylabel('T_{R} (cells/mm^3)', 'FontWeight', 'bold', 'FontSize', 18)
    title('Regulatory T cells (T_{R})', 'FontWeight', 'bold', 'FontSize', plot_title_font)



    % Bottom right plot (overlay of all curves)
    nexttile

    % Left axis: M2, Tc, Tr
    yyaxis left
    plot(Tf, M2F, 'Color', M2_color, 'LineWidth', line_width, 'LineStyle', '--'); hold on
    plot(Tf, TcF, 'Color', Tc_color, 'LineWidth', line_width, 'LineStyle', ':');
    plot(Tf, TrF, 'Color', Tr_color, 'LineWidth', line_width, 'LineStyle', '-.');
    ylabel('M2, T_C, T_R (cells/mm^3)', 'FontWeight', 'bold', 'FontSize', 18, 'Color', 'black')
    ylim([0 2e5])
    ax = gca;
    ax.YColor = 'k'; %make axis black, it was defaulting to blue
    
    % Right axis: F, B
    yyaxis right
    ax.YColor = 'k';
    plot(Tf, FF, 'Color', F_color, 'LineWidth', line_width, 'LineStyle', '-');
    plot(Tf, BF, 'Color', B_color, 'LineWidth', line_width, 'LineStyle', '-');
    ylabel('F, B (mm^3)', 'FontWeight', 'bold', 'FontSize', 18, 'Color', 'black')
    
    xlim([0 tfinal])
    xlabel('Time (days)', 'FontWeight', 'bold', 'FontSize', 20)
    title('All Cell Populations', 'FontWeight', 'bold', 'FontSize', plot_title_font)
    ax = gca;
    ax.YColor = 'k'; %make axis black, it was defaulting to orange
    legend({'M2','T_C','T_R','F','B'}, 'Location','northwest')

    %if tfinal > 500
     %   legend({'M2','T_C','T_R','F','B'}, 'Location','northwest')
    %else 
     %   legend({'M2','T_C','T_R','F','B'}, 'Location','north')
    %end

end 
