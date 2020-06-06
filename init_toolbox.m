function init_toolbox()
% Init the MATLAB Inductor FEM/ANN toolbox.
%
%    Add the code to the MATLAB path.
%    Close all figures.
%    Display a copyright notice.
%
%    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod

% add path
addpath(genpath('source_ann'))
addpath(genpath('source_inductor'))
addpath(genpath('source_input'))

% init random number generator
rng('shuffle')
gpurng('shuffle');

% close figures
close('all')

% define header and copyright
txt = {};
txt{end+1} = '  ________________________________________________________';
txt{end+1} = ' |       _________   ___                                  |';
txt{end+1} = ' |      /  ___   /  /  /         _ __ ___   __ _  __ _    |';
txt{end+1} = ' |     /  /__/  /  /  /   ____  | `_ ` _ \ / _` |/ _` |   |';
txt{end+1} = ' |    /  ___   /  /  /   /___/  | | | | | | (_| | (_| |   |';
txt{end+1} = ' |   /__/  /__/  /__/           |_| |_| |_|\__,_|\__, |   |';
txt{end+1} = ' |                                               |___/    |';
txt{end+1} = ' |________________________________________________________|';
txt{end+1} = ' |                                                        |';
txt{end+1} = ' |   AI-mag: Inductor Optimization with FEM/ANN           |';
txt{end+1} = ' |________________________________________________________|';
txt{end+1} = ' |      ____________________   ___                        |';
txt{end+1} = ' |     /  ________   ___   /__/  /   ETH Zurich           |';
txt{end+1} = ' |    /  _____/  /  /  /  ___   /    Power Electronic     |';
txt{end+1} = ' |   /_______/  /__/  /__/  /__/     Systems Laboratory   |';
txt{end+1} = ' |________________________________________________________|';
txt{end+1} = ' |                                                        |';
txt{end+1} = ' |   T. Guillod, Power Electronic Systems Laboratory      |';
txt{end+1} = ' |   Copyright 2019-2020 ETH Zurich / BSD License         |';
txt{end+1} = ' |________________________________________________________|';
txt{end+1} = ' ';

% display
for i=1:length(txt)
    fprintf('%s\n', txt{i})
end

end