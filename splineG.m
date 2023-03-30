function S = splineG(X, Y)
    arguments
        X(:,:)
        Y(:,:)
    end


    if length(X) ~= length(Y)
        throw(MException("lagrange:IllegalArgument", "The lengths of the arrays X (length %d) and Y (length %d) do not match.", length(X), length(Y)))
    end


    if isempty(X)
        S = [];
        return
    end

    if length(X) == 1
        S = [0, 0, 0, Y(1)];
        return
    end


    n = length(X);

    
    A = zeros(4*(n-1), 4*(n-1));
    B = zeros(1, 4*(n-1));


    % S_k(x_k) = y_k
    for i = 1:n-1
        A(i, 4*(i-1)+4) = 1;
        
        B(i) = Y(i);
    end

    % S_k(x_{k+1}) = y_{k+1}
    for i = 1:n-1

        j = i + n - 1;

        h = X(i+1) - X(i);

        A(j, 4*(i-1)+1) = h^3;
        A(j, 4*(i-1)+2) = h^2;
        A(j, 4*(i-1)+3) = h;
        A(j, 4*(i-1)+4) = 1;

        B(j) = Y(i+1);
    end

    % S'_k(x_{k+1}) = S'_{k+1}(x_{k+1})
    % S'_k(x_{k+1}) - S'_{k+1}(x_{k+1}) = 0
    for i = 1:n-2

        j = i + 2*n - 2;

        h = X(i+1) - X(i);
        
        A(j, 4*(i-1)+1) = 3*h^2;
        A(j, 4*(i-1)+2) = 2*h;
        A(j, 4*(i-1)+3) = 1;

        A(j, 4*i+3) = -1;
    end

    % S''_k(x_{k+1}) = S''_{k+1}(x_{k+1})
    % S''_k(x_{k+1}) - S''_{k+1}(x_{k+1}) = 0
    for i = 1:n-2
        
        j = i + 3*n - 4;

        h = X(i+1) - X(i);
        
        A(j, 4*(i-1)+1) = 6*h;
        A(j, 4*(i-1)+2) = 2;

        A(j, 4*i+2) = -2;
    end


    %% VARIANT 1 - minimal potential
    % S''_1(x_1) = 0, S''_{n-1}(x_n) = 0
    A(4*n-5, 2) = 2;
    A(4*n-4, 4*(n-2)+1) = 6*(X(n)-X(n-1));
    A(4*n-4, 4*(n-2)+2) = 2;

    %% VARIANT 2 - derivatives at the ends
    % S'_1(x_1) = (y_2-y_1)/(x_2-x_1)
    % S'_{n-1}(x_n) = (y_n-y_{n-1})/(x_n-x_{n-1})
%     A(4*n-5, 3) = 1;
%     B(4*n-5) = (Y(2)-Y(1))/(X(2)-X(1));
%     A(4*n-4, 4*(n-2)+1) = 3*(X(n)-X(n-1))^2;
%     A(4*n-4, 4*(n-2)+2) = 2*(X(n)-X(n-1));
%     A(4*n-4, 4*(n-2)+3) = 1;
%     B(4*n-4) = (Y(n)-Y(n-1))/(X(n)-X(n-1));

    %% VARIANT 3 - good beginning
    % S'_1(x_1) = (y_2-y_1)/(x_2-x_1), S''_1(x_1) = 0
%     A(4*n-5, 3) = 1;
%     B(4*n-5) = (Y(2)-Y(1))/(X(2)-X(1));
%     A(4*n-4, 2) = 2;

    %% VARIANT 4 - good ending
    % S'_{n-1}(x_n) = (y_n-y_{n-1})/(x_n-x_{n-1})
    % S''_{n-1}(x_n) = 0
%     A(4*n-5, 4*(n-2)+1) = 3*(X(n)-X(n-1))^2;
%     A(4*n-5, 4*(n-2)+2) = 2*(X(n)-X(n-1));
%     A(4*n-5, 4*(n-2)+3) = 1;
%     B(4*n-5) = (Y(n)-Y(n-1))/(X(n)-X(n-1));
%     A(4*n-4, 4*(n-2)+1) = 6*(X(n)-X(n-1));
%     A(4*n-4, 4*(n-2)+2) = 2;

    %% VARIANT 5 - same ends
    % S'_1(x_1) = S'_{n-1}(x_n)
    % S''_1(x_1) = S''_{n-1}(x_n)
%     A(4*n-5, 3) = 1;
%     A(4*n-5, 4*(n-2)+1) = -3*(X(n)-X(n-1))^2;
%     A(4*n-5, 4*(n-2)+2) = -2*(X(n)-X(n-1));
%     A(4*n-5, 4*(n-2)+3) = -1;
%     A(4*n-4, 2) = 2;
%     A(4*n-4, 4*(n-2)+1) = -6*(X(n)-X(n-1));
%     A(4*n-4, 4*(n-2)+2) = -2;


    S = linsolve(A, B.').';
end