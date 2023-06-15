classdef CoMMEA < ALGORITHM
% <multi> <real/integer/label/binary/permutation> <multimodal>
% Coevolutionary Framework for Generalized Multimodal Multi-Objective Optimization
% eps --- 0.2 --- Parameter for quality of the local Pareto front (This value is suggested to be 0 if the problem has no local Pareto front).

%------------------------------- Reference --------------------------------
% W. H. Li, X. Y. Yao, K. W. Li, R. Wang, T. Zhang, and  L. Wang,
% Coevolutionary framework for generalized multimodal multi-objective
% optimization, IEEE/CAA J. Autom. Sinica, vol. 10, no. 7, pp. 1544–1556,
% Jul. 2023.  doi:  10.1109/JAS.2023.123609
%------------------------------- Copyright --------------------------------
% Copyright (c) 2023 BIMK Group. You are free to use the PlatEMO for
% research purposes. All publications which use this platform or any code
% in the platform should acknowledge the use of "PlatEMO" and reference "Ye
% Tian, Ran Cheng, Xingyi Zhang, and Yaochu Jin, PlatEMO: A MATLAB platform
% for evolutionary multi-objective optimization [educational forum], IEEE
% Computational Intelligence Magazine, 2017, 12(4): 73-87".
%--------------------------------------------------------------------------

% This function is written by Wenhua Li
% p.s. CoMMEA require more function evaluations to receive better
% performance for multimodal multiobjective optimization problems.
    
    methods
        function main(Algorithm,Problem)
            
            eps = Algorithm.ParameterSet(0.2);
           %% Generate random population
            Population1 = Problem.Initialization();
            Population2 = Problem.Initialization();
            Fitness1    = CalFitness(Population1,'Normal');
            Fitness2    = CalFitness(Population2,'LocalC');
            
           %% Optimization
            while Algorithm.NotTerminated(Population2)
                MatingPool1 = TournamentSelection(2,round(Problem.N/4),Fitness1);
                MatingPool2 = TournamentSelection(2,Problem.N,Fitness2);
                Offspring1  = OperatorGA(Problem,Population1(MatingPool1));
                Offspring2  = OperatorGA(Problem,Population2(MatingPool2));
                
               %% Enviornmental selection
                EvoState = Problem.FE / Problem.maxFE;
                CurEps = max(-log2(1.5*EvoState),eps); % Compute the current epsilon value
                [Population1,Fitness1] = EnvironmentalSelection1([Population1,Offspring1,Offspring2],Problem.N,'Normal',EvoState);
                [Population2,Fitness2] = EnvironmentalSelection2([Population2,Offspring1,Offspring2],Problem.N,'LocalC',CurEps);
            end
        end
    end
end