function velocity = get_velocity_fromPCA_002(pcaScore_ratio, row_num, col_num)

% step_num = 5;
% Para.velocity_variety = linspace(-1,1,step_num);
% vv = Para.velocity_variety;

% target_vm = Para.velocity_matrix_NaN(Para.performance < 4, :);
% target_performance = Para.performance(Para.performance < 4);
% target_vm = unique(target_vm, 'rows');
% 
% [coeff_vm, score_vm, latent_vm, ~, ~, mu_vm] = pca(target_vm, 'Weights', 1./(1 + target_performance));


coeff_vm = [
   -0.0959   -0.0539   -0.0743   -0.0468   -0.0407   -0.0152    0.7907    0.2323    0.2619    0.4802
   -0.2437   -0.1827   -0.1654   -0.1785   -0.2892    0.5931   -0.4177    0.0335    0.2107    0.4388
   -0.1451   -0.1407   -0.0361    0.0162    0.6833   -0.3955   -0.3383    0.0660    0.1529    0.4383
    0.3733    0.2102    0.5945   -0.0977   -0.3840   -0.2930   -0.1791   -0.0540    0.0621    0.4259
    0.2707    0.3381   -0.4853    0.6360   -0.0885    0.0047   -0.0449   -0.2764   -0.0241    0.2923
    0.1891   -0.2085   -0.2581   -0.2664   -0.1258   -0.2539    0.0021   -0.4708    0.6621   -0.2072
   -0.4311    0.4304    0.3938    0.3415    0.1088    0.1677   -0.0030   -0.0689    0.5294   -0.1796
    0.6298   -0.2604    0.1362    0.2519    0.2281    0.3354   -0.0418    0.4121    0.3166   -0.1310
    0.0942    0.6082   -0.3590   -0.3691   -0.0339   -0.1225   -0.1540    0.5273    0.1659   -0.1032
   -0.2656   -0.3449   -0.0880    0.4053   -0.4602   -0.4309   -0.1623    0.4325    0.1131   -0.1223
   ];

mu_vm = [
   -0.7009   -0.6174   -0.5833   -0.3866   -0.2715    0.4997    0.0351    0.1835    0.3198    0.4428
    ];

pcaScore_ratio = reshape(pcaScore_ratio, 1, 10);

pcaScore_max = sum(abs(coeff_vm),1);
pcaScore = pcaScore_max .* pcaScore_ratio;

velocity = pcaScore * coeff_vm' + mu_vm;
velocity = reshape(velocity, row_num, col_num);

velocity(velocity > 1) = 1;
velocity(velocity < -1) = -1;

end

