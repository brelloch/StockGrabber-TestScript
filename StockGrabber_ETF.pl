#!/usr/bin/perl
use warnings;
use strict;
use LWP::Simple;
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Cookies;
use JSON qw( decode_json );

my @stocks = ("ACIM","ACWF","ACWI","AGG","AGZ","AOK","BFOR","BND","BNDX","BSCI","BSCJ","BSCL","CDC","CFA","CFO","CMDT","CMF","CSA","CSM","CZA","DBKO","DES","DFJ","DGRO","DGRW","DGT","DHVW","DIA","DIVY","DLS","DON","DSI","DTD","DTN","DVY","DWPP","EPS","EQAL","EQLT","EQWL","EQWM","EUSA","EVX","EWMC","EXT","EZM","FAB","FAD","FDIS","FDN","FDT","FEX","FFR","FIDU","FIW","FLOT","FLRN","FLTB","FLTR","FMF","FNDA","FNDB","FNDC","FNDX","FNX","FNY","FONE","FPX","FREL","FSTA","FTA","FTC","FTCS","FTEC","FTLS","FTSM","FUTY","FV","FVD","FXH","FXU","FYC","FYLD","GAA","GAL","GII","GNMA","GQRE","IBCD","IBDD","IBDH","IBMI","ICSH","ICVT","IDU","IGM","IGSB","IGV","IHDG","IHF","IHI","IJH","IJJ","IJK","IJR","IJS","IJT","INKM","IOO","ISTB","ITA","ITOT","IUSG","IUSV","IVE","IVOG","IVOO","IVOV","IVV","IVW","IWB","IWD","IWF","IWL","IWP","IWR","IWS","IWV","IWX","IWY","IYC","IYH","IYJ","IYK","IYW","IYY","JKD","JKE","JKF","JKG","JKH","JKI","JKJ","KIE","KLDW","KNOW","LDRI","LRGF","MBB","MDY","MDYG","MDYV","MEAR","MGC","MGK","MGV","MMTM","MNA","MOAT","MTUM","MUNI","NFO","OEF","ONEQ","OUSA","PDN","PEY","PFM","PGHY","PKW","PNQI","PPA","PRF","PRFZ","PSCU","PSJ","PSL","PTMC","PTNQ","PUI","PXLG","PXLV","PXMG","QAI","QDEF","QDF","QDYN","QED","QMN","QQEW","QQQ","QQQE","QSY","QTEC","QUAL","QUS","RAVI","RDIV","RDVY","REGL","ROUS","RWK","RWL","RXI","RYH","RYT","RYU","SCHA","SCHB","SCHD","SCHG","SCHM","SCHV","SCHX","SCHZ","SCIU","SCJ","SCZ","SDOG","SDY","SIZE","SKYY","SLQD","SLY","SLYG","SLYV","SMDV","SMLF","SMMU","SPAB","SPHD","SPLG","SPMD","SPSB","SPTM","SPY","SPYB","SPYG","SPYV","SUSA","SYE","SYG","SYLD","TFLO","TILT","TIPX","ULST","URTH","USMV","VB","VBK","VBR","VCR","VDC","VGSH","VGT","VHT","VIG","VIOG","VIOO","VIOV","VIS","VLU","VLUE","VMBS","VO","VOE","VONE","VONG","VONV","VOO","VOOG","VOOV","VOT","VPU","VT","VTHR","VTI","VTV","VUG","VUSE","VV","VXF","VYM","XAR","XHE","XLG","XLK","XLP","XLV","XMLV","XNTK","XRLV","XSLV","XTL");

my $finviz;
my $finvizC;
my $Zacks;
my $Lipper;
my $StockSelector;
my $StockSelectorV;
my $Morningstar;
my $MorningstarRisk;
my $Navellier;
my $YahooAnalystJson;
my %AllStocks;
my $i = 0;

print
"Symbol,Name,Exchange,Sector,Industry,".

"Price,AverageVol,52WeekRange,PEG,Short,Target,Beta,DividendYield,FwdPE,MarketCAP,RSI,SMA20,SMA50,SMA200,PerfMn,PerfYr,Earnings,".

