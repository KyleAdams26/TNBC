function p = setParameters()
    % Parameters of TNBC model (39 parameters)
    % This code is based on code originally written by Jaimit Parikh
    % in 2023 and modified by Mahya Aghaee in 2024

    % parameters: 
    p.aB2   = 10000;       % 1
    p.bB2   = 3090;          % 2
    p.aF2   = 0.8;         % 3
    p.bF2   = 1180;     % 4 
    p.g2    = 0.005;      % 5
    p.aC2   = 3;   % 6
    p.bC2   = 121000;           % 7
    p.d2    = 0.116;         % 8
    p.sF    = 0.000998;          %9
    p.KF    = 49900;          %10
    p.dF    = .00175;         %11
    p.pB    = 0.00998;        %12
    p.KB    = 161000;        %13
    p.a2B   = 0.583;          %14
    p.b2B   = 13520;           %15
    p.aFB   = 1.63;          %16
    p.bFB   = 1180;       %17
    p.dB    = 0.0005;         %18
    p.aCB   = 23.4;             %19
    p.bCB   = 121000;       %20
    p.a2CB   = 0.795;          %21
    p.b2CB   = 13500;           %22
    p.aBCB   = 0.788;          %23
    p.bBCB   = 3090;         %24
    p.aRCB   = 0.545;            %25
    p.bRCB   = 49600;       %26
    p.pC    = 0.444;           %27
    p.KC    = 159000 ; %28
    p.a2C  = 7;              %29
    p.b2C  = 2700000;         %30
    p.aRC  = 0.946;          %31
    p.bRC  = 49600;       %32
    p.aFC = 0.756;
    p.bFC = 1180;
    p.dC    = 0.103;          %33
    p.sR    = 583;         %34
    p.a2R   = 0.471;           %35
    p.b2R   = 13500;           %36
    p.aBR   = 1.063;         %37
    p.bBR   = 3090;          %38
    p.aFR = 1.57;
    p.bFR = 1180;
    p.dR    = 0.0630;          %39

 
end
