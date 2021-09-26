function velocity = get_velocity_fromPCA_003(pcaScore_ratio, row_num, col_num)

% step_num = 3;
% Para.velocity_variety = linspace(-1,1,step_num);
% vv = Para.velocity_variety;
% 
% [x1, x2, x3, x4, x5, x6, x7, y1, y2, y3, y4, y5, y6, y7] = ...
%     ndgrid(vv, vv, vv, vv, vv, vv, vv, vv, vv, vv, vv, vv, vv, vv);
% 
% load('Para')
% 
% target_performance = 5;
% target_vm = Para.velocity_matrix_NaN(Para.performance < target_performance, :);
% target_performance = Para.performance(Para.performance < target_performance);
% target_vm = unique(target_vm, 'rows');
% 
% [coeff_vm, score_vm, latent_vm, ~, ~, mu_vm] = pca(target_vm, 'Weights', 1./(1 + target_performance), 'Centered', true);

coeff_vm = [
   -0.1529   -0.0376    0.0675   -0.0043    0.0531    0.0298    0.0167   -0.0554    0.0431   -0.4880    0.5930    0.3566    0.1954    0.4545
   -0.2538   -0.0330    0.0720    0.0089    0.1056    0.0963    0.0031   -0.2693    0.2045    0.7515    0.0204    0.1451    0.1747    0.4216
    0.0023    0.1082   -0.1697    0.0500   -0.3167   -0.4009   -0.0513    0.4856   -0.4910    0.1827   -0.0033   -0.0598    0.0958    0.4128
    0.5883    0.1390   -0.3662    0.0015    0.1795    0.4909    0.0312   -0.1265   -0.1538   -0.0550   -0.1282   -0.1182    0.0496    0.3883
    0.3654   -0.2417    0.5839    0.0046   -0.1030   -0.3503    0.1323   -0.3039    0.0127   -0.1506   -0.3028   -0.1091    0.0408    0.3096
   -0.1851   -0.0599    0.1705   -0.0160   -0.0475    0.2690   -0.5942    0.3683    0.3431   -0.1909   -0.3355   -0.1698    0.1206    0.2436
   -0.3261    0.0797   -0.2325    0.0030    0.0736   -0.0650    0.6658    0.1328    0.3089   -0.2042   -0.2748   -0.2896    0.1890    0.1747
   -0.0467   -0.4564   -0.1382    0.0306    0.1179    0.0652    0.0292    0.0380   -0.2756   -0.0562   -0.3726    0.4673    0.5266   -0.1884
    0.1406    0.7723    0.2182   -0.0340   -0.0907   -0.0518   -0.0124   -0.0199    0.0912   -0.0078   -0.1105    0.2388    0.4659   -0.1699
    0.3918   -0.2643   -0.3154   -0.0016   -0.3332   -0.2118   -0.0838    0.0369    0.4986    0.1113    0.2841   -0.1319    0.3680   -0.1360
    0.1463   -0.0885    0.3486   -0.0339    0.5749    0.0320    0.0890    0.3788   -0.1190    0.1516    0.3089   -0.3521    0.3065   -0.1210
   -0.1993   -0.0810    0.1931   -0.1987   -0.5406    0.4524    0.1183   -0.1882   -0.3087    0.0024    0.1485   -0.3590    0.2742   -0.0962
   -0.1717    0.0716   -0.1147    0.7573    0.1060   -0.1289   -0.2341   -0.3442   -0.1389   -0.1016    0.0297   -0.3190    0.2092   -0.0393
   -0.1606    0.0633   -0.2554   -0.6172    0.2610   -0.3389   -0.3124   -0.3554   -0.1292   -0.1047   -0.0407   -0.2495    0.1583    0.0238
   ];

mu_vm = [
   -0.7827   -0.7276   -0.5149   -0.0354    0.3173    0.5520    0.5639    0.5027    0.1483    0.4540    0.5786    0.5482    0.4428    0.4502
    ];

pcaScore_ratio = reshape(pcaScore_ratio, 1, 7 * 2);

pcaScore_max = sum(abs(coeff_vm),1);
pcaScore = pcaScore_max .* pcaScore_ratio;

velocity = pcaScore * coeff_vm' + mu_vm;
velocity = reshape(velocity, row_num, col_num);

velocity(velocity > 1) = 1;
velocity(velocity < -1) = -1;

end
