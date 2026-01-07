function dcdt = odefun(~, c, p) %QC'd
    % odefun - system of equations of the TNBC model
    % Inputs:
    %   ~ - time (called t in "Dynamics" in step 3)
    %   c - state variables
    %   p - parameter structure
    % Outputs:
    % dcdt - Derivatives of the state variables
    % Code Authors: Jaimit Parikh, Mahya Aghaee, and Kyle Adams
 
    % ###Step 1
    % # c : levels of 5 biological factors at t. 
    M2  = c(1); % M2 macrophages
    F  = c(2); % Cancer-associated fibroblasts
    B = c(3); % TNBC cells
    Tc = c(4); % Tc cells  
    Tr = c(5); % T reg cells

    % ###Step 2
        %% -- The rate change of the 5 populations (Dynamics of the system) -- %%
        % Pathways for the dynamics %
   
    aPath = p.aF2*F/(p.bF2 + F);
    bPath = p.a2R*M2/(p.b2R + M2);
    c_lPath = p.aB2*B/(p.bB2 + B);
    %d_mPath = p.lF*p.pB*B*(1 - F/p.KF);
    %d_mPath = p.lF*B*(1 - F/p.KF)*(1 - B/p.KB);
    %d_mPath = p.lF*B*(1 - F/p.KF);
    %d_mPath = 1*B/(1150 + B)*p.pB*B - p.dF*F;
    %d_mPath = p.lF*p.pB*B*(1 - B/p.KB);
    d_mPath = p.pB*B*(1-F/p.KF);
    ePath = p.g2*M2;
    fPath = p.a2B*M2/(p.b2B + M2);
    gPath = p.aFB*F/(p.bFB + F);
    hPath = p.aC2*Tc/(p.bC2 + Tc);
    iPath = p.d2*M2;
    jPath = p.pB*B*(1 - B/p.KB);
    kPath = p.dF*F;
    nPath = p.a2C*M2/(p.b2C + M2);
    oPath = p.a2CB*M2/(p.b2CB + M2);
    pPath = p.aBR*B/(p.bBR + B);
    qPath = p.pC*Tc*(1 - Tc/p.KC);
    rPath = p.aBCB*B/(p.bBCB + B);
    sPath = p.sR;
    tPath = p.aCB*Tc/(p.bCB + Tc);
    uPath = p.dB*B;
    vPath = p.dC*Tc;
    wPath = p.aRCB*Tr/(p.bRCB + Tr);
    xPath = p.dR*Tr;
    yPath = p.aRC*Tr/(p.bRC + Tr);


    % ###Step 3
    % Dynamics 
    dy(1)  = c_lPath*(1 + aPath) - ePath*(1 + hPath) - iPath; %dM2dt
    dy(2) = d_mPath - kPath;
    dy(3)  = jPath*(1 + fPath)*(1 + gPath) - uPath*(1 + tPath * ( 1 - rPath )*( 1 - oPath )*( 1 - wPath ) );%dBdt
    dy(4)  = qPath*(1 + nPath)*(1 - yPath) - vPath; %dTcdt
    dy(5)  = sPath*(1 + bPath)*(1 + pPath) - xPath; %dTrdt

    dcdt = [dy(1), dy(2), dy(3), dy(4), dy(5)]';
end
