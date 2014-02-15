function [ results ] = weakLearner( feature,polarity,threshold )

    results = polarity .* (threshold - feature);
    results( find(results > 0) ) = 1;
    results( find(results < 0) ) = -1;

end

