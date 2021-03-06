% GRP2IDX  グループ化された変数からインデックスベクトルを作成
%
%   [G,GN]=GRP2IDX(S) は、グループ化された変数 S からインデックスベクトル 
%   G を作成します。S は、カテゴリ変数、数値、または論理ベクトル、文字列の
%   セルのベクトル、あるいは、各行がグループラベルを表す文字行列のいずれかに
%   なります。出力 G は、1 から異なるグループの数 K までの数を表わす整数から
%   なるベクトルです。GN は、グループラベルを現す文字列のセル配列です。
%   GN(G) は、(タイプの違いは別にして) S を作成します。
%
%   グループ変数に関する詳細は、"help groupingvariable" と入力してください。
%
%   [G,GN,GL] = GRP2IDX(S) は、グループレベルを表す列ベクトル GL を返します。
%   GL と GN のグループと順番のデータは、GL が S と同じタイプであることを
%   除けば、同じです。S が文字行列の場合、GL(G,:) は S を作成し、そうでない
%   場合は GL(G) が S を作成します。
%
%   GRP2IDX は、NaN (数値または logical)、空の文字列 (文字または文字列の
%   セル配列)、または <undefined> 値 (カテゴリ) を欠損値として扱い、G の
%   対応する行に NaN を返します。GN と GL には、欠損値に対する入力は
%   含まれません。
%
%   参考 GROUPINGVARIABLE, GRPSTATS, GSCATTER.


%   Copyright 1999-2009 The MathWorks, Inc.
