var Charts = Charts || {};
Charts.colors = ['#27ae60', '#2980b9', '#8e44ad', '#2c3e50', '#d35400', '#c0392b', '#16a085', '#f39c12'];

Charts.donut_data = function(data) {
  var donutData = {
    mainData: [],
    extraData: []
  };

  for (var i = 0; i < data.length; i++) {
    donutData.mainData.push({
      name: data[i].name,
      y: data[i].y,
      color: Charts.colors[i]
    });

    for (var j = 0; j < data[i].drilldown.data.length; j++) {
      var brightness = 0.2 - (j / data[i].drilldown.data.length) / 5 ;

      donutData.extraData.push({
        name: data[i].name + '<br/>' + data[i].drilldown.categories[j],
        y: data[i].drilldown.data[j],
        color: Highcharts.Color(Charts.colors[i]).brighten(brightness).get()
      });
    }
  }

  return donutData;
};

Charts.createDonut = function(options) {
  return $(options.selector).highcharts({
    chart: {
      type: 'pie'
    },
    title: {
      text: options.text
    },
    plotOptions: {
      pie: {
        shadow: false,
        center: ['50%', '50%'],
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: false,
          format: '<b>{point.name}</b>: {point.percentage:.1f} %',
          style: {
            color: (Highcharts.theme && Highcharts.theme.contrastTextColor) || 'black'
          }
        },
        showInLegend: true
      }
    },
    series: [
      {
        name: options.mainSeriesName,
        data: options.data.mainData,
        size: '60%',
        dataLabels: {
          formatter: function() {
            return this.y > 5 ? this.point.name : null;
          },
          color: 'white',
          distance: -30
        }
      },
      {
        name: options.extraSeriesName,
        data: options.data.extraData,
        size: '80%',
        innerSize: '60%',
        dataLabels: {
          formatter: function() {
            return this.y > 1 ? '<b>'+ this.point.name +':</b> '+ this.percentage +'%'  : null;
          }
        }
      }
    ]
  }).highcharts();
};