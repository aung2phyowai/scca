function [ u,v,sigma ] = ALS_CCA_inv( X,Y,r_x,r_y,T)
%Input: Data matrices X in d_x\times N, Y in d_y\times N
%regularization parameters r_x, r_y
%number of iterations T
%Output: top left and right canonical directions u,v
%top singular value sigma
[d_x,N] = size(X);
[d_y,~] = size(Y);
%Initialize u,v from a multivariate normal(0,1)
u = randn(d_x,1);
v = randn(d_y,1);
%Normalize u,v
u = u/sqrt(norm((1/N)*(u'*X))^2+r_x*norm(u)^2);
v = v/sqrt(norm((1/N)*(v'*Y))^2+r_y*norm(v)^2);
%Initialize parameters for svrg
%M = 2;
%m = N;
%eta_x = eta/max(sqrt(sum(abs(X).^2,1)));
%eta_y = eta/max(sqrt(sum(abs(Y).^2,1)));
C_x = X*X'/N;
C_y = Y*Y'/N;
C_xy = X*Y'/N;
for t = 1:T
    %u_tilde = SVRG(u,v,X,Y,r_x,M,m,eta_x);
    %v_tilde = SVRG(v,u,Y,X,r_y,M,m,eta_y);
    u_tilde = C_x\(C_xy*v);
    v_tilde = C_y\(C_xy'*u);
    u = u_tilde/sqrt((u_tilde'*X)*(X'*u_tilde)/N+r_x*norm(u_tilde)^2);
    v = v_tilde/sqrt((v_tilde'*Y)*(Y'*v_tilde)/N+r_y*norm(v_tilde)^2);
end
sigma = (u'*X)*(Y'*v)/N;
end