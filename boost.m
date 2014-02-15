function [ features,thresholds,polarities,alphas ] = boost( Train1,Train2,t )
    ham = Train1;
    spam = Train2;
    data = [ham;spam];
    true_labels = zeros(size(data,1),1);
    true_labels(1:size(ham,1)) = 1;
    true_labels(size(spam,1)+1:end) = -1;

    
    %Variable Initialization:
    features=[];
    thresholds=[];
    polarities=[];
    alphas =[]; %classifier weight
    weight = ones(size(true_labels))/length(true_labels); %sample weight

    for ii = 1:t,
        error = [];
        classifier_holder = [];


        for jj = 1:size(data,2),
            uni_feature = unique( data(:,jj) );
            thresholds_temp = ( uni_feature(2:size(uni_feature,1)) + uni_feature(1:( size(uni_feature,1)-1 )) ) ./ 2;
            if  length(thresholds_temp) ~= 0,
                for kk = [-1,1],
                    for oo = 1:size(thresholds_temp,1),
                        %
                        % jj = for each columns of features
                        % kk = for each polarity
                        % oo = for each thresholds
                        %
                        current_polarity = kk;
                        current_threshold = thresholds_temp(oo);
                        current_feature = data(:,jj);

                        current_error = sum( weight.* (weakLearner( current_feature,current_polarity,current_threshold ) ~= true_labels) );

                        error = [ error;current_error ];
                        classifier_holder = [ classifier_holder;[jj,current_polarity,current_threshold] ];

                    end
                end
            end
         end
    
        smallest_error_idx = find(error == min(error))
        smallest_error_idx = smallest_error_idx(1)
        smallest_error = error(smallest_error_idx)
        classifier_holder = classifier_holder( classifier_holder(smallest_error_idx),: )
        features=[features;classifier_holder(1)];
        thresholds=[thresholds;classifier_holder(3)];
        polarities=[polarities;classifier_holder(2)];

        alpha_temp = 1/2 * log( (1-smallest_error) / smallest_error);
        alphas = [alphas;alpha_temp]

        weight = weight.*exp( alpha_temp .* true_labels .*  weakLearner(data(:,classifier_holder(1)), classifier_holder(2),classifier_holder(3) ) );
        weight = weight./sum(weight);

    end


end

