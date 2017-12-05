function [x,out]= l1_proximal_FISTA_gradient(x0, A, b, mu, opts)
%  --------------------------------------------------------------
%  L1 Smooth FISTA Gradient Method
%
%  This function solves the convex problem
%
%     x = argmin 0.5 * ||Ax - b||_2^2 + mu * ||x||_1
%
%  using the the sub gradient method. 
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

%% Initialization
Atb = A' * b;              % precompute A^Tb due to its frequent usage
alpha = 3e-4;              % initial step length
tolA = 1e-7;               % stopping criterion
maximum_step = 50;
x = x0;                    % set the initial point
old_x = x;

%% Gradient Descent Loop
mus = mu * [1e5, 1e4, 1e3, 1e2, 1e1, 1e0];
for count = 1:length(mus)
    % anneal mu gradually
    mu = mus(count);
    for step=1:maximum_step
        % apply gradient descent step
        y = x + 1.0 * (step - 2) / (step + 1) * (x - old_x);
        old_x = x;
        grad = A' * (A * y) - Atb;
        tmp = y - alpha * grad;
        beta = alpha * mu;
        x = (abs(tmp) > beta) .* (tmp - sign(tmp) * beta);
        dx = x - old_x;
        
        % stop when the relative improvement is small
        if norm(dx, 2) <= tolA * norm(x, 2)
            break;
        end
    end
end

%% Output
out.optval = 0.5 * norm(A * x - b, 2)^2 + mu * norm(x, 1);

end
