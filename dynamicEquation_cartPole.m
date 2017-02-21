
syms theta(t) dtheta x(t) dx l t
position = [1 0 0 x;
    0 1 0 0;
    0 0 1 0;
    0 0 0 1]*...
    [cos(theta) -sin(theta) 0 0;
    sin(theta) cos(theta) 0 0;
    0 0 1 0;
    0 0 0 1]*...
    [1 0 0 0;
    0 1 0 l;
    0 0 1 0;
    0 0 0 1];
    
dposition = diff(position,t);

dposition = subs(dposition, diff(theta(t),t), dtheta);
dposition = subs(dposition, diff(x(t),t), dx);

% T = dposition*inv(position);
T = position\dposition;
syms theta dtheta x dx m_cart m_body g F
% T_new = [0, -dtheta, 0, dx;
%     dtheta, 0, 0, -dtheta*x;
%     0, 0, 0, 0; 0, 0, 0, 0];
T_new = [0, -dtheta, 0, -(dtheta*l*cos(theta)^2 - dx*cos(theta) + dtheta*l*sin(theta)^2)/(cos(theta)^2 + sin(theta)^2);
    dtheta, 0, 0, -(dx*sin(theta))/(cos(theta)^2 + sin(theta)^2);
    0, 0, 0, 0; 0, 0, 0, 0];
g_vector = vectorFromTwist(T_new);

g_vector = [g_vector(4:5),g_vector(3)];
g_vector_trans = [g_vector(1);g_vector(2);g_vector(3)];

m_matrix = [m_body 0 0; 0 m_body 0; 0 0 0];

L = 0.5*m_cart*dx^2 + 0.5*g_vector*m_matrix*g_vector_trans...
    -m_body*g*l*cos(theta); % Lagrangian

X = {x dx theta dtheta}; % Vector of generalized coordinates %X = {q1 dq1 q2 dq2 ...}
Q_i = {0 0}; Q_e = {F 0}; % No generalized forces
R = 0; % Friction term
par = {g m_cart m_body l}; % System parameters
% Create symbolic differential equations …
VF = EulerLagrange(L,X,Q_i,Q_e,R,par,'s');

%%
A_time = jacobian(VF,[x dx theta dtheta]);
B_time = jacobian(VF, F);
A_lin = subs(A_time, [theta x dtheta dx], [0 0 0 0]);
B_lin = subs(B_time, [theta x dtheta dx], [0 0 0 0]);

%%
g = 9.81;
m_cart = 1;
m_body = 0.1;
l = 1;
A = eval(A_lin);
B = eval(B_lin);

gravity = g;
m_c = m_cart;
m_b = m_body;
l_pend = l;

p = [-2 -3 -4 -5];
feedbackGain = -place(A, B, p);

%%
x_initial = 0;
dx_initial = 0; 
theta_initial = 1;
dtheta_initial = 0;

%%

u = 