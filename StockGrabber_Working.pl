#!/usr/bin/perl
use warnings;
use strict;
use LWP::Simple;
use Data::Dumper;
use LWP::UserAgent;
use HTTP::Cookies;
use JSON qw( decode_json );

my @stocks = ("ABMD","ADBE","ALGN","AMAT","ANET","ASML","AVGO","AVY","AXP","BA","BABA","BIP","CAT","CC","CGNX","CME","CNC","CPRT","DE","FMC","HD","HTHT","IDXX","IPGP","ISRG","KNX","LRCX","MLCO","MTG","MU","NOC","NVDA","NVR","ODFL","OLED","PKG","PYPL","RACE","SPGI","SQM","STM","STZ","TECK","TTWO","UNH","VLO","VMW","WB","WDC","WLK","WP","WUBA","XPO","ZTS");

my $finviz;
my $finvizC;
my $Zacks;
my $StockSelector;
my $StockSelectorV;
my $Morningstar;
my $MorningstarTake;
my $Navellier;
my $YahooAnalystJson;
my %AllStocks;
my $i = 0;

print
"Symbol,Name,Exchange,Sector,Industry,".

"Price,AverageVol,52WeekRange,PEG,Short,Target,Beta,DividendYield,FwdPE,MarketCAP,RSI,SMA20,SMA50,SMA200,PerfMn,PerfYr,Earnings,".

