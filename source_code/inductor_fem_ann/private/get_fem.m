function get_fem(folder, model_type, n_sol, inp, const)

% compute
for i=1:n_sol
    fprintf('    %d / %d\n', i, n_sol)
    inp_tmp =  get_struct_idx(inp, i);

    get_out_sub(folder, model_type, inp_tmp, const);
end

end

function get_out_sub(folder, model_type, inp, const)

% get filename
hash = get_hash_struct(inp);
filename = [folder filesep() hash '.mat'];
make_computation = exist(filename, 'file')~=2;

if make_computation==true
    % start timer
    tic = datetime('now');
    fprintf('        compute: start\n')
    
    % merge
    param = get_struct_merge(inp, const);
    [is_valid, param] = get_extend_param(model_type, param);
        
    % disp
    if is_valid==true
        fprintf('        compute: valid\n')
        out_fem = get_out_fem(model_type, param);
    else
        fprintf('        compute: invalid\n')
        out_fem = struct();
    end    
    
    % end timer
    toc = datetime('now');
    diff = toc-tic;
    fprintf('        compute: %s\n', char(diff))
        
    % save
    save(filename, 'inp', 'is_valid', 'const', 'model_type', 'out_fem', 'diff')
end

end