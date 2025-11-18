function p = setParameters()
    % Parameters of Liver Transplant model (35 parameters)
    % This code is based on code originally written by Jaimit Parikh
    % in 2023 and modified by Mahya Aghaee in 2024
    
    % parameters: 
    p.aB2   = 1000;       % 1
    p.bB2   = 5000;          % 2
    p.aF2   = 1.2;         % 3
    p.bF2   = 5000000;     % 4 
    p.g2    = 0.04;      % 5
    p.aC2   = 3;   % 6
    p.bC2   = 150000;           % 7
    p.d2    = 0.1155;         % 8
    p.aBF   = 100000000*0.000768;          % 9
    p.bBF   = 5000;           %10
    p.KF    = 7691790;       %11
    %p.KF = (.35)*261.799;
    p.dF    = .012*0.005;        %12
    p.pB    = 0.00998;         %13
    p.KB    = 261799;           %14
    p.a2B   = 0.318;       %15
    p.b2B   = 100000;       %16
    p.aFB   = 1.625;           %17
    p.bFB   = 2500000;          %18
    p.dB    = 0.0005;        %19 had to change
    p.aCB   = 35;         %20
    p.bCB   = 150000;           %21
    p.aBC   = 0.136;       %22
    p.bBC   = 5000;       %23
    p.a2C   = 0.758;       %24
    p.b2C   = 10000;      %25
    p.aRC   = 0.5;       %26
    p.bRC   = 150000;     %27
    p.pC    = 2.08;        %28
    p.KC    = 300000;         %29
    p.a2LC  = 7;        %30
    p.b2LC  = 9900.7;        %31
    p.aRCP  = 0.71;       %32
    p.bRCP  = 250000;   %33
    %p.dC    = 0.585; %34
    p.dC = 7; %changed to be inactivation rate
    p.sR    = 57;         %35
    p.a2R   = 0.25;           %37
    p.b2R   = 10000;           %38
    p.aBR   = 1.0625;           %39
    p.bBR   = 5000;           %40
    p.dR    = 0.0658;           %41

 
end