"TheStreetRating,MeanRecommendation,NoOfBrokers,".
      "NavellierTotalGrade,NavellierQuantitativeGrade,NavellierFundamentalGrade,NavellierSalesGrowth,NavellierOperatingMarginGrowth,NavellierEarningsGrowth,".
      "NavellierEarningsMomentum,NavellierEarningsSurprises,NavellierAnalystEarningsRevisions,NavellierCashFlow,NavellierReturnOnEquity,".
      "ZacksRating,ZacksValue,ZacksGrowth,ZacksMomentum,ZacksVGN,StockSelectorRating,StockSelectorValuation,StockSelectorGain,StockSelectorComfort,".
      "MorningstarRating,MorningstarUncertainty,MorningstarFairValueEstimate,MorningstarConsiderBuy,MorningstarConsiderSell,MorningstarEconomicMoat,MorningstarStewardshipRating,NavellierRisk\n";

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
    $AllStocks{$stocks[$i]}{"NavellierFundamentalGrade"} = "";
    $AllStocks{$stocks[$i]}{"NavellierSalesGrowth"} = "";
    $AllStocks{$stocks[$i]}{"NavellierOperatingMarginGrowth"} = "";
    $AllStocks{$stocks[$i]}{"NavellierEarningsGrowth"} = "";
    $AllStocks{$stocks[$i]}{"NavellierEarningsMomentum"} = "";
    $AllStocks{$stocks[$i]}{"NavellierEarningsSurprises"} = "";
    $AllStocks{$stocks[$i]}{"NavellierAnalystEarningsRevisions"} = "";
    $AllStocks{$stocks[$i]}{"NavellierCashFlow"} = "";
    $AllStocks{$stocks[$i]}{"NavellierReturnOnEquity"} = "";
    $AllStocks{$stocks[$i]}{"NavellierQuantitativeGrade"} = "";
    $AllStocks{$stocks[$i]}{"NavellierTotalGrade"} = "";
    $AllStocks{$stocks[$i]}{"ZacksRating"} = "";
    $AllStocks{$stocks[$i]}{"ZacksValue"} = "";
    $AllStocks{$stocks[$i]}{"ZacksGrowth"} = "";
    $AllStocks{$stocks[$i]}{"ZacksMomentum"} = "";
    $AllStocks{$stocks[$i]}{"ZacksVGM"} = "";
    $AllStocks{$stocks[$i]}{"StockSelectorRating"} = "";
    $AllStocks{$stocks[$i]}{"NavellierRisk"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarRating"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarFairValueEstimate"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarUncertainty"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarCreditRating"} = "";
    $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"} = "";

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

    $Navellier = get("http://navelliergrowth.investorplace.com/portfolio-grader/stock-report.html?t=$stocks[$i]") or $Navellier = "";
    my @NavellierRows = split("\n", $Navellier);

    for (my $x = 0; $x <= $#NavellierRows; ++$x) {
        local $_ = $NavellierRows[$x];
        if (/Volatility:<\/strong>/) {
            $AllStocks{$stocks[$i]}{"NavellierRisk"} = $NavellierRows[$x];
            $AllStocks{$stocks[$i]}{"NavellierRisk"} =~ s/.*Volatility:<\/strong>\s*//;
            $AllStocks{$stocks[$i]}{"NavellierRisk"} =~ s/<\/td>.*//;
        }
        if (/Fundamental Grade:/) {
            $AllStocks{$stocks[$i]}{"NavellierFundamentalGrade"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierFundamentalGrade"} =~ s/.*"25%">//;
            $AllStocks{$stocks[$i]}{"NavellierFundamentalGrade"} =~ s/<\/td>.*//;
            next;
        } elsif (/Sales Growth:/) {
            $AllStocks{$stocks[$i]}{"NavellierSalesGrowth"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierSalesGrowth"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierSalesGrowth"} =~ s/<\/td>.*//;
            next;
        } elsif (/Operating Margin Growth:/) {
            $AllStocks{$stocks[$i]}{"NavellierOperatingMarginGrowth"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierOperatingMarginGrowth"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierOperatingMarginGrowth"} =~ s/<\/td>.*//;
            next;
        } elsif (/Earnings Growth:/) {
            $AllStocks{$stocks[$i]}{"NavellierEarningsGrowth"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierEarningsGrowth"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierEarningsGrowth"} =~ s/<\/td>.*//;
            next;
        } elsif (/Earnings Momentum:/) {
            $AllStocks{$stocks[$i]}{"NavellierEarningsMomentum"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierEarningsMomentum"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierEarningsMomentum"} =~ s/<\/td>.*//;
            next;
        } elsif (/Earnings Surprises:/) {
            $AllStocks{$stocks[$i]}{"NavellierEarningsSurprises"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierEarningsSurprises"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierEarningsSurprises"} =~ s/<\/td>.*//;
            next;
        } elsif (/Analyst Earnings Revisions:/) {
            $AllStocks{$stocks[$i]}{"NavellierAnalystEarningsRevisions"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierAnalystEarningsRevisions"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierAnalystEarningsRevisions"} =~ s/<\/td>.*//;
            next;
        } elsif (/Cash Flow:/) {
            $AllStocks{$stocks[$i]}{"NavellierCashFlow"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierCashFlow"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierCashFlow"} =~ s/<\/td>.*//;
            next;
        } elsif (/Return on Equity:/) {
            $AllStocks{$stocks[$i]}{"NavellierReturnOnEquity"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierReturnOnEquity"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierReturnOnEquity"} =~ s/<\/td>.*//;
            next;
        } elsif (/Quantitative Grade:/) {
            $AllStocks{$stocks[$i]}{"NavellierQuantitativeGrade"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierQuantitativeGrade"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierQuantitativeGrade"} =~ s/<\/td>.*//;
            next;
        } elsif (/Total Grade:/) {
            $AllStocks{$stocks[$i]}{"NavellierTotalGrade"} = $NavellierRows[++$x];
            $AllStocks{$stocks[$i]}{"NavellierTotalGrade"} =~ s/.*<td>//;
            $AllStocks{$stocks[$i]}{"NavellierTotalGrade"} =~ s/<\/td>.*//;
            next;
        }
    }

    $Zacks = get("https://www.zacks.com/stock/quote/$stocks[$i]?q=$stocks[$i]") or $Zacks = "";
    my @ZacksRows = split("\n", $Zacks);
    for (my $x = 0; $x <= $#ZacksRows; ++$x) {
        if ($ZacksRows[$x] =~ /class="rank_view"/) {
            $AllStocks{$stocks[$i]}{"ZacksRating"} = $ZacksRows[$x+1];
            $AllStocks{$stocks[$i]}{"ZacksRating"} =~ s/^\s*//;
            $AllStocks{$stocks[$i]}{"ZacksRating"} =~ s/-.*//;
            $AllStocks{$stocks[$i]}{"ZacksRating"} =~ s/ .*//;

            my @extraInfo = split(" \| ", $ZacksRows[$x+11]);

            $AllStocks{$stocks[$i]}{"ZacksValue"} = $extraInfo[1];
            $AllStocks{$stocks[$i]}{"ZacksValue"} =~ s/.*"composite_val">//;
            $AllStocks{$stocks[$i]}{"ZacksValue"} =~ s/<\/span>.*//;
            $AllStocks{$stocks[$i]}{"ZacksGrowth"} = $extraInfo[4];
            $AllStocks{$stocks[$i]}{"ZacksGrowth"} =~ s/.*"composite_val">//;
            $AllStocks{$stocks[$i]}{"ZacksGrowth"} =~ s/<\/span>.*//;
            $AllStocks{$stocks[$i]}{"ZacksMomentum"} = $extraInfo[7];
            $AllStocks{$stocks[$i]}{"ZacksMomentum"} =~ s/.*"composite_val">//;
            $AllStocks{$stocks[$i]}{"ZacksMomentum"} =~ s/<\/span>.*//;
            $AllStocks{$stocks[$i]}{"ZacksVGM"} = $extraInfo[11];
            $AllStocks{$stocks[$i]}{"ZacksVGM"} =~ s/.*composite_val_vgm">//;
            $AllStocks{$stocks[$i]}{"ZacksVGM"} =~ s/<\/span>.*//;
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

#   Problem - Morningstar moved these to their premium service
#    $Morningstar = get("http://quotes.morningstar.com/stock/$stocks[$i]/s?t=$stocks[$i]") or $Morningstar = "";
#    my @MorningstarRows = split("\n", $Morningstar);
#    foreach my $row (@MorningstarRows) {
#        if ($row =~ /starRating":/) {
#            $AllStocks{$stocks[$i]}{"MorningstarRating"} = $row;
#            $AllStocks{$stocks[$i]}{"MorningstarRating"} =~ s/.*starRating"://;
#            $AllStocks{$stocks[$i]}{"MorningstarRating"} =~ s/\,"an.*//;
#            if ($AllStocks{$stocks[$i]}{"MorningstarRating"} eq "null") {
#              $AllStocks{$stocks[$i]}{"MorningstarRating"} = "";
#            }
#            last;
#        }
#    }
#
#    $MorningstarTake = get("http://analysisreport.morningstar.com/stock/research?t=$stocks[$i]&region=USA&culture=en-US&productcode=MLE") or $MorningstarTake = "";
#    @MorningstarRows = split("\n", $MorningstarTake);
#    my $MorningstarTakeUrl = "";
#    foreach my $row (@MorningstarRows) {
#      if ($row =~ /c-take/) {
#        $MorningstarTakeUrl = $row;
#        $MorningstarTakeUrl =~ s/.*analysisreport.morningstar.com//;
#        $MorningstarTakeUrl =~ s/".*//;
#        $MorningstarTakeUrl = "http://analysisreport.morningstar.com$MorningstarTakeUrl";
#        last;
#      }
#    }
#
#    if ($MorningstarTakeUrl ne "") {
#      $MorningstarTake = get($MorningstarTakeUrl) or die 'Unable to get morningstar with stock '.$stocks[$i];
#      @MorningstarRows = split("\n", $MorningstarTake);
#      $MorningstarTakeUrl = "";
#      for (my $x = 0; $x <= $#MorningstarRows; ++$x) {
#        if ($MorningstarRows[$x] =~ /^\s*Uncertainty/) {
#          $AllStocks{$stocks[$i]}{"MorningstarUncertainty"} = "$MorningstarRows[$x+7]";
#          $AllStocks{$stocks[$i]}{"MorningstarUncertainty"} =~ s/.*<td>//;
#          $AllStocks{$stocks[$i]}{"MorningstarUncertainty"} =~ s/<\/td>.*//;
#          $AllStocks{$stocks[$i]}{"MorningstarFairValueEstimate"} = "$MorningstarRows[$x+6]";
#          $AllStocks{$stocks[$i]}{"MorningstarFairValueEstimate"} =~ s/.*<td>//;
#          $AllStocks{$stocks[$i]}{"MorningstarFairValueEstimate"} =~ s/<span>.*//;
#        } elsif ($MorningstarRows[$x] =~ /^\s*Economic Moat/) {
#          $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"} = "$MorningstarRows[$x+4]";
#          $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"} =~ s/.*<td>//;
#          $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"} =~ s/<span>.*//;
#          $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"} = "$MorningstarRows[$x+5]";
#          $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"} =~ s/.*<td>//;
#          $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"} =~ s/<span>.*//;
#          $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"} = "$MorningstarRows[$x+6]";
#          $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"} =~ s/.*<td>//;
#          $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"} =~ s/<\/td>.*//;
#        } elsif ($MorningstarRows[$x] =~ /id="creditStewardship"/) {
#          $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"} = "$MorningstarRows[$x+2]";
#          $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"} =~ s/.*colspan="3">//;
#          $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"} =~ s/<\/td>.*//;
#        }
#      }
#    }

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
    $AllStocks{$stocks[$i]}{"NavellierTotalGrade"}.",".
    $AllStocks{$stocks[$i]}{"NavellierQuantitativeGrade"}.",".
    $AllStocks{$stocks[$i]}{"NavellierFundamentalGrade"}.",".
    $AllStocks{$stocks[$i]}{"NavellierSalesGrowth"}.",".
    $AllStocks{$stocks[$i]}{"NavellierOperatingMarginGrowth"}.",".
    $AllStocks{$stocks[$i]}{"NavellierEarningsGrowth"}.",".
    $AllStocks{$stocks[$i]}{"NavellierEarningsMomentum"}.",".
    $AllStocks{$stocks[$i]}{"NavellierEarningsSurprises"}.",".
    $AllStocks{$stocks[$i]}{"NavellierAnalystEarningsRevisions"}.",".
    $AllStocks{$stocks[$i]}{"NavellierCashFlow"}.",".
    $AllStocks{$stocks[$i]}{"NavellierReturnOnEquity"}.",".
    $AllStocks{$stocks[$i]}{"ZacksRating"}.",".
    $AllStocks{$stocks[$i]}{"ZacksValue"}.",".
    $AllStocks{$stocks[$i]}{"ZacksGrowth"}.",".
    $AllStocks{$stocks[$i]}{"ZacksMomentum"}.",".
    $AllStocks{$stocks[$i]}{"ZacksVGM"}.",".
    $AllStocks{$stocks[$i]}{"StockSelectorRating"}.",".
    $AllStocks{$stocks[$i]}{"StockSelectorValuation"}.",".
    $AllStocks{$stocks[$i]}{"StockSelectorGain"}.",".
    $AllStocks{$stocks[$i]}{"StockSelectorComfort"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarRating"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarUncertainty"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarFairValueEstimate"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarConsiderBuy"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarConsiderSell"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarEconomicMoat"}.",".
    $AllStocks{$stocks[$i]}{"MorningstarStewardshipRating"}.",".
    $AllStocks{$stocks[$i]}{"NavellierRisk"}."\n";


}

#print Dumper(\%AllStocks);
