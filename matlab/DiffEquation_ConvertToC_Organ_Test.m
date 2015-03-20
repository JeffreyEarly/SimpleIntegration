clc;
close all;
clear all;

ti = 0;
tf = 300;
dt = 1;
t = (ti:dt:tf).';

% Q = 2.7; V=40;
Q=108.3333333;
Vol1 = 150;
Vol2 = 44;
IT = 25;
heav = zeros(size(t));
heav(find(t < IT)) = 1;
Ci = (350/IT)*2* (heav);
PS=Q;
% Co = solve_org(Ci, V, Q, t);
[Civ,Cec] = solve_org(Ci, Vol1, Vol2, Q, PS, t);