"TheStreetRating,MeanRecommendation,NoOfBrokers,".

"ZacksRank,ZacksRisk,StockSelectorRating,StockSelectorValuation,StockSelectorGain,StockSelectorComfort,".

"MorningstarFundCategory,MorningstarRating,MorningstarReturn3,MorningstarReturn5,MorningstarConsiderBuy,MorningstarConsiderSell,MorningstarEconomicMoat,MorningstarStewardshipRating,".

"LipperTotalReturn,LipperConsistentReturn,LipperCapitalPreservation,LipperLowExpense,LipperTaxEfficiency\n";

for (my $i=0; $i < @stocks; $i++){
    $AllStocks{$stocks[$i]}{"Symbol"} = "";
    $AllStocks{$stocks[$i]}{"Name"} = "";
    $AllStocks{$stocks[$i]}{"Exchange"} = "";
    $AllStocks{$stocks[$i]}{"Sector"} = "";
    $AllStocks{$stocks[$i]}{"Industry"} = "";
    $AllStocks{$stocks[$i]}{"Price"} = "";
    $AllStocks{$stocks[$i]}{"AverageVol"} = "";
    $AllStocks{$stocks[$i]}{"52WeekRange"} = "";
    $AllStocks{$stocks[$i]}{"PEG"} = "";
    $AllStocks{$stocks[$i]}{"Short"} = "";
    $AllStocks{$stocks[$i]}{"Target"} = "";
    $AllStocks{$stocks[$i]}{"Beta"} = "";
    $AllStocks{$stocks[$i]}{"DividendYield"} = "";
    $AllStocks{$stocks[$i]}{"FwdPE"} = "";
    $AllStocks{$stocks[$i]}{"MarketCAP"} = "";
    $AllStocks{$stocks[$i]}{"RSI"} = "";
    $AllStocks{$stocks[$i]}{"SMA20"} = "";
    $AllStocks{$stocks[$i]}{"SMA50"} = "";
    $AllStocks{$stocks[$i]}{"SMA200"} = "";
    $AllStocks{$stocks[$i]}{"PerfMn"} = "";
    $AllStocks{$stocks[$i]}{"PerfYr"} = "";
    $AllStocks{$stocks[$i]}{"Earnings"} = "";
    $AllStocks{$stocks[$i]}{"TheStreetRating"} = "";
    $AllStocks{$stocks[$i]}{"MeanRecommendation"} = "";
    $AllStocks{$stocks[$i]}{"NoOfBrokers"} = "";
    $AllStocks{$stocks[$i]}{"ZacksRank"} = "";
    $AllStocks{$stocks[$i]}{"ZacksRisk"} = "";
    $AllStocks{$stocks[$i]}{"StockSelectorRating"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarFundCategory"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarRating"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarReturn3"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarReturn5"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarCreditRating"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"} = "";
    $AllStocks{$stocks[$i]}{"LipperTotalReturn"} = "";
    $AllStocks{$stocks[$i]}{"LipperConsistentReturn"} = "";
    $AllStocks{$stocks[$i]}{"LipperCapitalPreservation"} = "";
    $AllStocks{$stocks[$i]}{"LipperLowExpense"} = "";
    $AllStocks{$stocks[$i]}{"LipperTaxEfficiency"} = "";

    $YahooAnalystJson = get("https://query2.finance.yahoo.com/v10/finance/quoteSummary/$stocks[$i]?formatted=true&crumb=8pdH9baSHsw&lang=en-US&region=US&modules=upgradeDowngradeHistory%2CrecommendationTrend%2CfinancialData%2CearningsHistory%2CearningsTrend%2CindustryTrend&corsDomain=finance.yahoo.com") or $YahooAnalystJson = "";
    if ($YahooAnalystJson ne "") {
        my $YahooAnalystObject = decode_json($YahooAnalystJson);
        $AllStocks{$stocks[$i]}{"MeanRecommendation"} = $YahooAnalystObject->{'quoteSummary'}{'result'}[0]{'financialData'}{'recommendationMean'}{'raw'};
        $AllStocks{$stocks[$i]}{"NoOfBrokers"} = $YahooAnalystObject->{'quoteSummary'}{'result'}[0]{'financialData'}{'numberOfAnalystOpinions'}{'raw'};;
    }

    my $ua = LWP::UserAgent->new();
    $ua->agent("Mozilla/8.0");

    my $req = new HTTP::Request GET => 'https://www.thestreet.com/quote/'.$stocks[$i].'/details/analyst-ratings.html';
    my $res = $ua->request($req) or die 'Unable to get page thestreet with stock '.$stocks[$i];;
    my $content = $res->content;

    my @TheStreetRows = split("\n", $res->content);
    foreach my $row (@TheStreetRows) {
        if ($row =~ /class="quote-nav-rating-qr-rating/) {
            $AllStocks{$stocks[$i]}{"TheStreetRating"} = $row;
            $AllStocks{$stocks[$i]}{"TheStreetRating"} =~ s/.*<span class="quote-nav-rating-qr-rating \S+">//;
            $AllStocks{$stocks[$i]}{"TheStreetRating"} =~ s/<sub>.*//;

            last;
        }
    }

    $finvizC = get("https://www.finviz.com/quote.ashx?t=$stocks[$i]") or $finvizC = "";
    my @finvizCRows = split("\n", $finvizC);
    for (my $x = 0; $x <= $#finvizCRows; ++$x) {
        if ($finvizCRows[$x] =~ /class="fullview-ticker" id="ticker"/) {
            $AllStocks{$stocks[$i]}{"Symbol"} = $finvizCRows[$x];
            $AllStocks{$stocks[$i]}{"Symbol"} =~ s/.* class="fullview-ticker" id="ticker">//;
            $AllStocks{$stocks[$i]}{"Symbol"} =~ s/<\/a>.*//;
        }
        if ($finvizCRows[$x] =~ /span class="body-table">/) {
            $AllStocks{$stocks[$i]}{"Exchange"} = $finvizCRows[$x];
            $AllStocks{$stocks[$i]}{"Exchange"} =~ s/.*<span class="body-table">//;
            $AllStocks{$stocks[$i]}{"Exchange"} =~ s/<\/span>.*//;
#        }
#   Problem - Comma "," in Company Name causes result to span 2 cells
#        if ($finvizCRows[$x] =~ /span class="body-table">/) {
#            $AllStocks{$stocks[$i]}{"Name"} = $finvizCRows[$x+1];
#            $AllStocks{$stocks[$i]}{"Name"} =~ s/.*<b>//;
#            $AllStocks{$stocks[$i]}{"Name"} =~ s/<\/b>.*//;
#
#            my @extraInfo = split(" \| ", $finvizCRows[$x+2]);
#
#   Problem - Sector captures only first word ex. for "Basic Materials", only displays "Basic"
#            $AllStocks{$stocks[$i]}{"Sector"} = $extraInfo[4];
#            $AllStocks{$stocks[$i]}{"Sector"} =~ s/.*class="tab-link">//;
#            $AllStocks{$stocks[$i]}{"Sector"} =~ s/<\/a>.*//;
#   Problem - Industry captures only first word ex. for "Semiconductor - Broad Line", only displays "Semiconductor"
#            $AllStocks{$stocks[$i]}{"Industry"} = $extraInfo[8];
#            $AllStocks{$stocks[$i]}{"Industry"} =~ s/.*class="tab-link">//;
#            $AllStocks{$stocks[$i]}{"Industry"} =~ s/<\/a>.*//;
        }
    }

    $finviz = get("https://www.finviz.com/quote.ashx?t=$stocks[$i]") or $finviz = "";
    my @finvizRows = split("\n", $finviz);
    for (my $x = 0; $x <= $#finvizRows; ++$x) {
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"MarketCAP"} = $finvizRows[$x+8];
            $AllStocks{$stocks[$i]}{"MarketCAP"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"MarketCAP"} =~ s/<\/b>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"FwdPE"} = $finvizRows[$x+9];
            $AllStocks{$stocks[$i]}{"FwdPE"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"FwdPE"} =~ s/<\/b>.*//;
            $AllStocks{$stocks[$i]}{"FwdPE"} =~ s/.*<span style="color:#.*;">//;
            $AllStocks{$stocks[$i]}{"FwdPE"} =~ s/<\/span>//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"PerfMn"} = $finvizRows[$x+13];
            $AllStocks{$stocks[$i]}{"PerfMn"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"PerfMn"} =~ s/<\/b>.*//;
            $AllStocks{$stocks[$i]}{"PerfMn"} =~ s/.*<span style="color:#.*;">//;
            $AllStocks{$stocks[$i]}{"PerfMn"} =~ s/<\/span>//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"PEG"} = $finvizRows[$x+17];
            $AllStocks{$stocks[$i]}{"PEG"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"PEG"} =~ s/<\/b>.*//;
            $AllStocks{$stocks[$i]}{"PEG"} =~ s/.*<span style="color:#.*;">//;
            $AllStocks{$stocks[$i]}{"PEG"} =~ s/<\/span>//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"Short"} = $finvizRows[$x+28];
            $AllStocks{$stocks[$i]}{"Short"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"Short"} =~ s/<\/b>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"Target"} = $finvizRows[$x+36];
            $AllStocks{$stocks[$i]}{"Target"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"Target"} =~ s/<\/b>.*//;
            $AllStocks{$stocks[$i]}{"Target"} =~ s/.*<span style="color:#.*;">//;
            $AllStocks{$stocks[$i]}{"Target"} =~ s/<\/span>//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"PerfYr"} = $finvizRows[$x+37];
            $AllStocks{$stocks[$i]}{"PerfYr"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"PerfYr"} =~ s/<\/b>.*//;
            $AllStocks{$stocks[$i]}{"PerfYr"} =~ s/.*<span style="color:#.*;">//;
            $AllStocks{$stocks[$i]}{"PerfYr"} =~ s/<\/span>//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"52WeekRange"} = $finvizRows[$x+44];
            $AllStocks{$stocks[$i]}{"52WeekRange"} =~ s/.*<small>//;
            $AllStocks{$stocks[$i]}{"52WeekRange"} =~ s/<\/small>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"Beta"} = $finvizRows[$x+53];
            $AllStocks{$stocks[$i]}{"Beta"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"Beta"} =~ s/<\/b>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"DividendYield"} = $finvizRows[$x+56];
            $AllStocks{$stocks[$i]}{"DividendYield"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"DividendYield"} =~ s/<\/b>.*//;
            $AllStocks{$stocks[$i]}{"DividendYield"} =~ s/.*<span style="color:#.*;">//;
            $AllStocks{$stocks[$i]}{"DividendYield"} =~ s/<\/span>//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"RSI"} = $finvizRows[$x+68];
            $AllStocks{$stocks[$i]}{"RSI"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"RSI"} =~ s/<\/b>.*//;
            $AllStocks{$stocks[$i]}{"RSI"} =~ s/.*<span style="color:#.*;">//;
            $AllStocks{$stocks[$i]}{"RSI"} =~ s/<\/span>//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"Earnings"} = $finvizRows[$x+82];
            $AllStocks{$stocks[$i]}{"Earnings"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"Earnings"} =~ s/<\/b>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"AverageVol"} = $finvizRows[$x+84];
            $AllStocks{$stocks[$i]}{"AverageVol"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"AverageVol"} =~ s/<\/b>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"Price"} = $finvizRows[$x+85];
            $AllStocks{$stocks[$i]}{"Price"} =~ s/.*<b>//;
            $AllStocks{$stocks[$i]}{"Price"} =~ s/<\/b>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"SMA20"} = $finvizRows[$x+89];
            $AllStocks{$stocks[$i]}{"SMA20"} =~ s/.*;">//;
            $AllStocks{$stocks[$i]}{"SMA20"} =~ s/<\/span>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"SMA50"} = $finvizRows[$x+90];
            $AllStocks{$stocks[$i]}{"SMA50"} =~ s/.*;">//;
            $AllStocks{$stocks[$i]}{"SMA50"} =~ s/<\/span>.*//;
        }
        if ($finvizRows[$x] =~ /class="snapshot-td2-cp"/) {
            $AllStocks{$stocks[$i]}{"SMA200"} = $finvizRows[$x+91];
            $AllStocks{$stocks[$i]}{"SMA200"} =~ s/.*;">//;
            $AllStocks{$stocks[$i]}{"SMA200"} =~ s/<\/span>.*//;
            last;
        }
    }

    $Zacks = get("https://www.zacks.com/stock/quote/$stocks[$i]?q=$stocks[$i]") or $Zacks = "";
    my @ZacksRows = split("\n", $Zacks);
    for (my $x = 0; $x <= $#ZacksRows; ++$x) {
        if ($ZacksRows[$x] =~ /class="callout_box3 pad10"/) {
            $AllStocks{$stocks[$i]}{"ZacksRank"} = $ZacksRows[$x+6];
            $AllStocks{$stocks[$i]}{"ZacksRank"} =~ s/.*">//;
            $AllStocks{$stocks[$i]}{"ZacksRank"} =~ s/<\/span>.*//;
        }
        if ($ZacksRows[$x] =~ /class="callout_box3 pad10"/) {
            $AllStocks{$stocks[$i]}{"ZacksRisk"} = $ZacksRows[$x+10];
            $AllStocks{$stocks[$i]}{"ZacksRisk"} =~ s/.*">//;
            $AllStocks{$stocks[$i]}{"ZacksRisk"} =~ s/<\/span>.*//;
            last;
        }
    }

    $Lipper = get("http://www.funds.reuters.wallst.com/US/etfs/overview.asp?symbol=$stocks[$i]") or $Lipper = "";
    my @LipperRows = split("\n", $Lipper);
    for (my $x = 0; $x <= $#LipperRows; ++$x) {
        if ($LipperRows[$x] =~ /class="mainSection mainSectionLastUS"/) {
            $AllStocks{$stocks[$i]}{"LipperTotalReturn"} = $LipperRows[$x];
            $AllStocks{$stocks[$i]}{"LipperTotalReturn"} =~ s/.*<div ratingtype="Total Return" rating="//;
            $AllStocks{$stocks[$i]}{"LipperTotalReturn"} =~ s/".*//;
        }
        if ($LipperRows[$x] =~ /class="mainSection mainSectionLastUS"/) {
            $AllStocks{$stocks[$i]}{"LipperConsistentReturn"} = $LipperRows[$x];
            $AllStocks{$stocks[$i]}{"LipperConsistentReturn"} =~ s/.*<div ratingtype="Consistent Return" rating="//;
            $AllStocks{$stocks[$i]}{"LipperConsistentReturn"} =~ s/".*//;
        }
        if ($LipperRows[$x] =~ /class="mainSection mainSectionLastUS"/) {
            $AllStocks{$stocks[$i]}{"LipperCapitalPreservation"} = $LipperRows[$x];
            $AllStocks{$stocks[$i]}{"LipperCapitalPreservation"} =~ s/.*<div ratingtype="Capital Preservation" rating="//;
            $AllStocks{$stocks[$i]}{"LipperCapitalPreservation"} =~ s/".*//;
        }
        if ($LipperRows[$x] =~ /class="mainSection mainSectionLastUS"/) {
            $AllStocks{$stocks[$i]}{"LipperLowExpense"} = $LipperRows[$x];
            $AllStocks{$stocks[$i]}{"LipperLowExpense"} =~ s/.*<div ratingtype="Low Expense" rating="//;
            $AllStocks{$stocks[$i]}{"LipperLowExpense"} =~ s/".*//;
        }
        if ($LipperRows[$x] =~ /class="mainSection mainSectionLastUS"/) {
            $AllStocks{$stocks[$i]}{"LipperTaxEfficiency"} = $LipperRows[$x];
            $AllStocks{$stocks[$i]}{"LipperTaxEfficiency"} =~ s/.*<div ratingtype="Tax Efficiency//;
            $AllStocks{$stocks[$i]}{"LipperTaxEfficiency"} =~ s/.*rating="//;
            $AllStocks{$stocks[$i]}{"LipperTaxEfficiency"} =~ s/".*//;
            last;
        }
    }
    
    $StockSelector = get("http://www.stockselector.com/ranking.asp?symbol=$stocks[$i]") or $StockSelector = "";
    my @StockSelectorRows = split("\n", $StockSelector);
    foreach my $row (@StockSelectorRows) {
        if ($row =~ /overall rank of/) {
            $AllStocks{$stocks[$i]}{"StockSelectorRating"} = $row;
            $AllStocks{$stocks[$i]}{"StockSelectorRating"} =~ s/.*overall rank of <b>//;
            $AllStocks{$stocks[$i]}{"StockSelectorRating"} =~ s/\ out.*//;
            last;
        }
    }

    $StockSelectorV = get("http://www.stockselector.com/valuations.asp?symbol=$stocks[$i]") or $StockSelectorV = "";
    my @StockSelectorVRows = split("\n", $StockSelectorV);
    foreach my $row (@StockSelectorVRows) {
        if ($row =~ /Average Valuation:/) {
            $AllStocks{$stocks[$i]}{"StockSelectorValuation"} = $row;
            $AllStocks{$stocks[$i]}{"StockSelectorValuation"} =~ s/.*Average Valuation: <\/b>//;
            $AllStocks{$stocks[$i]}{"StockSelectorValuation"} =~ s/<\/font>.*//;
        } elsif ($row =~ /Suggested Gain:/) {
            $AllStocks{$stocks[$i]}{"StockSelectorGain"} = $row;
            $AllStocks{$stocks[$i]}{"StockSelectorGain"} =~ s/.*Suggested Gain: <\/b>//;
            $AllStocks{$stocks[$i]}{"StockSelectorGain"} =~ s/<\/font>.*//;
        } elsif ($row =~ /Comfort Level:/) {
            $AllStocks{$stocks[$i]}{"StockSelectorComfort"} = $row;
            $AllStocks{$stocks[$i]}{"StockSelectorComfort"} =~ s/.*Comfort Level: <\/b>//;
            $AllStocks{$stocks[$i]}{"StockSelectorComfort"} =~ s/<\/font>.*//;
            last;
        }
    }

    $Morningstar = get("https://www.morningstar.com/etfs/xnas/$stocks[$i]/quote.html") or $Morningstar = "";
    my @MorningstarRows = split("\n", $Morningstar);
    foreach my $row (@MorningstarRows) {
        if ($row =~ /starRating":/) {
            $AllStocks{$stocks[$i]}{"MorningstarRating"} = $row;
            $AllStocks{$stocks[$i]}{"MorningstarRating"} =~ s/.*starRating"://;
            $AllStocks{$stocks[$i]}{"MorningstarRating"} =~ s/\,"an.*//;
            if ($AllStocks{$stocks[$i]}{"MorningstarRating"} eq "null") {
              $AllStocks{$stocks[$i]}{"MorningstarRating"} = "";
            }
        if ($row =~ /fundCategoryName":/) {
            $AllStocks{$stocks[$i]}{"MorningstarFundCategory"} = $row;
            $AllStocks{$stocks[$i]}{"MorningstarFundCategory"} =~ s/.*fundCategoryName":"//;
            $AllStocks{$stocks[$i]}{"MorningstarFundCategory"} =~ s/\","se.*//;
            if ($AllStocks{$stocks[$i]}{"MorningstarFundCategory"} eq "null") {
              $AllStocks{$stocks[$i]}{"MorningstarFundCategory"} = "";
            }
            }
            last;
        }
    }
