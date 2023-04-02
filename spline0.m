function S = spline0(X, Y)
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


    dX = zeros(1, n-1);

    % delta(x_k) = dX(k)
    for i = 1:n-1
        dX(i) = X(i+1) - X(i);
    end


    dY = zeros(1, n-1);

    % delta(y_k) = dY(k)
    for i = 1:n-1
        dY(i) = Y(i+1) - Y(i);
    end

    d2Y = zeros(1, n-2);

    % delta^2(y_k) = d2Y(k)
    for i = 1:n-2
        d2Y(i) = dY(i+1) - dY(i);
    end


    % b_1 = 0, b_k = ..., b_n = 0 - fictional
    B = [0, d2Y, 0];

    
    for i = 2:n-1
        B(i) = B(i) * 3 / dX(i) / dX(i-1);
    end


    M = zeros(1, n-2);
    
    M(1) = 1/4;
    for i = 2:n-2
        M(i) = 1/(4-M(i-1));
    end


    B(2) = B(2) * M(1);
    for i = 3:n-1
        B(i) = B(i) - B(i-1);
        B(i) = B(i) * M(i-1);
    end

    for i = n-2:-1:2
        B(i) = B(i) - B(i+1) * M(i-1);
    end

    
    C = zeros(1, n-1);

    for i = 1:n-1
        C(i) = dY(i)/dX(i) - dX(i)*((2*B(i)+B(i+1))/3);
    end

    
    A = zeros(1, n-1);

    for i = 1:n-1
        A(i) = (B(i+1)-B(i))/(3*dX(i));
    end


    % D = Y; - not needed


    S = zeros(1, 4*(n-1));

    for i = 1:n-1
        S(4*(i-1)+1) = A(i);
        S(4*(i-1)+2) = B(i);
        S(4*(i-1)+3) = C(i);
        S(4*(i-1)+4) = Y(i); % = D(i)
    end
end