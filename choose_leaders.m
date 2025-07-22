function [a,b,d] = choose_leaders(case_id,fit,Pos)
    switch case_id
        case 1, [a,b,d] = case1(fit);
        case 2, [a,b,d] = case2(fit,Pos);
        case 3, [a,b,d] = deal(1,2,3);                         % Tam sıralı
        case 4, [a,b,d] = case4(fit,Pos);
        case 5, [a,b,d] = case5(fit);
        case 6, [a,b,d] = case6(fit,Pos);
        otherwise, error('Geçersiz case_id');
    end
end

% CASE-1 : Aç gözlü / Turnuva / Sıralı
function [a,b,d] = case1(fit)
    [~,idx] = sort(fit); a = idx(1);
    b = tournament_selection(fit,3);
    d = 3; if d>length(fit), d = idx(min(3,end)); end
end

% CASE-2 : FDB / Aç gözlü / Rulet 
function [a,b,d] = case2(fit,Pos)
    [~,a] = min(fit);  alphaP = Pos(a,:);
    FDB = arrayfun(@(i) (fit(i)-fit(a))/(norm(Pos(i,:)-alphaP)+eps),1:length(fit));
    FDB(a) = inf;  [~,b] = min(FDB);
    d = roulette_selection(fit);
end

% CASE-4 : Rulet / FDB / Aç gözlü
function [a,b,d] = case4(fit,Pos)
    a = roulette_selection(fit); alphaP = Pos(a,:);
    FDB = arrayfun(@(i) (fit(i)-fit(a))/(norm(Pos(i,:)-alphaP)+eps),1:length(fit));
    FDB(a) = inf; [~,b] = min(FDB);
    [~,d] = min(fit);
end

% CASE-5 : Rastgele / Turnuva / Sıralı
function [a,b,d] = case5(fit)
    a = randi(length(fit));
    b = tournament_selection(fit,5);
    d = 3; if d>length(fit), d = 1; end
end

%  CASE-6 : Aç gözlü-Alpha  /  FDB-Beta  /  Sequential-Delta
function [a,b,d] = case6(fit,Pos)
    % ---- Alpha  (en iyi fitness) ----
    [~,a] = min(fit);

    % ---- Beta   (FDB) -------------
    alpPos = Pos(a,:);
    FDB = arrayfun(@(i) (fit(i)-fit(a))/(norm(Pos(i,:)-alpPos)+eps), 1:length(fit));
    FDB(a) = inf;                         % Alpha hariç
    [~,b]  = min(FDB);

    % ---- Delta  (Sıralı) -----------
    seq = 1:length(fit);                  % popülasyon sırası
    d   = seq(find(~ismember(seq,[a b]),1,'first'));   % Alpha/Beta’dan farklı ilk indeks
end

% ---------- Ortak yardımcılar ---------------
function w = tournament_selection(fit,k)
    cand = randperm(length(fit),k);
    [~,ix] = min(fit(cand)); w = cand(ix);
end

function r = roulette_selection(fit)
    p = (1./(fit+eps)); p = p/sum(p);
    r = find(cumsum(p)>=rand(),1,'first');
end
