function run_vm_scheduler()
% run_vm_scheduler()
%   -> CASE seçimini kullanıcıdan alır (1-6)

    clc; close all;

    %% ---------- CASE Seçimi ----------
    case_id = input('Lider seçim stratejisi (CASE 1-6) seçin: ');
    if isempty(case_id) || ~ismember(case_id,1:6)
        warning('Geçersiz giriş! Varsayılan olarak CASE-1 seçildi.');
        case_id = 1;
    end
    %% ---------- Problem -----------------
    global task_lengths vm_speeds num_vms
    num_tasks = 20;      num_vms = 5;
    task_lengths = randi([100,1000],1,num_tasks);
    vm_speeds   = randi([500,1500],1,num_vms);

    %% ---------- Parametreler -------------
    SearchAgents_no = 50;   Max_iter = 150;
    dim = num_tasks;        lb = ones(1,dim); ub = num_vms*ones(1,dim);

    [bestCost,bestPos,curve] = GWO_FDB(SearchAgents_no,Max_iter,lb,ub,dim,@my_fitness,case_id);

    %% ---------- Rapor --------------------
    fprintf('CASE-%d  En iyi maliyet = %.4f\n',case_id,bestCost);
    disp('Görev-VM eşlemesi:'); disp(round(bestPos));

    figure; plot(curve,'LineWidth',2); grid on;
    xlabel('İterasyon'); ylabel('Fitness');
    title(['Yakınsama Eğrisi – CASE ',num2str(case_id)]);
end
% ---------- Fitness ----------
function cost = my_fitness(pos)
    global task_lengths vm_speeds num_vms
    vm_times = zeros(1,num_vms);
    for i = 1:length(pos)
        vm = max(1,min(num_vms,round(pos(i))));
        vm_times(vm) = vm_times(vm) + task_lengths(i)/vm_speeds(vm);
    end
    makespan = max(vm_times);  avg_u = mean(vm_times);
    load_sd  = std(vm_times);  energy = 0.5*sum(vm_times);
    cost = 0.4*makespan + 0.3*load_sd + 0.2*avg_u + 0.1*energy;
end

% ---------- Popülasyon ----------
function P = initialization(n,dim,ub,lb)
    P = randi([lb(1),ub(1)],n,dim);
end

function [Alpha_score,Alpha_pos,curve] = GWO_FDB(N,Max_iter,lb,ub,dim,fobj,case_id)
    Pos   = initialization(N,dim,ub,lb);
    vel   = 0.1*randn(N,dim);
    curve = zeros(1,Max_iter);

    for iter = 1:Max_iter
        fit = arrayfun(@(i) fobj(Pos(i,:)),1:N)';

        % ---- Lider seçimi ----
        [a,b,d] = choose_leaders(case_id,fit,Pos);
        Alpha_pos = Pos(a,:);  Beta_pos = Pos(b,:); Delta_pos = Pos(d,:);
        Alpha_score = fit(a);

        % ---- PSO + GWO güncellemesi ----
        w = 0.9 - 0.5*(iter/Max_iter);  a_coef = 2-2*(iter/Max_iter);
        for i = 1:N
            for j = 1:dim
                A1 = 2*a_coef*rand()-a_coef;  C1 = 0.5;
                A2 = 2*a_coef*rand()-a_coef;  C2 = 0.5;
                A3 = 2*a_coef*rand()-a_coef;  C3 = 0.5;
                D1 = abs(C1*Alpha_pos(j)-w*Pos(i,j));
                D2 = abs(C2*Beta_pos(j) -w*Pos(i,j));
                D3 = abs(C3*Delta_pos(j)-w*Pos(i,j));
                X1 = Alpha_pos(j)-A1*D1;
                X2 = Beta_pos(j) -A2*D2;
                X3 = Delta_pos(j)-A3*D3;
                vel(i,j) = w*vel(i,j) + ((X1+X2+X3)/3 - Pos(i,j));
                Pos(i,j) = max(min(Pos(i,j)+vel(i,j),ub(j)),lb(j));
            end
        end

        % ---- NSM (yalnız Alpha) ----
        if iter>Max_iter/2
            bestN = Alpha_pos; bestC = Alpha_score;
            for t = 1:dim
                for vm = 1:ub(t)
                    if Alpha_pos(t) ~= vm
                        tmp = Alpha_pos; tmp(t) = vm;
                        c = fobj(tmp);
                        if c < bestC, bestC = c; bestN = tmp; end
                    end
                end
            end
            Alpha_pos = bestN; Alpha_score = bestC; Pos(a,:) = Alpha_pos;
        end
        curve(iter) = Alpha_score;
    end
end
