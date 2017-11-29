function [x, out] = l1_cvx_gurobi(x0, A, b, mu, opts)
%  --------------------------------------------------------------
%  L1 Regularized Problem with CVX-Gurobi
%
%  This function solves the convex problem
%
%     x = argmin 0.5 * ||Ax - b||_2^2 + mu * ||x||_1
%
%  calling cvx-gurobi. 
%
%  Author: Ni Chengzhuo, School of Mathematical Science, PKU
%  --------------------------------------------------------------
%
%  =========================== Inputs ===========================
%  
%  x0: m * 1 matrix, the starting point of the algotirhm
%
%  A: m * n matrix, the matrix to compute the l2 norm
%
%  b: m * 1 matrix, the target of approximation
%
%  mu: scalar, penalty of the l1 norm
%
%  opts: list, modify options
%
%  ==============================================================
%
%  =========================== Outputs ==========================
%  
%  x: the optimal point found by the algorithm
%
%  out: a structure recording some information about the process
%
%  ==============================================================

%% Problem Setting
[m, n] = size(A);

cvx_solver gurobi
cvx_begin quiet
  variable x(n)
  minimize(0.5 * (A * x - b)' * (A * x - b) + mu * norm(x, 1))
cvx_end

%% Output
out.optval = cvx_optval;

end
