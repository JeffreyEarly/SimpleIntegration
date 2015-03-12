function [Civ,Cec] = solve_org(Ca, Viv, Vec, Q, P, T)
%   Vol1: Viv (intra vascular volume)
%   Vol2: Vec (extra cellular volume)
%   Q: Blood flow rate (BFR)
%   Civ and Ca: input and output concentration of iodine
%   P: a number chosen for multiplication of permeability and surface area
%   T: total time
Ca_fun = @(t) interp1(T,Ca,t,'linear','extrap');

dC = @(t,C) [(Q/Viv) * (Ca_fun(t) - C(1)) - (P/Viv) * (C(1) - C(2)) ; (P/Vec) * (C(1) - C(2))];

[~, C] = ode45(dC, T, [0;0]);

Civ = C(:,1);
Cec = C(:,2);
end