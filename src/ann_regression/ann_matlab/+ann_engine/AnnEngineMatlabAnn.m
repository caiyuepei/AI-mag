classdef AnnEngineMatlabAnn < ann_engine.AnnEngineAbstract
    % Regression engine using MATLAB ANN.
    %
    %    Class implementing 'AnnEngineAbstract'.
    %    Train, load, unload, and evaluate MATLAB ANN.
    %
    %    (c) 2019-2020, ETH Zurich, Power Electronic Systems Laboratory, T. Guillod
    
    %% properties
    properties (SetAccess = private, GetAccess = public)
        fct_model % fct: function for creating the ANN
        fct_train % fct: function for training the ANN
        ann_data % struct: ANN data storage
    end
    
    %% public
    methods (Access = public)
        function self = AnnEngineMatlabAnn(fct_model, fct_train)
            % Constructor.
            %
            %    Parameters:
            %        fct_model (fct): function for creating the ANN
            %        fct_train (fct): function for training the ANN
            
            self = self@ann_engine.AnnEngineAbstract();
            self.fct_model = fct_model;
            self.fct_train = fct_train;
            self.ann_data = struct();
        end
        
        function load(self, name, model, history)
            % Load a regression to the memory.
            %
            %    Parameters:
            %        name (str): Name of the regression to be loaded
            %        model (various): regression parameters
            %        history (various): regression training/fitting record
            
            % check the data type
            assert(isa(model, 'network'), 'invalid model type')
            assert(isstruct(history), 'invalid history type')
            
            % load the data
            self.ann_data.(name) = struct('model', model, 'history', history);
        end
        
        function unload(self, name)
            % Remove an regression from the memory.
            %
            %    Parameters:
            %        name (str): Name of the regression to be removed
            
            % remove the entry (also if not existing)
            self.ann_data = rmfield(self.ann_data, name);
        end
        
        function [model, history] = train(self, inp, out)
            % Train/fit a regression and get the corresponding model.
            %
            %    Parameters:
            %        inp (matrix): matrix with the input data
            %        out (matrix): matrix with the output data
            %
            %    Returns:
            %        model (various): regression parameters
            %        history (various): regression training/fitting record
            
            % get the size of the samples
            n_inp = size(inp, 1);
            n_out = size(out, 1);
            n_sol_inp = size(inp, 2);
            n_sol_out = size(out, 2);
            
            % check and get the number of samples
            assert(n_sol_inp==n_sol_out, 'invalid number of samples')
            n_sol = mean([n_sol_inp n_sol_out]);
            
            % get the ANN model
            assert(n_sol>0, 'invalid number of samples')
            assert(n_inp>0, 'invalid number of inputs')
            assert(n_out>0, 'invalid number of outputs')
            model = self.fct_model(n_sol, n_inp, n_out);
            [model, history] = self.fct_train(model, inp, out);
            
            % check the data type
            assert(isa(model, 'network'), 'invalid model type')
            assert(isstruct(history), 'invalid history type')
        end
        
        function out = predict(self, name, inp)
            % Evaluate a regression with given input data.
            %
            %    Parameters:
            %        name (str): Name of the regression to be evaluated
            %        inp (matrix): matrix with the input data
            %
            %    Returns:
            %        out (matrix): matrix with the output data
            
            % get and check the model
            model = self.ann_data.(name).model;
            history = self.ann_data.(name).history;
            assert(isa(model, 'network'), 'invalid model type')
            assert(isstruct(history), 'invalid history type')
            
            % evaluate the model
            out = model(inp);
            assert(size(inp, 2)==size(out, 2), 'invalid number of samples')
        end
    end
end
