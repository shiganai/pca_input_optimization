load('Para')

target_vm = Para.velocity_matrix_NaN(Para.performance < 4, :);
target_performance = Para.performance(Para.performance < 4);
target_vm = unique(target_vm, 'rows');

[coeff_vm, score_vm, latent_vm, ~, ~, mu_vm] = pca(target_vm, 'Weights', 1./(1 + target_performance));

varname = [
    strcat('x', num2str((1:5)'))
    strcat('y', num2str((1:5)'))
    ];
% biplot(coeff_vm(:,1:2),'scores',score_vm(:,1:2), 'VarLabels', varname)

pcaScore_zero = zeros(1, size(coeff_vm, 2));
velocity_zero = pcaScore_zero * coeff_vm' + mu_vm;

for coeff_index = 1:size(coeff_vm, 2)
    dockfig(coeff_index + 1)
    coeff_tmp = coeff_vm(:, coeff_index);
    
    pcaScore = pcaScore_zero;
    pcaScore(coeff_index) = 1;
    velocity = pcaScore * coeff_vm' + mu_vm;
    velocity_change = velocity - velocity_zero;
    velocity_change = reshape(velocity_change, 5, 2);
    trajectory = get_trajectory_edge(velocity_change);
    
    subplot(1,2,1)
    plot(1:5, velocity_change, '-o')
    legend('x', 'y')
    ylim([-1, 1])
    ax = gca;
    ax.XAxisLocation = 'origin';
   
    subplot(1,2,2)
    quiver(trajectory(1:end-1,1), trajectory(1:end-1,2), diff(trajectory(:,1)), diff(trajectory(:,2)), 'autoscale', 'off')
%     xlim([-1, 1])
%     ylim([-1, 1])
    daspect([1,1,1])
end