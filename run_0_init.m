function run_0_init()

init_toolbox();

%% file
file_init = 'data/init.mat';

%% run
const = get_fem_ann_data_init();

%% save
[s, m] = mkdir(fileparts(file_init));
save(file_init, '-struct', 'const')

end
