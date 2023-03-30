function plotSplineStepByStep(X, Y)
    arguments
        X(:,:)
        Y(:,:)
    end

    
    S = splineG(X, Y);


    % clear plot and hold
    clf
    hold on


    xPoints = [];
    yPoints = [];


    for i = 1:length(X)-1

        x = 0:0.001:X(i+1)-X(i);
        y = polyval(S(4*(i-1)+1:4*i), x);

        plot(xPoints, yPoints, "b")
        hold on
        plot(x, y, "g")

        axis([min(0, min(X)), max(X), min(Y), max(Y)])

        pause
    
        clf

        xPoints = [xPoints, x + X(i)];
        yPoints = [yPoints, y];

        plot(xPoints, yPoints, "b")

        axis([min(0, min(X)), max(X), min(Y), max(Y)])

        pause
    end


    plot(X(1):0.001:X(length(X)), spline(X, Y, X(1):0.001:X(length(X))), "r")
end