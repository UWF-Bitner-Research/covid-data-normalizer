<%@ Page Title="Home Page" Language="VB" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.vb" Inherits="CovidDataPresentation._Default" %>

<asp:Content ID="BodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <h2>Average Cases Per Day By State</h2>
    <asp:GridView AllowPaging="false" runat="server" ID="gvAverageCases" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="StateCode" HeaderText="State" />
            <asp:BoundField DataField="CasesPerDayWithoutMandate" HeaderText="Cases Without Mandate" />
            <asp:BoundField DataField="CasesPerDayWithMandate" HeaderText="Cases With Mandate" />
        </Columns>
    </asp:GridView>
    <br />
    <h2>Cases Before Vs After Mandate By State</h2>
    <asp:GridView AllowPaging="false" runat="server" ID="gvBeforeAfterMandates" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="StateCode" HeaderText="State" />
            <asp:BoundField DataField="CasesWithoutMandate" HeaderText="Cases Before Mandate" />
            <asp:BoundField DataField="CasesWithMandate" HeaderText="Cases After Mandate" />
            <asp:BoundField DataField="DidMandateReduceCases" HeaderText="Did Mandate Reduce Cases" />
            <asp:BoundField DataField="MandateEnforced" HeaderText="Was Mandate Enforced" />
        </Columns>
    </asp:GridView>
    <br /><br />

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/url-search-params/1.1.0/url-search-params.js" integrity="sha512-XITCo00srdVr9XH7ep5JEijPPpLA60TqvvoqLCyQlIdctLUjEsIRCtlgSaoj+RbsF+e/YnkaRTV/7Ei5GvVylg==" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/handlebars.js/4.7.6/handlebars.min.js"></script>
    <script type="text/javascript">
        google.charts.load('current', { 'packages': ['bar'] });
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {

            $.ajax({
                type: 'GET',
                url: 'https://localhost:44369/GetJSONForMaskMandateEfficacyOverall.aspx',
                success: function (results) {
                    var withMandate = results.split(',')[0].split(':')[1];
                    var withoutMandate = results.split(',')[1].split(':')[1];
                    withoutMandate = withoutMandate.substring(0, withoutMandate.length - 2)

                    var data = google.visualization.arrayToDataTable([
                        ["Mandate Type", "Cases Per Capita"],
                        ["With Mandate", withMandate],
                        ["Without Mandate", withoutMandate]
                    ]);

                    var options = {
                        chart: {
                            title: 'Mask Mandate Efficacy',
                            subtitle: 'Cases Per Capita Mandate vs No Mandate',
                        },
                        bars: 'horizontal'
                    };

                    var chart = new google.charts.Bar(document.getElementById('overallMandateEfficacyBarChart'));

                    chart.draw(data, google.charts.Bar.convertOptions(options));
                },
                error: function () {
                    alert('Something went wrong');
                }
            });

        }
    </script>
    <div id="overallMandateEfficacyBarChart" style="width: 900px; height: 500px;"></div>

    <script type="text/javascript">
        google.charts.load('current', { 'packages': ['corechart'] });
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
            $.ajax({
                type: 'GET',
                url: 'https://localhost:44369/JSON/GetJSONForMonthlyMaskEfficacy',
                success: function (results) {
                    var withMandate = results.split(',')[0].split(':')[1];
                    var withoutMandate = results.split(',')[1].split(':')[1];
                    withoutMandate = withoutMandate.substring(0, withoutMandate.length - 2)

                    var records = results.split('},');
                    var chartTable = [['Month', 'Cases Per Capita With Mandate', 'Cases Per Capita Without Mandate']];
                    var chartItem;
                    var i;
                    for (i = 0; i < records.length; i++) {
                        chartItem = [records[i].split(',')[2].split(':')[1].replace(/"/g, '').replace(' ', ''), parseFloat(records[i].split(',')[7].split(':')[1].replace('}', '').replace(']', '')), parseFloat(records[i].split(',')[8].split(':')[1].replace('}', '').replace(']', ''))];
                        chartTable.push(chartItem);
                    }

                    var data = google.visualization.arrayToDataTable(chartTable);

                    var options = {
                        title: 'Cases Per Capita By Month',
                        curveType: 'function',
                        legend: { position: 'bottom' }
                    };

                    var chart = new google.visualization.LineChart(document.getElementById('casesPerCapitaByMonthChart'));

                    chart.draw(data, options);
                },
                error: function () {
                    alert('Something went wrong');
                }
            });

        }
    </script>
    <div id="casesPerCapitaByMonthChart" style="width: 900px; height: 500px"></div>

        <script type="text/javascript">
            google.charts.load('current', { 'packages': ['corechart'] });
            google.charts.setOnLoadCallback(drawChart);

            function drawChart() {
                $.ajax({
                    type: 'GET',
                    url: 'https://localhost:44369/JSON/GetJSONForMonthlyEnforcedMaskEfficacy',
                    success: function (results) {
                        var withMandate = results.split(',')[0].split(':')[1];
                        var withoutMandate = results.split(',')[1].split(':')[1];
                        withoutMandate = withoutMandate.substring(0, withoutMandate.length - 2)

                        var records = results.split('},');
                        var chartTable = [['Month', 'Cases Per Capita With Enforced Mandate', 'Cases Per Capita Without Enforced Mandate']];
                        var chartItem;
                        var i;
                        for (i = 0; i < records.length; i++) {
                            chartItem = [records[i].split(',')[2].split(':')[1].replace(/"/g, '').replace(' ', ''), parseFloat(records[i].split(',')[7].split(':')[1].replace('}', '').replace(']', '')), parseFloat(records[i].split(',')[8].split(':')[1].replace('}', '').replace(']', ''))];
                            chartTable.push(chartItem);
                        }

                        var data = google.visualization.arrayToDataTable(chartTable);

                        var options = {
                            title: 'Cases Per Capita By Month - Enforced',
                            curveType: 'function',
                            legend: { position: 'bottom' }
                        };

                        var chart = new google.visualization.LineChart(document.getElementById('casesPerCapitaByMonthEnforcedChart'));

                        chart.draw(data, options);
                    },
                    error: function () {
                        alert('Something went wrong');
                    }
                });

            }
        </script>
    <div id="casesPerCapitaByMonthEnforcedChart" style="width: 900px; height: 500px"></div>

    <%--Create new charts for deaths
    prc_DeathNumbersWithAndWithoutMandate_PerCapitaByMonth_Improved
    prc_DeathNumbersWithAndWithoutMandate_PerCapitaByMonth_Enforced--%>
    <script type="text/javascript">
        google.charts.load('current', { 'packages': ['corechart'] });
        google.charts.setOnLoadCallback(drawChart);

        function drawChart() {
            $.ajax({
                type: 'GET',
                url: 'https://localhost:44369/JSON/GetJSONForMonthlyMaskDeaths',
                success: function (results) {
                    var withMandate = results.split(',')[0].split(':')[1];
                    var withoutMandate = results.split(',')[1].split(':')[1];
                    withoutMandate = withoutMandate.substring(0, withoutMandate.length - 2)

                    var records = results.split('},');
                    var chartTable = [['Month', 'Deaths Per 100k With Mandate', 'Deaths Per 100k Without Mandate']];
                    var chartItem;
                    var i;
                    for (i = 0; i < records.length; i++) {
                        chartItem = [records[i].split(',')[2].split(':')[1].replace(/"/g, '').replace(' ', ''), parseFloat(records[i].split(',')[7].split(':')[1].replace('}', '').replace(']', '')), parseFloat(records[i].split(',')[8].split(':')[1].replace('}', '').replace(']', ''))];
                        chartTable.push(chartItem);
                    }

                    var data = google.visualization.arrayToDataTable(chartTable);

                    var options = {
                        title: 'Deaths Per 100,000 By Month',
                        curveType: 'function',
                        legend: { position: 'bottom' }
                    };

                    var chart = new google.visualization.LineChart(document.getElementById('deathsPerCapitaByMonthChart'));

                    chart.draw(data, options);
                },
                error: function () {
                    alert('Something went wrong');
                }
            });

        }
    </script>
    <div id="deathsPerCapitaByMonthChart" style="width: 900px; height: 500px"></div>

        <script type="text/javascript">
            google.charts.load('current', { 'packages': ['corechart'] });
            google.charts.setOnLoadCallback(drawChart);

            function drawChart() {
                $.ajax({
                    type: 'GET',
                    url: 'https://localhost:44369/JSON/GetJSONForMonthlyEnforcedMaskDeaths',
                    success: function (results) {
                        var withMandate = results.split(',')[0].split(':')[1];
                        var withoutMandate = results.split(',')[1].split(':')[1];
                        withoutMandate = withoutMandate.substring(0, withoutMandate.length - 2)

                        var records = results.split('},');
                        var chartTable = [['Month', 'Deaths Per 100k With Enforced Mandate', 'Deaths Per 100k Without Enforced Mandate']];
                        var chartItem;
                        var i;
                        for (i = 0; i < records.length; i++) {
                            chartItem = [records[i].split(',')[2].split(':')[1].replace(/"/g, '').replace(' ', ''), parseFloat(records[i].split(',')[7].split(':')[1].replace('}', '').replace(']', '')), parseFloat(records[i].split(',')[8].split(':')[1].replace('}', '').replace(']', ''))];
                            chartTable.push(chartItem);
                        }

                        var data = google.visualization.arrayToDataTable(chartTable);

                        var options = {
                            title: 'Deaths Per 100,000 By Month - Enforced',
                            curveType: 'function',
                            legend: { position: 'bottom' }
                        };

                        var chart = new google.visualization.LineChart(document.getElementById('deathsPerCapitaByMonthEnforcedChart'));

                        chart.draw(data, options);
                    },
                    error: function () {
                        alert('Something went wrong');
                    }
                });

            }
        </script>
    <div id="deathsPerCapitaByMonthEnforcedChart" style="width: 900px; height: 500px"></div>
</asp:Content>
