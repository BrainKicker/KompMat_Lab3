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

    
    
end