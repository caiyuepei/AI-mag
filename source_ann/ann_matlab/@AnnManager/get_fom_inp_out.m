function get_fom_inp_out(self)

self.fom.n_sol = self.n_sol;
self.fom.n_train = nnz(self.idx_train);
self.fom.n_test = nnz(self.idx_test);

self.fom.inp = get_fom_set(self.var_inp, self.inp, self.idx_train, self.idx_test);
self.fom.out_ref = get_fom_set(self.var_out, self.out_ref, self.idx_train, self.idx_test);
self.fom.out_nrm = get_fom_set(self.var_out, self.out_nrm, self.idx_train, self.idx_test);
self.fom.out_ann = get_fom_set(self.var_out, self.out_ann, self.idx_train, self.idx_test);

self.fom.err_ann_nrm = get_fom_err(self.var_out, self.out_nrm, self.out_ref, self.idx_train, self.idx_test);
self.fom.err_ann_ref = get_fom_err(self.var_out, self.out_ann, self.out_ref, self.idx_train, self.idx_test);

end

function fom = get_fom_err(var, data_cmp, data_ref, idx_train, idx_test)

for i=1:length(var)
    name_tmp = var{i}.name;
    vec_cmp = data_cmp.(name_tmp);
    vec_ref = data_ref.(name_tmp);
    
    fom_tmp.train = get_var_err(vec_cmp, vec_ref, idx_train);
    fom_tmp.test = get_var_err(vec_cmp, vec_ref, idx_test);
    
    fom.(name_tmp) = fom_tmp;
end

end

function fom = get_fom_set(var, data, idx_train, idx_test)

for i=1:length(var)
    name_tmp = var{i}.name;
    vec = data.(name_tmp);
    
    fom_tmp.train = get_var_set(vec, idx_train);
    fom_tmp.test = get_var_set(vec, idx_test);
    
    fom.(name_tmp) = fom_tmp;
end

end

function var = get_var_set(vec, idx)

vec = vec(idx);

var.vec = vec;
var.v_avg = mean(vec);
var.v_std_dev = std(vec);
var.v_max = max(vec);
var.v_min = min(vec);

end

function var = get_var_err(vec_cmp, vec_ref, idx)

vec_cmp = vec_cmp(idx);
vec_ref = vec_ref(idx);
vec = abs(vec_cmp-vec_ref)./vec_ref;
    
var.vec = vec;
var.v_mean = mean(vec);
var.v_rms = rms(vec);
var.v_max = max(vec);

end