#    $MorningstarRisk = get("http://performance.morningstar.com/funds/etf/ratings-risk.action?t=$stocks[$i]&region=usa&culture=en_US") or $MorningstarRisk = "";
#    my @MorningstarRiskRows = split("\n", $MorningstarRisk);
#    for (my $x = 0; $x <= $#MorningstarRiskRows; ++$x) {
#        if ($MorningstarRiskRows[$x] =~ /class="r_table1 text2"/) {
#            $AllStocks{$stocks[$i]}{"MorningstarReturn3"} = "$MorningstarRiskRows[$x+11]";
#            $AllStocks{$stocks[$i]}{"MorningstarReturn3"} =~ s/.*left">//;
#            $AllStocks{$stocks[$i]}{"MorningstarReturn3"} =~ s/<\/td>.*//;
#            $AllStocks{$stocks[$i]}{"MorningstarReturn5"} = "$MorningstarRiskRows[$x+12]";
#            $AllStocks{$stocks[$i]}{"MorningstarReturn5"} =~ s/.*left">//;
#            $AllStocks{$stocks[$i]}{"MorningstarReturn5"} =~ s/<\/td>.*//;
#        } elsif ($MorningstarRiskRows[$x] =~ /^\s*Economic Moat/) {
#            $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"} = "$MorningstarRiskRows[$x+4]";
#            $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"} =~ s/.*<td>//;
#            $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"} =~ s/<span>.*//;
#            $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"} = "$MorningstarRiskRows[$x+5]";
#            $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"} =~ s/.*<td>//;
#            $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"} =~ s/<span>.*//;
#            $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"} = "$MorningstarRiskRows[$x+6]";
#            $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"} =~ s/.*<td>//;
#            $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"} =~ s/<\/td>.*//;
#        } elsif ($MorningstarRiskRows[$x] =~ /id="creditStewardship"/) {
#            $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"} = "$MorningstarRiskRows[$x+2]";
#            $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"} =~ s/.*colspan="3">//;
#            $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"} =~ s/<\/td>.*//;
#        }
#      }

    print
    $AllStocks{$stocks[$i]}{"Symbol"}.",".
    $AllStocks{$stocks[$i]}{"Name"}.",".
    $AllStocks{$stocks[$i]}{"Exchange"}.",".
    $AllStocks{$stocks[$i]}{"Sector"}.",".
    $AllStocks{$stocks[$i]}{"Industry"}.",".
    $AllStocks{$stocks[$i]}{"Price"}.",".
    $AllStocks{$stocks[$i]}{"AverageVol"}.",".
    $AllStocks{$stocks[$i]}{"52WeekRange"}.",".
    $AllStocks{$stocks[$i]}{"PEG"}.",".
    $AllStocks{$stocks[$i]}{"Short"}.",".
    $AllStocks{$stocks[$i]}{"Target"}.",".
    $AllStocks{$stocks[$i]}{"Beta"}.",".
    $AllStocks{$stocks[$i]}{"DividendYield"}.",".
    $AllStocks{$stocks[$i]}{"FwdPE"}.",".
    $AllStocks{$stocks[$i]}{"MarketCAP"}.",".
    $AllStocks{$stocks[$i]}{"RSI"}.",".
    $AllStocks{$stocks[$i]}{"SMA20"}.",".
    $AllStocks{$stocks[$i]}{"SMA50"}.",".
    $AllStocks{$stocks[$i]}{"SMA200"}.",".
    $AllStocks{$stocks[$i]}{"PerfMn"}.",".
    $AllStocks{$stocks[$i]}{"PerfYr"}.",".
    $AllStocks{$stocks[$i]}{"Earnings"}.",".
    $AllStocks{$stocks[$i]}{"TheStreetRating"}.",".
    $AllStocks{$stocks[$i]}{"MeanRecommendation"}.",".
    $AllStocks{$stocks[$i]}{"NoOfBrokers"}.",".
    $AllStocks{$stocks[$i]}{"ZacksRank"}.",".
    $AllStocks{$stocks[$i]}{"ZacksRisk"}.",".
    $AllStocks{$stocks[$i]}{"StockSelectorRating"}.",".
    $AllStocks{$stocks[$i]}{"StockSelectorValuation"}.",".
    $AllStocks{$stocks[$i]}{"StockSelectorGain"}.",".
    $AllStocks{$stocks[$i]}{"StockSelectorComfort"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarFundCategory"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarRating"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarReturn3"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarReturn5"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"}.",".
    $AllStocks{$stocks[$i]}{"LipperTotalReturn"}.",".
    $AllStocks{$stocks[$i]}{"LipperConsistentReturn"}.",".
    $AllStocks{$stocks[$i]}{"LipperCapitalPreservation"}.",".
    $AllStocks{$stocks[$i]}{"LipperLowExpense"}.",".
    $AllStocks{$stocks[$i]}{"LipperTaxEfficiency"}."\n";


}

#print Dumper(\%AllStocks);
