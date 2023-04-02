function y = splineGValues(X, Y, x)
    arguments
        X(:,:)
        Y(:,:)
        x(1,:)
    end

    S = splineG(X, Y);

    y = zeros(1, length(x));

    curX = 1;
    for i = 1:length(x)
        while curX < length(X) && x(i) > X(curX+1)
            curX = curX + 1;
        end
        y(i) = polyval(S(4*(curX-1)+1:4*curX), x(i) - X(curX));
    end
end