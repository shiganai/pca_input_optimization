function plot_box(target_ax)

edge_position = [
    0, 0
    -3, 0
    -3, 3
    0, 3
    0, 2
    -2, 2
    -2, 1
    0, 1
    0, 0
    ];

plot(target_ax, edge_position(:,1), edge_position(:,2))
xlim(target_ax, [-4, 1])
ylim(target_ax, [-1, 4])
daspect(target_ax, [1, 1, 1])
end
