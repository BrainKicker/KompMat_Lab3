function plotSpline(X, Y)
    arguments
        X(:,:)
        Y(:,:)
    end

    
    S = splineG(X, Y);


    % clear plot and hold
    clf
    hold on


    for i = 1:length(X)-1
        x = 0:0.001:X(i+1)-X(i);
        y = polyval(S(4*(i-1)+1:4*i), x);
        plot(x+X(i), y, "b")
    end


    plot(X(1):0.001:X(length(X)), spline(X, Y, X(1):0.001:X(length(X))), "r")


    plot(X, Y, "o")
end