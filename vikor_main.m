%% VIKOR yöntemi - Excel'den okuyan ve sonuçları Excel'e yazan MATLAB çözümü
% Gereksinim: MATLAB R2020a veya sonrası (ek araç kutusu gerekmez)
% Excel düzeni (1. sayfa):
%   1. satır : boş hücre, kriter adları (C1, C2, ..., Cn)
%   2. satır : "Ağırlık", kriter ağırlıkları
%   3. satır : "Kriter Tipi", 1 = fayda, -1 = maliyet
%   4. satırdan itibaren: alternatif adı, kriter değerleri

clear; clc;

%% Girdi parametreleri
dosya = 'vikor_veri.xlsx';   % Excel dosyasının adı
v     = 0.5;                 % Strateji ağırlığı (0 <= v <= 1)

%% Adım 1: Verinin Excel'den okunması
raw      = readcell(dosya, 'Sheet', 1);
w        = cell2mat(raw(2, 2:end));
impact   = cell2mat(raw(3, 2:end));
altNames = string(raw(4:end, 1));
D        = cell2mat(raw(4:end, 2:end));

%% Adım 2-12: VIKOR hesaplamaları
[S, R, Q, rankS, rankR, rankQ, comp] = vikor(D, w, impact, v);

%% Sonuç tablosu
T = table(altNames, S, R, Q, rankS, rankR, rankQ, ...
    'VariableNames', {'Alternatif', 'S', 'R', 'Q', ...
                      'Sira_S', 'Sira_R', 'Sira_Q'});
T = sortrows(T, 'Sira_Q');
disp(T)

%% Uzlaşık çözümün yazdırılması
fprintf('\nDQ = %.4f\n', comp.DQ);
fprintf('C1 (kabul edilebilir avantaj) : %d\n', comp.C1);
fprintf('C2 (kabul edilebilir istikrar): %d\n', comp.C2);
fprintf('Uzlaşık çözüm kümesi: %s\n', ...
        strjoin(altNames(comp.set)', ', '));

%% Sonuçların Excel'e yazılması
writetable(T, dosya, 'Sheet', 'VIKOR_Rankings', ...
           'WriteMode', 'overwritesheet');

ozet = {'DQ', comp.DQ; ...
        'C1 (kabul edilebilir avantaj)', double(comp.C1); ...
        'C2 (kabul edilebilir istikrar)', double(comp.C2); ...
        'Uzlaşık çözüm kümesi', char(strjoin(altNames(comp.set)', ', '))};
writecell(ozet, dosya, 'Sheet', 'VIKOR_Rankings', ...
          'Range', sprintf('I1:J%d', size(ozet, 1)));

%% ------------------------------------------------------------------------
function [S, R, Q, rankS, rankR, rankQ, comp] = vikor(D, w, impact, v)
    D = double(D); w = double(w(:)'); impact = double(impact(:)');
    [m, n] = size(D);

    % Adım 2: Ağırlıkların normalizasyonu
    w = w / sum(w);

    % Adım 3: En iyi (f*) ve en kötü (f-) değerler
    fbest  = zeros(1, n);
    fworst = zeros(1, n);
    for j = 1:n
        if impact(j) == 1
            fbest(j)  = max(D(:, j));
            fworst(j) = min(D(:, j));
        else
            fbest(j)  = min(D(:, j));
            fworst(j) = max(D(:, j));
        end
    end

    % Adım 4: Normalize uzaklıklar (eşit sütunlarda payda 1 alınır)
    den = fbest - fworst;
    den(den == 0) = 1;
    Dn = (fbest - D) ./ den;

    % Adım 5: Ağırlıklı normalize karar matrisi
    Z = w .* Dn;

    % Adım 6-7: S (p = 1) ve R (p = sonsuz)
    S = sum(Z, 2);
    R = max(Z, [], 2);

    % Adım 8: Uç değerler
    Sstar = min(S); Sminus = max(S);
    Rstar = min(R); Rminus = max(R);

    % Adım 9: VIKOR indeksi Q
    dS = Sminus - Sstar; if dS == 0, dS = 1; end
    dR = Rminus - Rstar; if dR == 0, dR = 1; end
    Q = v * (S - Sstar) / dS + (1 - v) * (R - Rstar) / dR;

    % Adım 10: Sıralamalar (eşit değerlere ortalama sıra verilir)
    rankS = getRank(S);
    rankR = getRank(R);
    rankQ = getRank(Q);

    % Adım 11: Uzlaşık çözüm koşulları
    [Qs, idx] = sort(Q, 'ascend');
    best = idx(1);
    if m > 1
        DQ = 1 / (m - 1);
        C1 = (Qs(2) - Qs(1)) >= DQ;
    else
        DQ = NaN;
        C1 = true;
    end
    C2 = (S(best) == Sstar) || (R(best) == Rstar);

    % Adım 12: Uzlaşık çözüm kümesi
    if C1 && C2
        kume = best;                      % Tek uzlaşık çözüm
    elseif ~C1
        kume = idx(Qs - Qs(1) < DQ);      % A(1), ..., A(M)
    else
        kume = idx(1:2);                  % Yalnızca C2 sağlanmıyor: A(1), A(2)
    end

    comp.DQ  = DQ;
    comp.C1  = C1;
    comp.C2  = C2;
    comp.set = kume(:);
end

%% ------------------------------------------------------------------------
function r = getRank(x)
    % Küçükten büyüğe sıra numarası; eşit değerlere ortalama sıra verilir
    % (kayan nokta yuvarlama farkları için küçük bir tolerans kullanılır)
    x = x(:);
    [xs, idx] = sort(x, 'ascend');
    r = zeros(size(x));
    tol = 1e-10 * max(1, max(abs(x)));
    k = 1;
    while k <= numel(x)
        son = k;
        while son < numel(x) && abs(xs(son + 1) - xs(k)) <= tol
            son = son + 1;
        end
        r(idx(k:son)) = (k + son) / 2;
        k = son + 1;
    end
end